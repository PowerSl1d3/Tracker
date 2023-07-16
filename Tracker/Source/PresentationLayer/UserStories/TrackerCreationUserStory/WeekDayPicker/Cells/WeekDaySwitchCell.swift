//
//  WeekDaySwitchCell.swift
//  Tracker
//
//  Created by Олег Аксененко on 30.06.2023.
//

import UIKit

final class WeekDaySwitchCell: UITableViewCell {
    static let reuseIdentifier = String(describing: WeekDaySwitchCell.self)

    let switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.onTintColor = .ypBlue

        return switchControl
    }()

    let weekDayFormatter = WeekDayFormatter()

    var cellModel: WeekDaySwitchCellModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        switchControl.addTarget(self, action: #selector(didChangeSwitchValue(_:)), for: .valueChanged)

        backgroundColor = .ypBackground
        separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        accessoryView = switchControl
        textLabel?.font = .ypRegularFont(ofSize: 17)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(from cellModel: WeekDaySwitchCellModel) {
        self.cellModel = cellModel
        switchControl.isOn = cellModel.isIncluded
        textLabel?.text = weekDayFormatter.formattedDay(cellModel.weekDay)
    }
}

private extension WeekDaySwitchCell {
    @objc func didChangeSwitchValue(_ sender: UISwitch) {
        cellModel?.isIncluded = sender.isOn
    }
}
