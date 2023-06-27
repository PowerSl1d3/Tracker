//
//  Tracker.swift
//  Tracker
//
//  Created by Олег Аксененко on 27.06.2023.
//

import UIKit

struct Tracker {
    enum WeekDay {
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
        case sanday

        case everyDay
    }

    let id: UUID
    let title: String
    let color: UIColor
    let emoji: Character
    let schedule: Set<WeekDay>
}
