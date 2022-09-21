//
//  CurrencyViewModelTests.swift
//  CurrencyApplicationTests
//
//  Created by Manish Pathak on 21/09/22.
//  Copyright © 2022 Manish Pathak. All rights reserved.
//

import XCTest
import RxSwift
@testable import CurrencyApplication

class CurrencyViewModelTests: XCTestCase {
    var viewModel : CurrencyViewModel!
    fileprivate var service : MockCurrencyService!
    fileprivate var tableDataSource: MockTableDataSource!
    fileprivate var parseManger: MockParseManager!
    fileprivate var disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        self.service = MockCurrencyService()
        self.tableDataSource = MockTableDataSource()
        self.parseManger = MockParseManager()
        self.viewModel = CurrencyViewModel(networkManager: self.service, dataSource: tableDataSource, parseManager: parseManger)
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
        XCTAssertNotNil(viewModel, "The currency view model should not be nil.")
        XCTAssertTrue(viewModel?.dataSource === tableDataSource, "The table datasource should be equal to the profile that was passed in.")
    }
    func testFetchWithOutNetworkManager() {
        viewModel.networkManager = nil
        let expectation = XCTestExpectation(description: "ViewModel should not be able to fetch without network manager")
        
        // expected to not be able to fetch currencies
        viewModel.showErrorMessage.asObservable().subscribe(onNext: { _ in
            expectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.getCurrencyList()
        wait(for: [expectation], timeout: 5.0)
    }
    func testFetchWithOutParseManager() {
        viewModel.parseManager = nil
        let expectation = XCTestExpectation(description: "ViewModel should not be able to fetch without parse manager")
        
        // expected to not be able to fetch currencies
        viewModel.showErrorMessage.asObservable().subscribe(onNext: { _ in
            expectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.getCurrencyList()
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchWithNoService() {
        
        let expectation = XCTestExpectation(description: "No service currency")
        
        // expected to not be able to fetch currencies
        viewModel.showErrorMessage.asObservable().subscribe(onNext: { message in
            expectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.getCurrencyList()
        wait(for: [expectation], timeout: 5.0)
    }
    func testFetchCurrencies() {
        
        let expectation = XCTestExpectation(description: "Currency List Fetch")
        
        // giving a service mocking currencies
        
        let dict = ["AED": 3.637754,
                    "AFN": 86.166463,
                    "ALL": 116.439813,]
        let data = Data(dict.description.utf8)
        service.data = data
        self.service.getCurrenciesData(uri: .getCurrenciessUri) { (response , error) in
            if let err = error  {
                XCTAssert(false, err)
            }else{
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
    func testConvertedAmountwithoutValues() {
        let expectation = XCTestExpectation(description: "Conversion Fails")
        if let _ = viewModel.getConvertedAmountToStr(from: "", to: "", numberToConvert: 0){
            XCTAssert(false)
        }else{
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
class MockCurrencyService : NetworkManagerProtocol {
    var data : Data?
    var errorMessage : String?
    func getCurrenciesData(uri: CurrencyApi, completion: @escaping (Data?, String?) -> Void) {
        guard data != nil else {
            completion(nil, errorMessage)
            return
        }
        
        completion(data, nil)
    }
}

class MockTableDataSource : CurrencyDataSourceProtocol{
    var base: String?
    var date: String?
    var rates: [RateModel]?
    var selectedRates: [RateModel]?
    func getSectionCount() -> Int {
        return 0
    }
    func getRowCount() -> Int? {
        return 0
    }
}

class MockParseManager : ParseManagerProtocol{
    func parseResponseToDataSource(responseData: Data, completion: @escaping (CurrencyDataSourceProtocol?, String?) -> Void) {

    }
}
