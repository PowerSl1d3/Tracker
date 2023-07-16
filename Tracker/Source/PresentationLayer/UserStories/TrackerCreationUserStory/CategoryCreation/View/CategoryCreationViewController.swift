//
//  CategoryCreationViewController.swift
//  Tracker
//
//  Created by Олег Аксененко on 01.07.2023.
//

import UIKit

final class CategoryCreationViewController: UIViewController {
    private let categoryTextFieldTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .ypWhite
        tableView.separatorColor = .ypGray
        tableView.allowsMultipleSelection = false

        return tableView
    }()

    private let doneButton: UIButton = {
        let button = StateButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.setTitle("Готово", for: .disabled)
        button.isEnabled = false

        return button
    }()

    private var section: [TrackerBaseCellModelProtocol] = []
    private var categoryTitle: String?

    var trackersStorageService: TrackersStorageService!

    override func viewDidLoad() {
        super.viewDidLoad()

        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)

        section = [
            TrackerTitleTextFieldCellModel(title: nil, placeholder: "Введите название категории") { [weak self] cellModel, didShowError in
                guard let self else { return }

                categoryTitle = cellModel.title
                doneButton.isEnabled = cellModel.title?.count ?? 0 > 0

                if didShowError && section.count == 1 {
                    section.append(TrackerErrorCellModel(errorText: "Ограничение 38 символов"))
                    categoryTextFieldTableView.insertRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
                } else if !didShowError && section.count == 2 {
                    _ = section.popLast()
                    categoryTextFieldTableView.deleteRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
                }
            }
        ]

        categoryTextFieldTableView.dataSource = self

        categoryTextFieldTableView.register(
            TrackerTitleTextFieldCell.self,
            forCellReuseIdentifier: String(describing: TrackerTitleTextFieldCell.self)
        )

        categoryTextFieldTableView.register(
            TrackerErrorCell.self,
            forCellReuseIdentifier: String(describing: TrackerErrorCell.self)
        )

        view.backgroundColor = .ypWhite
        navigationItem.title = "Категория"
        navigationItem.hidesBackButton = true

        view.addSubview(categoryTextFieldTableView)
        view.addSubview(doneButton)

        setupConstraints()
    }
}

extension CategoryCreationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.section.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: TrackerTitleTextFieldCell.self),
                for: indexPath
            ) as? TrackerTitleTextFieldCell

            guard let cell,
                  let cellModel = section[safe: indexPath.row] else {
                return UITableViewCell()
            }

            cell.configure(from: cellModel)

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: TrackerErrorCell.self),
                for: indexPath
            ) as? TrackerErrorCell

            guard let cell,
                  let cellModel = section[safe: indexPath.row] else {
                return UITableViewCell()
            }

            cell.configure(from: cellModel)

            return cell
        }
    }
}

private extension CategoryCreationViewController {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            categoryTextFieldTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            categoryTextFieldTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categoryTextFieldTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            categoryTextFieldTableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -24),

            doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc func didTapDoneButton() {
        guard let categoryTitle else { return }

        let category = TrackerCategory(trackers: [], title: categoryTitle)
        trackersStorageService.append(category: category, fromViewController: self)
    }
}
