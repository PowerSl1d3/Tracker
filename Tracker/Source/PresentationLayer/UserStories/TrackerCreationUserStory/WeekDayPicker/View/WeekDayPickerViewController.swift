//
//  WeekDayPickerViewController.swift
//  Tracker
//
//  Created by Олег Аксененко on 30.06.2023.
//

import UIKit

final class WeekDayPickerViewController: UIViewController {
    let weekDayTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        tableView.backgroundColor = .ypWhite
        tableView.separatorColor = .ypGray

        return tableView
    }()

    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.clipsToBounds = true

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.ypMediumFont(ofSize: 16),
            .foregroundColor: UIColor.ypWhite
        ]

        button.setAttributedTitle(NSAttributedString(string: "Готово", attributes: attributes), for: .normal)

        return button
    }()

    let cellModels: [WeekDaySwitchCellModel] = {
        WeekDay.allCases.map { weekDay in
            WeekDaySwitchCellModel(weekDay: weekDay)
        }
    }()

    weak var delegate: WeekDayPickerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)

        weekDayTableView.dataSource = self
        weekDayTableView.delegate = self

        weekDayTableView.register(WeekDaySwitchCell.self, forCellReuseIdentifier: WeekDaySwitchCell.reuseIdentifier)

        view.backgroundColor = .ypWhite
        navigationItem.title = "Расписание"
        navigationItem.hidesBackButton = true

        view.addSubview(weekDayTableView)
        view.addSubview(doneButton)

        setupConstraints()
    }

    func setSchedule(_ schedule: [WeekDay]) {
        for day in schedule {
            cellModels[day.rawValue].isIncluded = true
        }
    }
}

extension WeekDayPickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: WeekDaySwitchCell.reuseIdentifier,
            for: indexPath
        ) as? WeekDaySwitchCell

        guard let cell, let cellModel = cellModels[safe: indexPath.row] else { return UITableViewCell() }

        cell.configure(from: cellModel)

        return cell
    }
}

extension WeekDayPickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

private extension WeekDayPickerViewController {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            weekDayTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            weekDayTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            weekDayTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            weekDayTableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -24),

            doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc func didTapDoneButton() {
        delegate?.didSelectSchedule(cellModels.compactMap { $0.isIncluded ? $0.weekDay : nil })
    }
}
