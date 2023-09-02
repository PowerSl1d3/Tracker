//
//  OnboardPageViewController.swift
//  Tracker
//
//  Created by Олег Аксененко on 02.09.2023.
//

import UIKit

final class OnboardPageViewController: UIPageViewController {
    lazy var pages: [UIViewController] = [
        OnboardViewController(imageName: "onboarding0", inviteText: "Отслеживайте только то, что хотите"),
        OnboardViewController(imageName: "onboarding1", inviteText: "Даже если это не литры воды йога")
    ]

    private let inviteButton: UIButton = {
        let button = StateButton()
        button.setTitle("Вот это технологии!", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false

        pageControl.currentPage = 0
        pageControl.numberOfPages = pages.count

        pageControl.currentPageIndicatorTintColor = .ypBlack
            .resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        pageControl.pageIndicatorTintColor = .ypBlack
            .resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
            .withAlphaComponent(0.3)

        return pageControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        inviteButton.addTarget(self, action: #selector(didTapInviteButton), for: .touchUpInside)

        dataSource = self
        delegate = self

        view.addSubview(inviteButton)
        view.addSubview(pageControl)

        guard let initialVC = pages.first else { return }
        setViewControllers([initialVC], direction: .forward, animated: true)

        setupConstraints()
    }
}

extension OnboardPageViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else { return pages.last }

        return pages[previousIndex]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }

        let nextIndex = viewControllerIndex + 1

        guard nextIndex < pages.count else { return pages.first }

        return pages[nextIndex]
    }
}

extension OnboardPageViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}

private extension OnboardPageViewController {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: inviteButton.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),

            inviteButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            inviteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            inviteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            inviteButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc func didTapInviteButton() {
        guard let window = view.window else { return }

        let tabBarController = TabBarController()
        window.rootViewController = tabBarController

        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: nil
        )
    }
}
