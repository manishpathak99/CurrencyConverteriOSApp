//
//  CurrencyPickerViewModel.swift
//  CurrencyApplication
//
//  Created by Manish Pathak on 20/09/22.
//  Copyright © 2022 Manish Pathak. All rights reserved.
//

import Foundation
import RxCocoa

final class CurrencyPickerViewModel: BaseViewModel {

    var shouldShowLoader = BehaviorRelay<Bool>(value: false)
    var showErrorMessage = BehaviorRelay<String?>(value: nil)
    var dataSource: CurrencyDataSourceProtocol

    // MARK: View Model initialisation with parameters
    init?(dataSource: CurrencyDataSourceProtocol) {
        self.dataSource = dataSource
    }

    // MARK: Number of section datasource
    func getSectionCountDataSource() -> Int {
        return self.dataSource.getSectionCount()
    }

    // MARK: Number of rows datasource
    func getRowsCountForSection(index: Int) -> Int {
        if let row = self.dataSource.getRowCount() {
            return row
        }
        return 0
    }

    // MARK: Cell Data
    func getCurrenciesValueforRowIndex(index: Int) -> RateModel? {
        if let currencyArray = dataSource.rates {
            return currencyArray[index]
        }
        return nil
    }

    // MARK: Title Value
    var titleLabelValue: String {
        return ""
//        return uiConfig.selectionTitle ?? ""
    }
    // MARK: Today Date
    var todayDate: String {
        let today = Date()
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        return "Rates as per Date \(dataSource.date ?? formatter1.string(from: today))"
    }

}
