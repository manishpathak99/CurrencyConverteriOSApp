//
//  CurrencyPickerViewModelTests.swift
//  CurrencyApplicationTests
//
//  Created by Manish Pathak on 21/09/22.
//  Copyright © 2022 Manish Pathak. All rights reserved.
//

import XCTest
import RxSwift
@testable import CurrencyApplication

class CurrencyPickerViewModelTests: XCTestCase {
    var viewModel: CurrencyPickerViewModel!
    fileprivate var tableDataSource: MockTableDataSource!
    fileprivate var disposeBag = DisposeBag()

    override func setUp() {
        super.setUp()
        self.tableDataSource = MockTableDataSource()
        self.viewModel = CurrencyPickerViewModel(dataSource: tableDataSource)
    }

    override func tearDown() {
        self.viewModel = nil
        self.tableDataSource = nil
        super.tearDown()
    }

    func testInitialization() {
        // Initialize currency View Model
        XCTAssertNotNil(viewModel, "The currency view model should not be nil.")
        XCTAssertTrue(viewModel?.dataSource === tableDataSource, "The table datasource should be equal to the profile that was passed in.")
    }

}
