//
//  Optional+Tracker.swift
//  Tracker
//
//  Created by Олег Аксененко on 19.09.2023.
//

extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}
