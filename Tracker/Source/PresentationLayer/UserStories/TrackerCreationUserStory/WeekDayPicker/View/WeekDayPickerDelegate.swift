//
//  WeekDayPickerDelegate.swift
//  Tracker
//
//  Created by Олег Аксененко on 30.06.2023.
//

import UIKit

protocol WeekDayPickerDelegate: AnyObject {
    func didSelectSchedule(_ schedule: [WeekDay])
}
