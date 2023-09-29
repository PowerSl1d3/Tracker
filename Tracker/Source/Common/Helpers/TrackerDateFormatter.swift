//
//  TrackerDateFormatter.swift
//  Tracker
//
//  Created by Олег Аксененко on 22.09.2023.
//

import Foundation

final class TrackerDateFormatter {
    private let calendar = Calendar.current

    func startOfDay(_ date: Date) -> Date? {
        calendar.startOfDay(for: date)
    }
}
