//
//  TrackerTypePickerViewController.swift
//  Tracker
//
//  Created by Олег Аксененко on 28.06.2023.
//

import UIKit

final class TrackerTypePickerViewController: UIViewController {
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    let habitButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .ypBlack
        button.setTitleColor(.ypWhite, for: .normal)
        button.layer.cornerRadius = 16
        button.clipsToBounds = true

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.ypMediumFont(ofSize: 16)
        ]

        button.setAttributedTitle(NSAttributedString(string: "Привычка", attributes: attributes), for: .normal)

        return button
    }()

    let eventButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .ypBlack
        button.setTitleColor(.ypWhite, for: .normal)
        button.layer.cornerRadius = 16
        button.clipsToBounds = true

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.ypMediumFont(ofSize: 16)
        ]

        button.setAttributedTitle(NSAttributedString(string: "Нерегулярные события", attributes: attributes), for: .normal)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        habitButton.addTarget(self, action: #selector(didTapCreateTrackerButton(_:)), for: .touchUpInside)
        eventButton.addTarget(self, action: #selector(didTapCreateTrackerButton(_:)), for: .touchUpInside)

        view.backgroundColor = .ypWhite
        navigationItem.title = "Создание трекера"

        containerView.addSubview(habitButton)
        containerView.addSubview(eventButton)
        view.addSubview(containerView)

        setupConstraints()
    }
}

private extension TrackerTypePickerViewController {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            habitButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            habitButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            habitButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            habitButton.heightAnchor.constraint(equalToConstant: 60),

            eventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
            eventButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            eventButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            eventButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            eventButton.heightAnchor.constraint(equalToConstant: 60),

            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc func didTapCreateTrackerButton(_ sender: UIControl) {
        let viewController = TrackerFormViewController(trackerType: sender === habitButton ? .habit : .event)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
