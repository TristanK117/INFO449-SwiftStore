//
//  StoreTests.swift
//  StoreTests
//
//  Created by Ted Neward on 2/29/24.
//

import XCTest

final class StoreTests: XCTestCase {

    var register = Register()

    override func setUpWithError() throws {
        register = Register()
    }

    override func tearDownWithError() throws { }

    func testBaseline() throws {
        XCTAssertEqual("0.1", Store().version)
        XCTAssertEqual("Hello world", Store().helloWorld())
    }
    
    func testOneItem() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(199, receipt.total())

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
------------------
TOTAL: $1.99
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testMultipleSameItemsReceipt() { // Multiple Items Testcase 1
        register.scan(Item(name: "Pencil", priceEach: 99))
        register.scan(Item(name: "Pencil", priceEach: 99))
        register.scan(Item(name: "Pencil", priceEach: 99))

        XCTAssertEqual(register.subtotal(), 297)

        let receipt = register.total()
        XCTAssertEqual(receipt.total(), 297)

        let expectedReceipt = """
Receipt:
Pencil: $0.99
Pencil: $0.99
Pencil: $0.99
------------------
TOTAL: $2.97
"""
        XCTAssertEqual(receipt.output(), expectedReceipt)
    }
    
    func testEmptyReceipt() { // Testcase 2, 0 items
        XCTAssertEqual(register.subtotal(), 0)

        let receipt = register.total()
        XCTAssertEqual(receipt.total(), 0)

        let expectedReceipt = """
Receipt:
------------------
TOTAL: $0.00
"""
        XCTAssertEqual(receipt.output(), expectedReceipt)
    }

    func testWeighedItem() {
        let bananas = WeighedItem(name: "Bananas", pricePerPound: 199, weight: 1.25) // $1.99/lb × 1.25 lbs = ~$2.49
        register.scan(bananas)

        XCTAssertEqual(register.subtotal(), 249)

        let receipt = register.total()
        XCTAssertEqual(receipt.total(), 249)

        let expectedReceipt = """
Receipt:
Bananas: $2.49
------------------
TOTAL: $2.49
"""
        XCTAssertEqual(receipt.output(), expectedReceipt)
    }
    
    func testThreeSameItems() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199 * 3, register.subtotal())
    }
    
    func testThreeDifferentItems() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        register.scan(Item(name: "Pencil", priceEach: 99))
        XCTAssertEqual(298, register.subtotal())
        register.scan(Item(name: "Granols Bars (Box, 8ct)", priceEach: 499))
        XCTAssertEqual(797, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(797, receipt.total())

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
Pencil: $0.99
Granols Bars (Box, 8ct): $4.99
------------------
TOTAL: $7.97
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
}
