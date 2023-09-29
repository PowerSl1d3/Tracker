//
//  FilterPickerDataSource.swift
//  Tracker
//
//  Created by Олег Аксененко on 22.09.2023.
//

import UIKit

final class FilterPickerDataSource: NSObject {
    weak var viewModel: FilterPickerViewModel?
}

extension FilterPickerDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        TrackerFilter.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: FilterTypeCell.reuseIdentifier,
            for: indexPath
        ) as? FilterTypeCell

        let cellModel = viewModel?.cellModels[safe: indexPath.row]

        guard let cell, let cellModel else { return UITableViewCell() }

        cell.prepareForReuse()
        cell.configure(from: cellModel)

        if cellModel.isSelected {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }

        return cell
    }
}
