//
//  StatisticCellModel.swift
//  Tracker
//
//  Created by Олег Аксененко on 27.09.2023.
//

import Foundation

final class StatisticCellModel {
    let countOfSubStatistic: Int
    let description: String

    init(countOfSubStatistic: Int, description: String) {
        self.countOfSubStatistic = countOfSubStatistic
        self.description = description
    }
}
