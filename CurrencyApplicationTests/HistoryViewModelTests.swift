//
//  HistoryViewModelTests.swift
//  CurrencyApplicationTests
//
//  Created by Manish Pathak on 21/09/22.
//  Copyright © 2022 Manish Pathak. All rights reserved.
//

import XCTest
import RxSwift
@testable import CurrencyApplication

class HistoryViewModelTests: XCTestCase {
    var viewModel: HistoryViewModel!
    fileprivate var service: MockCurrencyService!
    fileprivate var tableDataSource: MockTableDataSource!
    fileprivate var parseManger: MockParseManager!
    fileprivate var disposeBag = DisposeBag()

    override func setUp() {
        super.setUp()
        self.service = MockCurrencyService()
        self.tableDataSource = MockTableDataSource()
        self.parseManger = MockParseManager()
        self.viewModel = HistoryViewModel(networkManager: self.service, dataSource: tableDataSource, parseManager: parseManger)
    }

    override func tearDown() {
        self.viewModel = nil
        self.service = nil
        self.tableDataSource = nil
        self.parseManger = nil
        super.tearDown()
    }
    func testInitialization() {
        // Initialize currency View Model
        XCTAssertNotNil(viewModel, "The History view model should not be nil.")
        XCTAssertTrue(viewModel?.dataSource === tableDataSource, "The table datasource should be equal to the profile that was passed in.")
    }
    func testFetchWithOutNetworkManager() {
        viewModel.networkManager = nil
        let expectation = XCTestExpectation(description: "ViewModel should not be able to fetch without network manager")

        // expected to not be able to fetch currencies
        viewModel.showErrorMessage.asObservable().subscribe(onNext: { _ in
            expectation.fulfill()
        }).disposed(by: disposeBag)

        viewModel.getHistoricalList()
        wait(for: [expectation], timeout: 5.0)
    }
    func testFetchWithOutParseManager() {
        viewModel.parseManager = nil
        let expectation = XCTestExpectation(description: "ViewModel should not be able to fetch without parse manager")

        // expected to not be able to fetch currencies
        viewModel.showErrorMessage.asObservable().subscribe(onNext: { _ in
            expectation.fulfill()
        }).disposed(by: disposeBag)

        viewModel.getHistoricalList()
        wait(for: [expectation], timeout: 5.0)
    }

    func testFetchWithNoService() {

        let expectation = XCTestExpectation(description: "No service currency")

        // expected to not be able to fetch currencies
        viewModel.showErrorMessage.asObservable().subscribe(onNext: { _ in
            expectation.fulfill()
        }).disposed(by: disposeBag)

        viewModel.getHistoricalList()
        wait(for: [expectation], timeout: 5.0)
    }

    func testSectionCountDataSource() {
        XCTAssertEqual(viewModel.getSectionCountDataSource().count, 3, "Expected 3 section in table view")
    }

    func testHistoricalData() {

        let expectation = XCTestExpectation(description: "Currency List Fetch")

        // giving a service mocking History
        let dict = ["USD": 0.997044,
                    "PLN": 4.729242,
                    "GBP": 0.876137,
                    "CAD": 1.332599 ]
        let data = Data(dict.description.utf8)
        service.data = data
        self.service.getCurrenciesData(uri: .historyUri) { (_, error) in
            if let err = error {
                XCTAssert(false, err)
            } else {
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
