//
//  TrackerCategoryPickerViewController.swift
//  Tracker
//
//  Created by Олег Аксененко on 30.06.2023.
//

import UIKit

final class TrackerCategoryPickerViewController: UIViewController {
    let categoriesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .ypWhite
        tableView.separatorColor = .ypGray
        tableView.allowsMultipleSelection = false

        return tableView
    }()

    let addCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .ypBlack
        button.setTitleColor(.ypWhite, for: .normal)
        button.layer.cornerRadius = 16
        button.clipsToBounds = true

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.ypMediumFont(ofSize: 16)
        ]

        button.setAttributedTitle(NSAttributedString(string: LocalizedString("trackersCategoryCreation.button.title"), attributes: attributes), for: .normal)

        return button
    }()

    let placeholderView: TrackersPlaceholderStarView = {
        let placeholderView = TrackersPlaceholderStarView()
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.titleLabel.text = LocalizedString("trackersCategoryCreation.placeholder.title")
        placeholderView.isHidden = true

        return placeholderView
    }()

    private var viewModel: TrackerCategoryPickerViewModel?

    func initialize(viewModel: TrackerCategoryPickerViewModel) {
        self.viewModel = viewModel
        bind()
    }

    func bind() {
        viewModel?.$cellModels.bindAndCall { [weak self] cellModels in
            guard let self else { return }

            categoriesTableView.reloadData()
            placeholderView.isHidden = !cellModels.isEmpty
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addCategoryButton.addTarget(self, action: #selector(didTapAddCategoryButton), for: .touchUpInside)

        categoriesTableView.dataSource = viewModel?.dataSource
        categoriesTableView.delegate = self

        categoriesTableView.register(
            TrackerCategoryCell.self,
            forCellReuseIdentifier: TrackerCategoryCell.reuseIdentifier
        )

        view.backgroundColor = .ypWhite
        navigationItem.title = LocalizedString("trackersCategoryCreation.navItem")
        navigationItem.hidesBackButton = true

        categoriesTableView.addSubview(placeholderView)

        view.addSubview(categoriesTableView)
        view.addSubview(addCategoryButton)

        setupConstraints()
    }
}

extension TrackerCategoryPickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCellModel = viewModel?.cellModels[safe: indexPath.row] else { return }
        viewModel?.tableView(didSelectRowAt: indexPath)
        viewModel?.delegate?.didSelectCategory(selectedCellModel.category, fromViewController: self)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}

private extension TrackerCategoryPickerViewController {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            placeholderView.centerXAnchor.constraint(equalTo: categoriesTableView.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: categoriesTableView.centerYAnchor),
            placeholderView.leadingAnchor.constraint(equalTo: categoriesTableView.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: categoriesTableView.trailingAnchor),

            categoriesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            categoriesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categoriesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            categoriesTableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -24),

            addCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc func didTapAddCategoryButton() {
        viewModel?.didTapAddCategoryButton()
    }
}
