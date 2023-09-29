//
//  TrackerFormViewController.swift
//  Tracker
//
//  Created by Олег Аксененко on 28.06.2023.
//

import UIKit

final class TrackerFormViewController: UIViewController {
    private let configuration: TrackerFormConfiguration

    private weak var delegate: TrackerFormDelegate?

    private var sections: [TrackerBaseSection] = []

    private var completedDaysSection: TrackerBaseSection?
    private var textFieldSection: TrackerBaseSection?
    private var categoryPickerSection: TrackerBaseSection?
    private var emojiPickerSection: TrackerBaseSection?
    private var colorPickerSection: TrackerBaseSection?

    private let trackersDataProvider: TrackersDataProvider = TrackersDataProviderAssembly.assemble()

    @Observable
    private var trackerTitle: String?

    @Observable
    private var selectedCategory: TrackerCategory?

    @Observable
    private var selectedSchedule: [WeekDay]?

    @Observable
    private var selectedEmoji: Character?

    @Observable
    private var selectedColor: UIColor?

    private let trackerParametersTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = Asset.ypWhite.color
        tableView.separatorColor = Asset.ypGray.color

        return tableView
    }()

    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Asset.ypWhite.color
        button.layer.borderWidth = 1
        button.layer.borderColor = Asset.ypRed.color.cgColor
        button.layer.cornerRadius = 16
        button.clipsToBounds = true

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.ypMediumFont(ofSize: 16),
            .foregroundColor: Asset.ypRed.color
        ]

        button.setAttributedTitle(NSAttributedString(string: LocalizedString("trackersForm.cancel"), attributes: attributes), for: .normal)

        return button
    }()

    private let doneButton: UIButton = StateButton(type: .system)

    private let buttonsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    init(with configuration: TrackerFormConfiguration) {
        self.configuration = configuration

        switch configuration {
        case .create(_, let delegate):
            self.delegate = delegate
        case .edit(let tracker, let trackerCategory, let delegate, _):
            self.delegate = delegate
            trackerTitle = tracker.title
            selectedCategory = trackerCategory
            selectedSchedule = tracker.schedule
            selectedEmoji = tracker.emoji
            selectedColor = tracker.color
        }

        super.init(nibName: nil, bundle: nil)

        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let trackerType: TrackerType
        let editMode: Bool
        let daysCount: Int?
        switch configuration {
        case .create(let configurationTrackerType, _):
            trackerType = configurationTrackerType
            editMode = false
            daysCount = nil
        case .edit(let tracker, _, _, let configurationDaysCount):
            trackerType = tracker.schedule == .eventSchedule ? .event : .habit
            editMode = true
            daysCount = configurationDaysCount
        }

        let completedDaysSection = TrackerBaseSection(
            cellModel: TrackerCompletedDaysCellModel(daysCount: daysCount)
        )

        self.completedDaysSection = completedDaysSection

        let textFieldSection = TrackerBaseSection(
            cellModel: TrackerTitleTextFieldCellModel(title: trackerTitle, placeholder: LocalizedString("trackersForm.titleTextField.placeholder")) { [weak self] cellModel, didShowError in
                guard let self, let textFieldSection = self.textFieldSection else { return }

                if didShowError && textFieldSection.count == 1 {
                    textFieldSection.append(TrackerErrorCellModel(errorText: LocalizedString("trackersForm.titleTextField.error")))
                    trackerParametersTableView.insertRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
                } else if !didShowError && textFieldSection.count == 2 {
                    textFieldSection.pop()
                    trackerParametersTableView.deleteRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
                }

                trackerTitle = cellModel.title
            }
        )

        self.textFieldSection = textFieldSection

        let categoryPickerCellModel = TrackerCategoryPickerCellModel(category: selectedCategory, selectionHandler: { _ in
            self.didTapCategoryPickerCell()
        })
        categoryPickerCellModel.roundBottomCorners = trackerType == .event && !editMode

        let categoryPickerSection = TrackerBaseSection(
            cellModels: [
                TrackerBaseCellModel(height: 24, contentViewBackgroundColor: Asset.ypWhite.color, separatorInset: .invisibleSeparator),
                categoryPickerCellModel
            ]
        )

        if trackerType == .habit || editMode {
            categoryPickerSection.append(TrackerSchedulePickerCellModel(schedule: selectedSchedule, selectionHandler: { [weak self] cellModel in
                self?.didTapWeekDayCell()
            }))
        }

        self.categoryPickerSection = categoryPickerSection

        let emojiPickerCellModel = TrackerEmojiPickerCellModel(emoji: selectedEmoji) { [weak self] cellModel in
            guard let self, let cellModel = cellModel as? TrackerEmojiPickerCellModel else { return }

            self.selectedEmoji = cellModel.selectedEmoji
        }

        let emojiPickerSection = TrackerBaseSection(
            name: LocalizedString("trackersForm.section.emoji"),
            cellModels: [
                TrackerBaseCellModel(height: 24, contentViewBackgroundColor: Asset.ypWhite.color, separatorInset: .invisibleSeparator),
                emojiPickerCellModel
            ]
        )

        self.emojiPickerSection = emojiPickerSection

        let colorPickerCellModel = TrackerColorPickerCellModel(color: selectedColor) { [weak self] cellModel in
            guard let self, let cellModel = cellModel as? TrackerColorPickerCellModel else { return }

            self.selectedColor = cellModel.selectedColor
        }

        let colorPickerSection = TrackerBaseSection(
            name: LocalizedString("trackersForm.section.color"),
            cellModels: [
                TrackerBaseCellModel(height: 24, contentViewBackgroundColor: Asset.ypWhite.color, separatorInset: .invisibleSeparator),
                colorPickerCellModel
            ]
        )

        self.colorPickerSection = colorPickerSection

        sections = [textFieldSection, categoryPickerSection, emojiPickerSection, colorPickerSection]

        if editMode {
            sections.insert(completedDaysSection, at: 0)
        }

        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)

        trackerParametersTableView.dataSource = self
        trackerParametersTableView.delegate = self

        trackerParametersTableView.register([
            TrackerBaseCell.self,
            TrackerCompletedDaysCell.self,
            TrackerTitleTextFieldCell.self,
            TrackerErrorCell.self,
            TrackerCategoryPickerCell.self,
            TrackerSchedulePickerCell.self,
            TrackerEmojiPickerCell.self,
            TrackerColorPickerCell.self
        ])

        trackerParametersTableView.register(
            TrackerFormHeaderView.self,
            forHeaderFooterViewReuseIdentifier: TrackerFormHeaderView.reuseIdentifier
        )

        view.backgroundColor = Asset.ypWhite.color
        view.addSubview(trackerParametersTableView)

        buttonsContainerView.addSubview(cancelButton)
        buttonsContainerView.addSubview(doneButton)
        view.addSubview(buttonsContainerView)

        setupNavBar()
        setupViews(with: configuration)
        setupConstraints()
    }
}

