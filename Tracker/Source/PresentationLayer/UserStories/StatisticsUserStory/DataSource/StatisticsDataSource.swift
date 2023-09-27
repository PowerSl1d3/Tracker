//
//  StatisticsDataSource.swift
//  Tracker
//
//  Created by Олег Аксененко on 27.09.2023.
//

import UIKit

final class StatisticsDataSource: NSObject {
    weak var viewModel: StatisticsViewModel?
}

extension StatisticsDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.cellModels.count ?? .zero
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: StatisticCell.reuseIdentifier, for: indexPath
        ) as? StatisticCell

        let cellModel = viewModel?.cellModels[safe: indexPath.row]

        guard let cell, let cellModel else { return UITableViewCell() }

        cell.prepareForReuse()
        cell.configure(from: cellModel)

        return cell
    }
}
