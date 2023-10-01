//
//  StatisticsViewModel.swift
//  Tracker
//
//  Created by Олег Аксененко on 27.09.2023.
//

final class StatisticsViewModel {
    let model: StatisticsModel
    var dataSource: StatisticsDataSource? { model.dataSource }

    @Observable
    var cellModels: [StatisticCellModel] = []

    init(from model: StatisticsModel) {
        self.model = model
        reloadCellModels()
    }

    func viewWillAppear() {
        reloadCellModels(completedTrackersCount: model.preferences.completedTrackersCount)
    }
}

private extension StatisticsViewModel {
    func reloadCellModels(completedTrackersCount: Int = .zero) {
        cellModels.removeAll()

        if completedTrackersCount != .zero {
            cellModels.append(
                StatisticCellModel(
                    countOfSubStatistic: completedTrackersCount,
                    description: LocalizedString("statistics.completedTrackersCount")
                )
            )
        }
    }
}
