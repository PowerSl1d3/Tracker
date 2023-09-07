//
//  TrackerFormViewController.swift
//  Tracker
//
//  Created by Олег Аксененко on 28.06.2023.
//

import UIKit

final class TrackerFormViewController: UIViewController {
    var trackerType: TrackerType

    private var sections: [TrackerBaseSection] = []

    private var textFieldSection: TrackerBaseSection?
    private var categoryPickerSection: TrackerBaseSection?
    private var emojiPickerSection: TrackerBaseSection?
    private var colorPickerSection: TrackerBaseSection?

    private let trackersDataProvider: TrackersDataProvider = TrackersDataProviderAssembly.assemble()

    private var trackerTitle: String? {
        didSet { checkFormState() }
    }

    private var selectedCategory: TrackerCategory? {
        didSet { checkFormState() }
    }

    private var selectedSchedule: [WeekDay]? {
        didSet { checkFormState() }
    }

    private var selectedEmoji: Character? {
        didSet { checkFormState() }
    }

    private var selectedColor: UIColor? {
        didSet { checkFormState() }
    }

    private let trackerParametersTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .ypWhite
        tableView.separatorColor = .ypGray

        return tableView
    }()

    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .ypWhite
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.layer.cornerRadius = 16
        button.clipsToBounds = true

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.ypMediumFont(ofSize: 16),
            .foregroundColor: UIColor.ypRed
        ]

        button.setAttributedTitle(NSAttributedString(string: "Отменить", attributes: attributes), for: .normal)

        return button
    }()

    private let createButton: UIButton = {
        let button = StateButton(type: .system)
        button.setTitle("Создать", for: .normal)
        button.setTitle("Создать", for: .disabled)
        button.isEnabled = false

        return button
    }()

    private let buttonsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    init(trackerType: TrackerType) {
        self.trackerType = trackerType

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let textFieldSection = TrackerBaseSection(
            cellModel: TrackerTitleTextFieldCellModel(title: nil, placeholder: "Введите название трекера") { [weak self] cellModel, didShowError in
                guard let self, let textFieldSection = self.textFieldSection else { return }

                if didShowError && textFieldSection.count == 1 {
                    textFieldSection.append(TrackerErrorCellModel(errorText: "Ограничение 38 символов"))
                    trackerParametersTableView.insertRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
                } else if !didShowError && textFieldSection.count == 2 {
                    textFieldSection.pop()
                    trackerParametersTableView.deleteRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
                }

                trackerTitle = cellModel.title
            }
        )

        self.textFieldSection = textFieldSection

        let categoryPickerCellModel = TrackerCategoryPickerCellModel(selectionHandler: { _ in
            self.didTapCategoryPickerCell()
        })
        categoryPickerCellModel.roundBottomCorners = trackerType == .event

        let categoryPickerSection = TrackerBaseSection(
            cellModels: [
                TrackerBaseCellModel(height: 24, contentViewBackgroundColor: .ypWhite, separatorInset: .invisibleSeparator),
                categoryPickerCellModel
            ]
        )

        if trackerType == .habit {
            categoryPickerSection.append(TrackerSchedulePickerCellModel(selectionHandler: { cellModel in
                self.didTapWeekDayCell()
            }))
        }

        self.categoryPickerSection = categoryPickerSection

        let emojiPickerCellModel = TrackerEmojiPickerCellModel()
        emojiPickerCellModel.selectionHandler = { [weak self] selectedEmoji in
            guard let self else { return }

            self.selectedEmoji = Character(selectedEmoji)
        }

        let emojiPickerSection = TrackerBaseSection(
            name: "Emoji",
            cellModels: [
                TrackerBaseCellModel(height: 24, contentViewBackgroundColor: .ypWhite, separatorInset: .invisibleSeparator),
                emojiPickerCellModel
            ]
        )

        self.emojiPickerSection = emojiPickerSection

        let colorPickerCellModel = TrackerColorPickerCellModel()
        colorPickerCellModel.selectionHandler = { [weak self] selectedColor in
            guard let self else { return }

            self.selectedColor = selectedColor
        }

        let colorPickerSection = TrackerBaseSection(
            name: "Цвет",
            cellModels: [
                TrackerBaseCellModel(height: 24, contentViewBackgroundColor: .ypWhite, separatorInset: .invisibleSeparator),
                colorPickerCellModel
            ]
        )

        self.colorPickerSection = colorPickerSection

        sections = [textFieldSection, categoryPickerSection, emojiPickerSection, colorPickerSection]

        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)

        trackerParametersTableView.dataSource = self
        trackerParametersTableView.delegate = self

        trackerParametersTableView.register([
            TrackerBaseCell.self,
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

        view.backgroundColor = .ypWhite
        view.addSubview(trackerParametersTableView)

        buttonsContainerView.addSubview(cancelButton)
        buttonsContainerView.addSubview(createButton)
        view.addSubview(buttonsContainerView)

        setupNavBar()
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

        if indexPath.section == 1,
           let cellModel = categoryPickerSection?[safe: indexPath.row] as? TrackerCategoryPickerCellModel {
            cellModel.selectionHandler?(cellModel)
        } else if indexPath.section == 1,
                  let cellModel = categoryPickerSection?[safe: indexPath.row] as? TrackerSchedulePickerCellModel {
            cellModel.selectionHandler?(cellModel)
        }
    }
}

