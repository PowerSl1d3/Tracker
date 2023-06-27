//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Олег Аксененко on 28.05.2023.
//

import UIKit

final class TrackersViewController: UIViewController {
    private let searchTextField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.font = .ypRegularFont(ofSize: 17)
        searchTextField.placeholder = "Поиск"
        searchTextField.clearButtonMode = .never

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

    private var currentDate = Date()

    private let trackerCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .ypWhite

        return collectionView
    }()

    var categories = [TrackerCategory]()
    var completedTrackers = [TrackerRecord]()

    var visibleCategories = [TrackerCategory]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // FIXME: Удалить дебажную категорию
        let homeCategory = TrackerCategory(
            trackers: [
                Tracker(
                    id: UUID(),
                    title: "Сделать уборку",
                    color: .systemRed,
                    emoji: "⛹️‍♂️",
                    schedule: [.everyDay]
                ),
                Tracker(
                    id: UUID(),
                    title: "Сходить в магазин",
                    color: .systemBlue,
                    emoji: "🥦",
                    schedule: [.everyDay]
                ),
                Tracker(
                    id: UUID(),
                    title: "Купить продукты",
                    color: .systemBrown,
                    emoji: "🍇",
                    schedule: [.everyDay]
                )
            ],
            title: "Домашний уют"
        )

        let workCategory = TrackerCategory(
            trackers: [
                Tracker(
                    id: UUID(),
                    title: "Доделать 14 спринт",
                    color: .systemTeal,
                    emoji: "😊",
                    schedule: [.everyDay]
                ),
                Tracker(
                    id: UUID(),
                    title: "Сходить на дейли",
                    color: .systemIndigo,
                    emoji: "🍉",
                    schedule: [.everyDay]
                ),
                Tracker(
                    id: UUID(),
                    title: "Подготовиться к планированию",
                    color: .systemTeal,
                    emoji: "🏖️",
                    schedule: [.everyDay]
                )
            ],
            title: "Работа"
        )

        categories = [homeCategory, workCategory]

        view.backgroundColor = .ypWhite

        datePicker.addTarget(self, action: #selector(didChangeDate), for: .valueChanged)
        cancelSearchButton.addTarget(self, action: #selector(didTapCancelSearchButton), for: .touchUpInside)

        searchTextField.delegate = self
        trackerCollectionView.dataSource = self
        trackerCollectionView.delegate = self

        trackerCollectionView.register(
            TrackerCardCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackerCardCollectionViewCell.reuseIdentifier
        )

        trackerCollectionView.register(
            TrackerCardsSupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerCardsSupplementaryView.reuseIdentifier
        )

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
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let category = categories[safe: section] else { return .zero }

        return category.trackers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCardCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? TrackerCardCollectionViewCell

        guard let cell,
              let category = categories[safe: indexPath.section],
              let cellModel = category.trackers[safe: indexPath.row] else {
            return UICollectionViewCell()
        }

        cell.configure(cellModel: cellModel)

        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackerCardsSupplementaryView.reuseIdentifier,
            for: indexPath
        ) as? TrackerCardsSupplementaryView

        guard let headerView,
              let category = categories[safe: indexPath.section] else {
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
        ) as? TrackerCardsSupplementaryView

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

    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        print(#function, indexPath.description)
    }
}

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
            trackerCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trackerCollectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            trackerCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            trackerCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc func didTapAddTrackerButton() {
        print(#function)
    }

    @objc func didChangeDate() {
        currentDate = datePicker.date
    }

    @objc func didTapCancelSearchButton() {
        searchTextField.resignFirstResponder()
        searchTextField.text = nil
    }
}

