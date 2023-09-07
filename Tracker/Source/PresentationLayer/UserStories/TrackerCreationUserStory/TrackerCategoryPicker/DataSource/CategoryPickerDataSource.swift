//
//  CategoryPickerDataSource.swift
//  Tracker
//
//  Created by Олег Аксененко on 07.09.2023.
//

import UIKit

final class CategoryPickerDataSource: NSObject {
    weak var viewModel: TrackerCategoryPickerViewModel?
}

extension CategoryPickerDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.cellModels.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: TrackerCategoryCell.reuseIdentifier,
            for: indexPath
        ) as? TrackerCategoryCell

        guard let cell,
              let cellModel = viewModel?.cellModels[safe: indexPath.row] else {
            return UITableViewCell()
        }

        cell.tableView = tableView
        cell.configure(from: cellModel)

        return cell
    }
}