extension TrackerFormViewController: WeekDayPickerDelegate {
    func didSelectSchedule(_ schedule: [WeekDay]) {
        navigationController?.popViewController(animated: true)
        selectedSchedule = schedule

        guard let scheduleCellModel = categoryPickerSection?.last as? TrackerSchedulePickerCellModel else { return }

        scheduleCellModel.schedule = schedule
        trackerParametersTableView.reloadRows(at: [IndexPath(row: 2, section: 1)], with: .none)
    }
}

extension TrackerFormViewController: TrackerCategoryPickerDelegate {
    func didSelectCategory(_ category: TrackerCategory, fromViewController vc: UIViewController) {
        navigationController?.popViewController(animated: true)
        self.selectedCategory = category

        guard let categoryCellModel = categoryPickerSection?[safe: 1] as? TrackerCategoryPickerCellModel else { return }

        categoryCellModel.category = category
        trackerParametersTableView.reloadRows(at: [IndexPath(row: 1, section: 1)], with: .none)

        vc.dismiss(animated: true)
    }
}

private extension TrackerFormViewController {
    // MARK: Business Logic

    func checkFormState() {
        if let trackerTitle, !trackerTitle.isEmpty, textFieldSection?.count == 1,
           selectedCategory != nil,
           (selectedSchedule != nil && !(selectedSchedule?.isEmpty ?? false)) || trackerType == .event,
           selectedEmoji != nil,
           selectedColor != nil {
            createButton.isEnabled = true
        } else {
            createButton.isEnabled = false
        }
    }

    // MARK: - Layout

    func setupNavBar() {
        navigationItem.title = trackerType == .event ? "Новое нерегулярное событие" : "Новая привычка"
        navigationItem.hidesBackButton = true
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

            createButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8),
            createButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            createButton.topAnchor.constraint(equalTo: buttonsContainerView.topAnchor),
            createButton.trailingAnchor.constraint(equalTo: buttonsContainerView.trailingAnchor),
            createButton.bottomAnchor.constraint(equalTo: buttonsContainerView.bottomAnchor),

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
        navigationController?.popViewController(animated: true)
    }

    @objc func didTapCreateButton() {
        let selectedSchedule = trackerType == .event ? .eventSchedule : selectedSchedule

        guard let trackerTitle,
              let selectedCategory,
              let selectedSchedule,
              let selectedEmoji,
              let selectedColor else {
            assertionFailure("Invalid category form state")
            return
        }

        let tracker = Tracker(
            id: UUID(),
            title: trackerTitle,
            color: selectedColor,
            emoji: selectedEmoji,
            schedule: selectedSchedule
        )

        try? trackersDataProvider.addRecord(tracker, toCategory: selectedCategory)
    }
}
