//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Олег Аксененко on 18.06.2023.
//

import UIKit

final class StatisticsViewController: UIViewController {
    let statisticsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Asset.ypWhite.color
        tableView.separatorColor = Asset.ypGray.color
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false

        return tableView
    }()

    let placeholderView: TrackersPlaceholderView = {
        let placeholderView = TrackersPlaceholderView()
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.placeholderImage = Asset.emptyScreenEmoji.image
        placeholderView.title = LocalizedString("statistics.placeholder")
        placeholderView.isHidden = true

        return placeholderView
    }()

    private var viewModel: StatisticsViewModel?

    func initialize(viewModel: StatisticsViewModel) {
        self.viewModel = viewModel
        bind()
    }

    func bind() {
        viewModel?.$cellModels.bindAndCall { [weak self] cellModels in
            guard let self else { return }

            placeholderView.isHidden = !cellModels.isEmpty
            statisticsTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        statisticsTableView.dataSource = viewModel?.dataSource
        statisticsTableView.delegate = self

        statisticsTableView.register(
            StatisticCell.self,
            forCellReuseIdentifier: StatisticCell.reuseIdentifier
        )

        view.backgroundColor = Asset.ypWhite.color
        navigationItem.title = LocalizedString("statistics.navItem")
        navigationItem.hidesBackButton = true

        statisticsTableView.addSubview(placeholderView)

        view.addSubview(statisticsTableView)

        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel?.viewWillAppear()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        statisticsTableView.contentInset = UIEdgeInsets(top: 50, left: .zero, bottom: .zero, right: .zero)
    }
}

extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
}

private extension StatisticsViewController {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            placeholderView.centerXAnchor.constraint(equalTo: statisticsTableView.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: statisticsTableView.centerYAnchor),
            placeholderView.leadingAnchor.constraint(equalTo: statisticsTableView.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: statisticsTableView.trailingAnchor),

            statisticsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            statisticsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            statisticsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            statisticsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
