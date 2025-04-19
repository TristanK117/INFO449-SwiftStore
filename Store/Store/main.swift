//
//  main.swift
//  Store
//
//  Created by Ted Neward on 2/29/24.
//

import Foundation

protocol SKU {
    var name: String { get }
    func price() -> Int
}

class Item: SKU {
    let name: String
    private let priceInCents: Int

    init(name: String, priceEach: Int) {
        self.name = name
        self.priceInCents = priceEach
    }

    func price() -> Int {
        return priceInCents
    }
}

class Receipt {
    private var items: [SKU] = []

    func add(_ item: SKU) {
        items.append(item)
    }

    func total() -> Int {
        return items.reduce(0) { $0 + $1.price() }
    }

    func output() -> String {
        var lines = ["Receipt:"]
        for item in items {
            let dollars = Double(item.price()) / 100.0
            lines.append("\(item.name): $\(String(format: "%.2f", dollars))")
        }
        lines.append("------------------")
        let totalDollars = Double(total()) / 100.0
        lines.append("TOTAL: $\(String(format: "%.2f", totalDollars))")
        return lines.joined(separator: "\n")
    }

    func allItems() -> [SKU] {
        return items
    }
}

class Register {
    private var currentReceipt = Receipt()

    func scan(_ item: SKU) {
        currentReceipt.add(item)
    }

    func subtotal() -> Int {
        return currentReceipt.total()
    }

    func total() -> Receipt {
        let finishedReceipt = currentReceipt
        currentReceipt = Receipt()
        return finishedReceipt
    }
}

class Store {
    let version = "0.1"
    func helloWorld() -> String {
        return "Hello world"
    }
}
