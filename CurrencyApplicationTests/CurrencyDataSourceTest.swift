//
//  CurrencyDataSourceTest.swift
//  CurrencyApplicationTests
//
//  Created by Manish Pathak on 21/09/22.
//  Copyright © 2022 Manish Pathak. All rights reserved.
//

import Foundation

import XCTest
@testable import CurrencyApplication

class CurrencyDataSourceTests: XCTestCase {

    var dataSource : CurrencyDataSource!

    override func setUp() {
        super.setUp()
        dataSource = CurrencyDataSource()
    }
    
    override func tearDown() {
        dataSource = nil
        super.tearDown()
    }
    
    func testValueInDataSource() {
        let rate1 =  RateModel(currency: "AED", value: 3.637754)
        let rate2 =  RateModel(currency: "AFN", value: 102.403427)
        dataSource.rates = [rate1, rate2]
        XCTAssertEqual(dataSource.getSectionCount() , 1, "Expected one section in table view")
        XCTAssertEqual(dataSource.getRowCount(), 2, "Expected no cell in table view")
    }
}
