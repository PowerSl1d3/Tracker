//
//  TrackersDataSource.swift
//  Tracker
//
//  Created by Олег Аксененко on 06.09.2023.
//

import UIKit

final class TrackersDataSource: NSObject {
    private weak var viewModel: TrackersViewModel?

    init(viewModel: TrackersViewModel) {
        self.viewModel = viewModel

        super.init()
    }
}

extension TrackersDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.visibleCategories.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let category = viewModel?.visibleCategories[safe: section] else { return .zero }

        return category.trackers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCardCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? TrackerCardCollectionViewCell

        guard let cell,
              let category = viewModel?.visibleCategories[safe: indexPath.section],
              let cellModel = category.trackers[safe: indexPath.row] else {
            return UICollectionViewCell()
        }

        cell.prepareForReuse()

        // TODO: когда нибудь заменить на фильрацию при помощи CoreData
        guard let currentDate = viewModel?.currentDate,
              let completedDays = viewModel?.completedTrackerRecords.filter({ $0.id == cellModel.id }) else {
            return UICollectionViewCell()
        }

        let currentDateTrackerRecord = completedDays.first(where: { $0.date == viewModel?.currentDate })

        cell.configure(
            cellModel: cellModel,
            completedDays: completedDays.count,
            isCurrentDateCompleted: currentDateTrackerRecord != nil,
            isFutureDate: currentDate > Date()
        ) { [weak self] cellModel in
            guard let self, let cellModel, let viewModel else { return }

            if let currentDateTrackerRecord {
                try? viewModel.dataProvider?.deleteRecord(currentDateTrackerRecord)
            } else {
                try? viewModel.dataProvider?.addRecord(TrackerRecord(id: cellModel.id, date: viewModel.currentDate))
            }

            collectionView.reloadItems(at: [indexPath])
        }


        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackerCardsCategoryHeaderView.reuseIdentifier,
            for: indexPath
        ) as? TrackerCardsCategoryHeaderView

        guard let headerView,
              let category = viewModel?.visibleCategories[safe: indexPath.section] else {
            return UICollectionReusableView()
        }

        headerView.titleLabel.text = category.title

        return headerView
    }
}
