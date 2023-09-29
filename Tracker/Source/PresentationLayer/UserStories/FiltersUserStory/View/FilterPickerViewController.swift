//
//  FilterPickerViewController.swift
//  Tracker
//
//  Created by Олег Аксененко on 21.09.2023.
//

import UIKit

final class FilterPickerViewController: UIViewController {
    private let filtersTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Asset.ypWhite.color
        tableView.separatorColor = Asset.ypGray.color
        tableView.allowsMultipleSelection = false

        return tableView
    }()

    private var viewModel: FilterPickerViewModel?

    func initialize(viewModel: FilterPickerViewModel) {
        self.viewModel = viewModel
        bind()
    }

    func bind() {
        viewModel?.$cellModels.bindAndCall { [weak self] _ in
            self?.filtersTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        filtersTableView.dataSource = viewModel?.dataSource
        filtersTableView.delegate = self

        filtersTableView.register(
            FilterTypeCell.self,
            forCellReuseIdentifier: FilterTypeCell.reuseIdentifier
        )

        view.backgroundColor = Asset.ypWhite.color
        navigationItem.title = LocalizedString("filterPicker.navItem")
        navigationItem.hidesBackButton = true

        view.addSubview(filtersTableView)

        setupConstraints()
    }
}

extension FilterPickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FilterTypeCell else {
            return
        }

        cell.state = .deselected
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FilterTypeCell,
              let cellModel = viewModel?.cellModels[safe: indexPath.row] else {
            return
        }

        cell.state = .selected
        viewModel?.didSelectFilter(cellModel.filter)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}

private extension FilterPickerViewController {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            filtersTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            filtersTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            filtersTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            filtersTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
