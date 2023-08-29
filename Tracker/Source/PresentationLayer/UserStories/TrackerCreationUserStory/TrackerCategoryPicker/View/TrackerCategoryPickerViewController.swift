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

        button.setAttributedTitle(NSAttributedString(string: "Добавить категорию", attributes: attributes), for: .normal)

        return button
    }()

    let placeholderView: TrackersPlaceholderStarView = {
        let placeholderView = TrackersPlaceholderStarView()
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.titleLabel.text = "Привычки и события можно объединить по смыслу"
        placeholderView.isHidden = true

        return placeholderView
    }()

    weak var delegate: TrackerCategoryPickerDelegate?
    var selectedCategory: TrackerCategory?

    private var cellModels: [TrackerCategoryCellModel] = [] {
        didSet {
            placeholderView.isHidden = !cellModels.isEmpty
        }
    }

    private lazy var trackersDataProvider: TrackersDataProvider = {
        TrackersDataProviderAssembly.assemble(delegate: self)
    }()
    private weak var categoryCreationViewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        reloadCellModels()

        addCategoryButton.addTarget(self, action: #selector(didTapAddCategoryButton), for: .touchUpInside)

        categoriesTableView.dataSource = self
        categoriesTableView.delegate = self

        categoriesTableView.register(
            TrackerCategoryCell.self,
            forCellReuseIdentifier: TrackerCategoryCell.reuseIdentifier
        )

        view.backgroundColor = .ypWhite
        navigationItem.title = "Категория"
        navigationItem.hidesBackButton = true

        categoriesTableView.addSubview(placeholderView)

        view.addSubview(categoriesTableView)
        view.addSubview(addCategoryButton)

        setupConstraints()
    }
}

extension TrackerCategoryPickerViewController: TrackersDataProviderDelegate {
    func didUpdate(_ update: TrackersStoreUpdate) {
        guard update.type == .category, let index = update.insertedIndexes.first else {
            return
        }

        reloadCellModels()
        categoriesTableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        categoryCreationViewController?.dismiss(animated: true)
    }

    func didAppendCategory(_ category: TrackerCategory, fromViewController vc: UIViewController?) {
        cellModels.append(TrackerCategoryCellModel(category: category, isSelected: false))

        let indexPath = IndexPath(row: cellModels.count - 1, section: 0)
        categoriesTableView.insertRows(at: [indexPath], with: .fade)

        vc?.dismiss(animated: true)
    }
}

extension TrackerCategoryPickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: TrackerCategoryCell.reuseIdentifier,
            for: indexPath
        ) as? TrackerCategoryCell

        guard let cell,
              let cellModel = cellModels[safe: indexPath.row] else {
            return UITableViewCell()
        }

        cell.configure(from: cellModel)

        return cell
    }
}

extension TrackerCategoryPickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCellModel = cellModels[safe: indexPath.row] else { return }

        var lastSelectedRowIndexPath: Int?
        var lastSelectedCellModel: TrackerCategoryCellModel?
        for (index, cellModel) in cellModels.enumerated() {
            if cellModel.isSelected {
                lastSelectedRowIndexPath = index
                lastSelectedCellModel = cellModel
                break
            }
        }

        lastSelectedCellModel?.isSelected = false
        selectedCellModel.isSelected = true

        tableView.reloadRows(
            at: [
                indexPath,
                IndexPath(
                    row: lastSelectedRowIndexPath ?? indexPath.row,
                    section: indexPath.section
                )
            ],
            with: .fade
        )
        delegate?.didSelectCategory(selectedCellModel.category, fromViewController: self)
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
        let viewController = CategoryCreationViewController()
        viewController.modalPresentationStyle = .pageSheet
        categoryCreationViewController = viewController

        present(viewController, animated: true)
    }
}

private extension TrackerCategoryPickerViewController {
    func reloadCellModels() {
        cellModels = trackersDataProvider.sections()?.compactMap { category in
            TrackerCategoryCellModel(category: category, isSelected: category.title == selectedCategory?.title)
        } ?? []
    }
}
