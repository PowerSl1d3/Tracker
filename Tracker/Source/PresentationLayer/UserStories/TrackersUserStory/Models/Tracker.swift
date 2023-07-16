//
//  Tracker.swift
//  Tracker
//
//  Created by Олег Аксененко on 27.06.2023.
//

import UIKit

struct Tracker {
    let id: UUID
    let title: String
    let color: UIColor
    let emoji: Character
    let schedule: [WeekDay]
}