extension TrackerFormViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = sections[safe: section] else { return .zero }

        return section.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellModel = sections[safe: indexPath.section]?[safe: indexPath.row] as? TrackerBaseCellModelProtocol else {
            return UITableViewCell()
        }

        let cellIdentifier = cellModel.reuseIdentifier
        let cell = tableView.dequeueReusableCell(
            withIdentifier: cellIdentifier,
            for: indexPath
        ) as? TrackerBaseCell

        guard let cell else { return UITableViewCell() }

        cell.configure(from: cellModel)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section > 1 else { return .zero }

        let headerView = self.tableView(tableView, viewForHeaderInSection: section)

        return headerView?.systemLayoutSizeFitting(
            CGSize(
                width: tableView.frame.width,
                height: UIView.layoutFittingExpandedSize.height
            ),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height ?? .zero
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: TrackerFormHeaderView.reuseIdentifier
        ) as? TrackerFormHeaderView

        guard let section = sections[safe: section],
              let name = section.name,
              let headerView else {
            return UIView(frame: .zero)
        }

        headerView.setTitle(name)

        return headerView
    }
}

extension TrackerFormViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: false)

        guard let cellModel = sections[safe: indexPath.section]?[safe: indexPath.row] as? TrackerBaseCellModel else {
            return
        }

        cellModel.selectionHandler?(cellModel)
    }
}

extension TrackerFormViewController: WeekDayPickerDelegate {
    func didSelectSchedule(_ schedule: [WeekDay]) {
        navigationController?.popViewController(animated: true)
        selectedSchedule = schedule

        guard let (scheduleCellModelIndex, scheduleCellModel) = categoryPickerSection?
            .enumerated()
            .first(where: { $1 is TrackerSchedulePickerCellModel }),
              let scheduleCellModel = scheduleCellModel as? TrackerSchedulePickerCellModel,
              let categoryPickerSectionIndex = sections.firstIndex(where: { $0 === categoryPickerSection }) else {
            return
        }

        scheduleCellModel.schedule = schedule
        trackerParametersTableView.reloadRows(
            at: [IndexPath(row: scheduleCellModelIndex, section: categoryPickerSectionIndex)],
            with: .none
        )
    }
}

extension TrackerFormViewController: TrackerCategoryPickerDelegate {
    func didSelectCategory(_ category: TrackerCategory, fromViewController vc: UIViewController) {
        navigationController?.popViewController(animated: true)
        self.selectedCategory = category

        guard let (categoryCellModelIndex, categoryCellModel) = categoryPickerSection?
            .enumerated()
            .first(where: { $1 is TrackerCategoryPickerCellModel }),
              let categoryCellModel = categoryCellModel as? TrackerCategoryPickerCellModel,
              let categoryPickerSectionIndex = sections.firstIndex(where: { $0 === categoryPickerSection }) else {
            return
        }

        categoryCellModel.category = category
        trackerParametersTableView.reloadRows(
            at: [IndexPath(row: categoryCellModelIndex, section: categoryPickerSectionIndex)],
            with: .none
        )

        vc.dismiss(animated: true)
    }
}

