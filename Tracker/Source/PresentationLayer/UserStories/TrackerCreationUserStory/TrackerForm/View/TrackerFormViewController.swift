//
//  TrackerFormViewController.swift
//  Tracker
//
//  Created by Олег Аксененко on 28.06.2023.
//

import UIKit

final class TrackerFormViewController: UIViewController {
    var trackerType: TrackerType

    init(trackerType: TrackerType) {
        self.trackerType = trackerType

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var textFieldSecton: [TrackerBaseCellModelProtocol] = []
    private var categorySection: [TrackerBaseCellModelProtocol] = []

    let trackersStorageService: TrackersStorageService = TrackersStorageServiceImpl.shared

    private var trackerTitle: String? {
        didSet { checkFormState() }
    }

    private var selectedCategory: TrackerCategory? {
        didSet { checkFormState() }
    }

    private var selectedSchedule: [WeekDay]? {
        didSet { checkFormState() }
    }

    private let trackerFormNotificationName = Notification.Name(rawValue: "TrackerFormDidChangedNotification")
    private let notificationCenter = NotificationCenter.default
    private var trackerFormObserver: NSObjectProtocol?

    private let trackerParametersTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
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

    override func viewDidLoad() {
        super.viewDidLoad()

        notificationCenter.addObserver(
            forName: trackerFormNotificationName,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self else { return }

                if let trackerTitle, !trackerTitle.isEmpty, textFieldSecton.count == 1,
                   selectedCategory != nil,
                   (selectedSchedule != nil && !(selectedSchedule?.isEmpty ?? false)) || trackerType == .event {
                    createButton.isEnabled = true
                } else {
                    createButton.isEnabled = false
                }
            }

        textFieldSecton = [
            TrackerTitleTextFieldCellModel(title: nil, placeholder: "Введите название трекера") { [weak self] cellModel, didShowError in
                guard let self else { return }

                if didShowError && textFieldSecton.count == 1 {
                    textFieldSecton.append(TrackerErrorCellModel(errorText: "Ограничение 38 символов"))
                    trackerParametersTableView.insertRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
                } else if !didShowError && textFieldSecton.count == 2 {
                    _ = textFieldSecton.popLast()
                    trackerParametersTableView.deleteRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
                }

                trackerTitle = cellModel.title
            }
        ]

        let categoryPickerCellModel = TrackerCategoryPickerCellModel(selectionHandler: { _ in
            self.didTapCategoryPickerCell()
        })
        categoryPickerCellModel.roundBottomCorners = trackerType == .event

        categorySection = [
            TrackerBaseCellModel(height: 24, contentViewBackgroundColor: .ypWhite, separatorInset: .invisibleSeparator),
            categoryPickerCellModel
        ]

        if trackerType == .habit {
            categorySection.append(TrackerSchedulePickerCellModel(selectionHandler: { cellModel in
                self.didTapWeekDayCell()
            }))
        }

        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)

        trackerParametersTableView.dataSource = self
        trackerParametersTableView.delegate = self
        trackerParametersTableView.register(
            TrackerBaseCell.self,
            forCellReuseIdentifier: String(describing: TrackerBaseCell.self)
        )
        trackerParametersTableView.register(
            TrackerTitleTextFieldCell.self,
            forCellReuseIdentifier: String(describing: TrackerTitleTextFieldCell.self)
        )
        trackerParametersTableView.register(
            TrackerErrorCell.self,
            forCellReuseIdentifier: String(describing: TrackerErrorCell.self)
        )
        trackerParametersTableView.register(
            TrackerCategoryPickerCell.self,
            forCellReuseIdentifier: String(describing: TrackerCategoryPickerCell.self)
        )
        trackerParametersTableView.register(
            TrackerSchedulePickerCell.self,
            forCellReuseIdentifier: String(describing: TrackerSchedulePickerCell.self)
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
        2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return textFieldSecton.count
        case 1:
            return categorySection.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: TrackerTitleTextFieldCell.self),
                for: indexPath
            ) as? TrackerTitleTextFieldCell

            let cellModel = textFieldSecton[safe: indexPath.row]

            guard let cell, let cellModel else { return UITableViewCell() }

            cell.configure(from: cellModel)

            return cell
        } else if indexPath.section == 0 && indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: TrackerErrorCell.self),
                for: indexPath
            ) as? TrackerErrorCell

            let cellModel = textFieldSecton[safe: indexPath.row]

            guard let cell, let cellModel else { return UITableViewCell() }

            cell.configure(from: cellModel)

            return cell
        } else if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: TrackerBaseCell.self),
                for: indexPath
            ) as? TrackerBaseCell

            let cellModel = categorySection[safe: indexPath.row]

            guard let cell, let cellModel else { return UITableViewCell() }

            cell.configure(from: cellModel)

            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: TrackerCategoryPickerCell.self),
                for: indexPath
            ) as? TrackerCategoryPickerCell

            let cellModel = categorySection[safe: indexPath.row]

            guard let cell, let cellModel else { return UITableViewCell() }

            cell.configure(from: cellModel)

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: TrackerSchedulePickerCell.self),
                for: indexPath
            ) as? TrackerSchedulePickerCell

            let cellModel = categorySection[safe: indexPath.row]

            guard let cell, let cellModel else { return UITableViewCell() }

            cell.configure(from: cellModel)

            return cell
        }
    }
}

extension TrackerFormViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: false)

        if indexPath.section == 1,
           let cellModel = categorySection[safe: indexPath.row] as? TrackerCategoryPickerCellModel {
            cellModel.selectionHandler?(cellModel)
        } else if indexPath.section == 1,
                  let cellModel = categorySection[safe: indexPath.row] as? TrackerSchedulePickerCellModel {
            cellModel.selectionHandler?(cellModel)
        }
    }
}

extension TrackerFormViewController: WeekDayPickerDelegate {
    func didSelectSchedule(_ schedule: [WeekDay]) {
        navigationController?.popViewController(animated: true)
        selectedSchedule = schedule

        guard let scheduleCellModel = categorySection.last as? TrackerSchedulePickerCellModel else { return }

        scheduleCellModel.schedule = schedule
        trackerParametersTableView.reloadRows(at: [IndexPath(row: 2, section: 1)], with: .none)
    }
}

extension TrackerFormViewController: TrackerCategoryPickerDelegate {
    func didSelectCategory(_ category: TrackerCategory, fromViewController vc: UIViewController) {
        navigationController?.popViewController(animated: true)
        self.selectedCategory = category

        guard let categoryCellModel = categorySection[safe: 1] as? TrackerCategoryPickerCellModel else { return }

        categoryCellModel.category = category
        trackerParametersTableView.reloadRows(at: [IndexPath(row: 1, section: 1)], with: .none)

        vc.dismiss(animated: true)
    }
}

private extension TrackerFormViewController {
    // MARK: Business Logic

    func checkFormState() {
        
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
        let viewController = TrackerCategoryPickerViewController()
        viewController.delegate = self
        viewController.selectedCategory = selectedCategory
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
              let selectedSchedule else {
            assertionFailure("Invalid category form state")
            return
        }

        let tracker = Tracker(
            id: UUID(),
            title: trackerTitle,
            color: .purple,
            emoji: "🎉",
            schedule: selectedSchedule
        )

        trackersStorageService.append(tracker: tracker, toCategory: selectedCategory, fromViewController: navigationController)
    }
}
