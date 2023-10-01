//
//  Array+Tracker.swift
//  Tracker
//
//  Created by Олег Аксененко on 27.06.2023.
//

extension Array {
    subscript (safe index: Int) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
