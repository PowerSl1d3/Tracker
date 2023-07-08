//
//  TrackerCategoryPickerDelegate.swift
//  Tracker
//
//  Created by Олег Аксененко on 30.06.2023.
//

import UIKit

protocol TrackerCategoryPickerDelegate: AnyObject {
    func didSelectCategory(_ category: TrackerCategory, fromViewController vc: UIViewController)
}
