//
//  TrackerBaseSection.swift
//  Tracker
//
//  Created by Олег Аксененко on 13.08.2023.
//

final class TrackerBaseSection {
    var name: String?
    private var cellModels: [TrackerBaseCellModelProtocol]

    init(name: String? = nil, cellModels: [TrackerBaseCellModelProtocol]) {
        self.cellModels = cellModels
        self.name = name
    }

    convenience init(name: String? = nil, cellModel: TrackerBaseCellModelProtocol) {
        self.init(name: name, cellModels: [cellModel])
    }

    var count: Int { cellModels.count }
    
    var last: TrackerBaseCellModelProtocol? { cellModels.last }

    func append(_ cellModels: [TrackerBaseCellModel]) {
        self.cellModels.append(contentsOf: cellModels)
    }

    func append(_ cellModel: TrackerBaseCellModel) {
        append([cellModel])
    }

    @discardableResult func pop() -> TrackerBaseCellModelProtocol? {
        cellModels.popLast()
    }

    subscript(safe index: Int) -> TrackerBaseCellModelProtocol? {
        cellModels[safe: index]
    }

    func enumerated() -> EnumeratedSequence<[TrackerBaseCellModelProtocol]> {
        cellModels.enumerated()
    }

    func first(where predicate: (TrackerBaseCellModelProtocol) -> Bool) -> TrackerBaseCellModelProtocol? {
        cellModels.first(where: predicate)
    }
}
