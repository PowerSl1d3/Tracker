//
//  TrackerFormAssembly.swift
//  Tracker
//
//  Created by Олег Аксененко on 18.09.2023.
//

import UIKit

final class TrackerFormAssembly {
    private init() {}

    static func assemble(with configuration: TrackerFormConfiguration) -> UIViewController {
        TrackerFormViewController(with: configuration)
    }
}
