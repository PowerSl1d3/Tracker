//
//  TrackerListViewController.swift
//  Tracker
//
//  Created by Олег Аксененко on 28.05.2023.
//

import UIKit

final class TrackerListViewController: UIViewController {

    private let searchTextField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.font = .ypRegularFont(ofSize: 17)
        searchTextField.placeholder = LocalizedString("trackers.searchTextField.placeholder")
        searchTextField.clearButtonMode = .never
        searchTextField.returnKeyType = .search

        return searchTextField
    }()

    private let cancelSearchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(LocalizedString("trackers.cancelSearchButton.cancel"), for: .normal)
        button.setTitleColor(Asset.ypBlue.color, for: .normal)

        return button
    }()

    private var defaultModeConstraints = [NSLayoutConstraint]()
    private var searchModeConstraints = [NSLayoutConstraint]()

    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.tintColor = Asset.ypBlue.color

        return datePicker
    }()

    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = Asset.ypWhite.color

        return collectionView
    }()

    private let placeholderView: TrackersPlaceholderView = {
        let placeholderView = TrackersPlaceholderView()
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.title = LocalizedString("trackers.placeholder")
        placeholderView.isHidden = true

        return placeholderView
    }()

    // TODO: сделать скрытие фильтра когда трекеров нет
    private let filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.backgroundColor = Asset.ypBlue.color

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.ypMediumFont(ofSize: 16),
            .foregroundColor: Asset.ypBlack.color.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))
        ]
        button.setAttributedTitle(
            NSAttributedString(string: LocalizedString("trackers.filter.button"), attributes: attributes),
            for: .normal
        )

        return button
    }()

    private var viewModel: TrackerListViewModel?

    func initialize(viewModel: TrackerListViewModel) {
        self.viewModel = viewModel
        bind()
    }

    private func bind() {
        viewModel?.$visibleCategories.bindAndCall { [weak self] visibleCategories in
            guard let self else { return }

            placeholderView.isHidden = !visibleCategories.isEmpty
            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Asset.ypWhite.color

        datePicker.addTarget(self, action: #selector(didChangeDate), for: .valueChanged)
        cancelSearchButton.addTarget(self, action: #selector(didTapCancelSearchButton), for: .touchUpInside)
        searchTextField.addTarget(self, action: #selector(didChangeSearchTextField), for: .editingChanged)
        filterButton.addTarget(self, action: #selector(didTapFiltersButton), for: .touchUpInside)

        searchTextField.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = viewModel?.dataSource

        collectionView.register(
            TrackerCardCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackerCardCollectionViewCell.reuseIdentifier
        )

        collectionView.register(
            TrackerCardsCategoryHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerCardsCategoryHeaderView.reuseIdentifier
        )

        collectionView.addSubview(placeholderView)
        view.addSubview(searchTextField)
        view.addSubview(collectionView)
        view.addSubview(filterButton)

        configureNavigationBar()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel?.viewWillAppear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        viewModel?.viewDidDissapear()
    }
}

extension TrackerListViewController: UISearchTextFieldDelegate {
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

extension TrackerListViewController: UICollectionViewDelegateFlowLayout {
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
        guard let dataSource = viewModel?.dataSource else { return .zero }

        let headerView = dataSource.collectionView(
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

    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfiguration configuration: UIContextMenuConfiguration,
        highlightPreviewForItemAt indexPath: IndexPath
    ) -> UITargetedPreview? {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerCardCollectionViewCell else {
            return nil
        }

        return UITargetedPreview(view: cell.targetHighlightedPreview)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemsAt indexPaths: [IndexPath],
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        guard indexPaths.count == 1 else { return nil }

        guard let indexPath = indexPaths.first,
              let cell = collectionView.cellForItem(at: indexPath) as? TrackerCardCollectionViewCell,
              let cellModel = cell.cellModel else {
            return nil
        }

        return UIContextMenuConfiguration(actionProvider:  { [weak self] _ in
            UIMenu(children: [
                UIAction(title: LocalizedString("trackers.actions.\(cellModel.isPinned ? "unpin" : "pin")")) { [weak self] action in
                    self?.viewModel?.didSelectPinContextMenu(cellModel)
                },
                UIAction(title: LocalizedString("trackers.actions.edit")) { [weak self] action in
                    self?.viewModel?.didSelectEditContextMenu(cellModel)
                },
                UIAction(title: LocalizedString("trackers.actions.delete"), attributes: .destructive) { [weak self] _ in
                    self?.viewModel?.didSelectDeleteContextMenu(cellModel)
                }
            ])
        })
    }
}

// MARK: - Configuration

private extension TrackerListViewController {
    func configureNavigationBar() {
        let addTrackersItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAddTrackerButton)
        )
        addTrackersItem.tintColor = Asset.ypBlack.color

        let datePickerItem = UIBarButtonItem(customView: datePicker)

        navigationItem.leftBarButtonItem = addTrackersItem
        navigationItem.title = LocalizedString("trackers.navItem")
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
            placeholderView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            placeholderView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),

            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 115)
        ])
    }
}

// MARK: - Actions

private extension TrackerListViewController {
    @objc func didTapAddTrackerButton() {
        viewModel?.didTapAddTrackerButton()
    }

    @objc func didChangeDate() {
        viewModel?.didChangeDate(datePicker.date)
    }

    @objc func didChangeSearchTextField(_ textField: UISearchTextField) {
        viewModel?.didEnterTrackerTitleSearchField(textField.text)
    }

    @objc func didTapCancelSearchButton() {
        searchTextField.resignFirstResponder()
        searchTextField.text = nil
        viewModel?.didTapCancelSearchButton()
    }

    @objc func didTapFiltersButton() {
        viewModel?.didTapFiltersButton()
    }
}

