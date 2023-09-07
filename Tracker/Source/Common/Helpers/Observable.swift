//
//  Observable.swift
//  Tracker
//
//  Created by Олег Аксененко on 05.09.2023.
//

@propertyWrapper final class Observable<Value> {
    private var onChangeItems: [((Value) -> Void)?] = []

    var wrappedValue: Value {
        didSet {
            onChangeItems.forEach { $0?(wrappedValue) }
        }
    }

    var projectedValue: Observable<Value> { self }

    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    func bind(action: @escaping (Value) -> Void) {
        onChangeItems.append(action)
    }

    func bindAndCall(action: @escaping (Value) -> Void) {
        onChangeItems.append(action)
        action(wrappedValue)
    }
}