private extension TrackerFormViewController {
    func bind() {
        $trackerTitle.bind { [weak self] _ in self?.checkFormState() }
        $selectedCategory.bind { [weak self] _ in self?.checkFormState() }
        $selectedSchedule.bind { [weak self] _ in self?.checkFormState() }
        $selectedEmoji.bind { [weak self] _ in self?.checkFormState() }
        $selectedColor.bind { [weak self] _ in self?.checkFormState() }
    }

    // MARK: Business Logic

    func checkFormState() {
        let trackerType: TrackerType
        switch configuration {
        case .create(let configurationTrackerType, _):
            trackerType = configurationTrackerType
        case .edit(let tracker, _, _, _):
            trackerType = tracker.schedule == .eventSchedule ? .event : .habit
        }

        if let trackerTitle, !trackerTitle.isEmpty, textFieldSection?.count == 1,
           selectedCategory != nil,
           !selectedSchedule.isNilOrEmpty || trackerType == .event,
           selectedEmoji != nil,
           selectedColor != nil {
            doneButton.isEnabled = true
        } else {
            doneButton.isEnabled = false
        }
    }

    // MARK: - Layout

    func setupNavBar() {
        switch configuration {
        case .create(let trackerType, _):
            navigationItem.title = trackerType == .event ? LocalizedString("trackersForm.navItem.event") : LocalizedString("trackersForm.navItem.habit")
        case .edit(let tracker, _, _, _):
            navigationItem.title = tracker.schedule == .eventSchedule ? LocalizedString("trackersForm.navItem.editEvent") : LocalizedString("trackersForm.navItem.editHabit")
        }

        navigationItem.hidesBackButton = true
    }

    func setupViews(with configuration: TrackerFormConfiguration) {
        switch configuration {
        case .create(_, _):
            doneButton.setTitle(LocalizedString("trackersForm.create"), for: .normal)
            doneButton.setTitle(LocalizedString("trackersForm.create"), for: .disabled)
            doneButton.isEnabled = false
        case .edit(_, _, _, _):
            doneButton.setTitle(LocalizedString("trackersForm.save"), for: .normal)
            doneButton.setTitle(LocalizedString("trackersForm.save"), for: .disabled)
            doneButton.isEnabled = true
        }
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            trackerParametersTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackerParametersTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trackerParametersTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            trackerParametersTableView.bottomAnchor.constraint(equalTo: buttonsContainerView.topAnchor, constant: -8),

            cancelButton.leadingAnchor.constraint(equalTo: buttonsContainerView.leadingAnchor),
            cancelButton.topAnchor.constraint(equalTo: buttonsContainerView.topAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: buttonsContainerView.bottomAnchor),

            doneButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8),
            doneButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            doneButton.topAnchor.constraint(equalTo: buttonsContainerView.topAnchor),
            doneButton.trailingAnchor.constraint(equalTo: buttonsContainerView.trailingAnchor),
            doneButton.bottomAnchor.constraint(equalTo: buttonsContainerView.bottomAnchor),

            buttonsContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            buttonsContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            buttonsContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonsContainerView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    // MARK: - Actions

    func didTapCategoryPickerCell() {
        let moduleData = CategoryPickerModuleData(delegate: self, selectedCategory: selectedCategory)
        let viewController = CategoryPickerAssembly.assemble(moduleData: moduleData)
        viewController.modalPresentationStyle = .pageSheet

        navigationController?.pushViewController(viewController, animated: true)
    }

    func didTapWeekDayCell() {
        let viewController = WeekDayPickerViewController()
        viewController.delegate = self

        if let selectedSchedule {
            viewController.setSchedule(selectedSchedule)
        }

        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc func didTapCancelButton() {
        delegate?.didTapCancelButton()
    }

    @objc func didTapDoneButton() {
        guard let trackerTitle,
              let selectedCategory,
              let selectedEmoji,
              let selectedColor else {
            assertionFailure("Invalid category form state")
            return
        }

        switch configuration {
        case .create(let trackerType, _):
            let selectedSchedule = trackerType == .event ? .eventSchedule : selectedSchedule

            guard let selectedSchedule else {
                assertionFailure("Invalid category form state")
                return
            }

            let tracker = Tracker(
                id: UUID(),
                title: trackerTitle,
                color: selectedColor,
                emoji: selectedEmoji,
                schedule: selectedSchedule,
                isPinned: false
            )

            try? trackersDataProvider.addRecord(tracker, toCategory: selectedCategory)
        case .edit(let configurationTracker, _, _, _):
            guard let selectedSchedule else {
                assertionFailure("Invalid category form state")
                return
            }

            let tracker = Tracker(
                id: configurationTracker.id,
                title: trackerTitle,
                color: selectedColor,
                emoji: selectedEmoji,
                schedule: selectedSchedule,
                isPinned: configurationTracker.isPinned
            )

            try? trackersDataProvider.editRecord(tracker, from: selectedCategory)
        }
    }
}
