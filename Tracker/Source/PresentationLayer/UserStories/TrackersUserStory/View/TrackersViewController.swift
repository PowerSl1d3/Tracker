//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Олег Аксененко on 28.05.2023.
//

import UIKit

final class TrackersViewController: UIViewController {
    private enum Constants {
        static let emptyFilter = ""
    }

    private let searchTextField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.font = .ypRegularFont(ofSize: 17)
        searchTextField.placeholder = "Поиск"
        searchTextField.clearButtonMode = .never
        searchTextField.returnKeyType = .search

        return searchTextField
    }()

    private let cancelSearchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.ypBlue, for: .normal)

        return button
    }()

    private var defaultModeConstraints = [NSLayoutConstraint]()
    private var searchModeConstraints = [NSLayoutConstraint]()

    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.tintColor = .ypBlue
        datePicker.locale = Locale(identifier: "ru-RU")

        return datePicker
    }()

    private let trackerCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .ypWhite

        return collectionView
    }()

    let placeholderView: TrackersPlaceholderStarView = {
        let placeholderView = TrackersPlaceholderStarView()
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.titleLabel.text = "Что будем отслеживать?"
        placeholderView.isHidden = true

        return placeholderView
    }()

    private var currentDate = Date() {
        didSet {
            reloadTrackers(filterText: Constants.emptyFilter)
        }
    }

    private let trackersStorageService: TrackersStorageService = TrackersStorageServiceImpl.shared

    private var currentDateCategories: [TrackerCategory] {
        let filteredCategories = trackersStorageService.categories.compactMap { (category: TrackerCategory) -> TrackerCategory? in
            let filteredTrackers = category.trackers.filter { tracker in
                guard let currentWeekDay = currentDate.weekDay else {
                    return false
                }

                return tracker.schedule == .eventSchedule || tracker.schedule.contains(currentWeekDay)
            }

            guard !filteredTrackers.isEmpty else { return nil }

            return TrackerCategory(trackers: filteredTrackers, title: category.title)
        }

        return filteredCategories
    }

    private var completedTrackers = [TrackerRecord]()
    private var visibleCategories = [TrackerCategory]() {
        didSet {
            placeholderView.isHidden = !visibleCategories.isEmpty
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        visibleCategories = currentDateCategories
        trackersStorageService.add(delegate: self)

        view.backgroundColor = .ypWhite

        datePicker.addTarget(self, action: #selector(didChangeDate), for: .valueChanged)
        cancelSearchButton.addTarget(self, action: #selector(didTapCancelSearchButton), for: .touchUpInside)
        searchTextField.addTarget(self, action: #selector(didChangeSearchTextField), for: .editingChanged)

        searchTextField.delegate = self
        trackerCollectionView.dataSource = self
        trackerCollectionView.delegate = self

        trackerCollectionView.register(
            TrackerCardCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackerCardCollectionViewCell.reuseIdentifier
        )

        trackerCollectionView.register(
            TrackerCardsCategoryHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerCardsCategoryHeaderView.reuseIdentifier
        )

        trackerCollectionView.addSubview(placeholderView)
        view.addSubview(searchTextField)
        view.addSubview(trackerCollectionView)

        configureNavigationBar()
        setupConstraints()
    }
}

extension TrackersViewController: UISearchTextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        view.addSubview(cancelSearchButton)
        defaultModeConstraints.forEach { $0.isActive = false }
        searchModeConstraints.forEach { $0.isActive = true }
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        cancelSearchButton.removeFromSuperview()
        defaultModeConstraints.forEach { $0.isActive = true }
        searchModeConstraints.forEach { $0.isActive = false }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let category = visibleCategories[safe: section] else { return .zero }

        return category.trackers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCardCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? TrackerCardCollectionViewCell

        guard let cell,
              let category = visibleCategories[safe: indexPath.section],
              let cellModel = category.trackers[safe: indexPath.row] else {
            return UICollectionViewCell()
        }

        let completedDays = completedTrackers.filter { $0.id == cellModel.id }
        let currentDateTrackerRecord = completedDays.first { $0.date == currentDate }

        cell.prepareForReuse()

        cell.configure(
            cellModel: cellModel,
            completedDays: completedDays.count,
            isCurrentDateCompleted: currentDateTrackerRecord != nil,
            isFutureDate: currentDate > Date()
        ) { [weak self] cellModel in
            guard let self, let cellModel else { return }

            if let currentDateTrackerRecord {
                let currentDayTrackerRecordIndex = completedTrackers.firstIndex(of: currentDateTrackerRecord)

                guard let currentDayTrackerRecordIndex else {
                    assertionFailure("Invalid completed trackers state")

                    return
                }

                completedTrackers.remove(at: currentDayTrackerRecordIndex)
            } else {
                completedTrackers.append(TrackerRecord(id: cellModel.id, date: currentDate))
            }

            self.trackerCollectionView.reloadItems(at: [indexPath])
        }


        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackerCardsCategoryHeaderView.reuseIdentifier,
            for: indexPath
        ) as? TrackerCardsCategoryHeaderView

        guard let headerView,
              let category = visibleCategories[safe: indexPath.section] else {
            return UICollectionReusableView()
        }

        headerView.titleLabel.text = category.title

        return headerView
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(
            width: (collectionView.frame.width - 32 - 10) / 2,
            height: 148
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        10
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: .zero, left: 16, bottom: .zero, right: 16)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        let headerView = self.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
            at: IndexPath(row: 0, section: section)
        ) as? TrackerCardsCategoryHeaderView

        guard let headerView else { return .zero }

        return headerView.systemLayoutSizeFitting(
            CGSize(
                width: collectionView.frame.width,
                height: UIView.layoutFittingExpandedSize.height
            ),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
}

// MARK: - Configuration

private extension TrackersViewController {
    func configureNavigationBar() {
        let addTrackersItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAddTrackerButton)
        )
        addTrackersItem.tintColor = .ypBlack

        let datePickerItem = UIBarButtonItem(customView: datePicker)

        navigationItem.leftBarButtonItem = addTrackersItem
        navigationItem.title = "Трекеры"
        navigationItem.rightBarButtonItem = datePickerItem
    }

    func setupConstraints() {
        defaultModeConstraints = [
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 36)
        ]

        defaultModeConstraints.forEach { $0.isActive = true }

        searchModeConstraints = [
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchTextField.heightAnchor.constraint(equalToConstant: 36),

            cancelSearchButton.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            cancelSearchButton.leadingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: 5),
            cancelSearchButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ]

        NSLayoutConstraint.activate([
            placeholderView.centerXAnchor.constraint(equalTo: trackerCollectionView.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: trackerCollectionView.centerYAnchor),
            placeholderView.leadingAnchor.constraint(equalTo: trackerCollectionView.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: trackerCollectionView.trailingAnchor),

            trackerCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trackerCollectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            trackerCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            trackerCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - TrackersStorageServiceDelegate

extension TrackersViewController: TrackersStorageServiceDelegate {
    func didAppendTracker(_ tracker: Tracker, toCategory category: TrackerCategory, fromViewController vc: UIViewController?) {
        reloadTrackers(filterText: Constants.emptyFilter)
        vc?.dismiss(animated: true)
    }
}

// MARK: - Filtering

private extension TrackersViewController {
    func reloadTrackers(filterText: String) {
        guard !filterText.isEmpty else {
            visibleCategories = currentDateCategories
            trackerCollectionView.reloadData()

            return
        }


        let newVisibleCategories: [TrackerCategory] = currentDateCategories.compactMap { category in
            let filteredTrackers = category.trackers.filter { tracker in
                    let didPassCheck = tracker.title.lowercased().contains(filterText.lowercased())

                    return didPassCheck
                }

            guard !filteredTrackers.isEmpty else { return nil }

            return TrackerCategory(trackers: filteredTrackers, title: category.title)
        }

        visibleCategories = newVisibleCategories

        trackerCollectionView.reloadData()
    }
}

// MARK: - Actions

private extension TrackersViewController {
    @objc func didTapAddTrackerButton() {
        let viewController = TrackerTypePickerViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .pageSheet

        present(navigationController, animated: true)
    }

    @objc func didChangeDate() {
        currentDate = datePicker.date
    }

    @objc func didChangeSearchTextField(_ textField: UISearchTextField) {
        guard let filterText = textField.text else { return }

        reloadTrackers(filterText: filterText)
    }

    @objc func didTapCancelSearchButton() {
        searchTextField.resignFirstResponder()
        searchTextField.text = nil
        reloadTrackers(filterText: Constants.emptyFilter)
    }
}

