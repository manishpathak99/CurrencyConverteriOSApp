//
//  HistoryViewModel.swift
//  CurrencyApplication
//
//  Created by Manish Pathak on 21/09/22.
//  Copyright © 2022 Manish Pathak. All rights reserved.
//

import Foundation
import RxCocoa

enum HistoryCounterSection {
    case headerSection
    case currencies
    case addCurrency
}

final class HistoryViewModel: BaseViewModel {
    var shouldShowLoader = BehaviorRelay<Bool>(value: false)
    var showErrorMessage = BehaviorRelay<String?>(value: nil)
    var dataSource: CurrencyDataSourceProtocol
    var historicalDataSource =  CurrencyDataSource()
    var networkManager: NetworkManagerProtocol!
    var parseManager: ParseManagerProtocol!
    var sections: [HistoryCounterSection] = [.headerSection, .currencies, .addCurrency]
    var filteredRates: [RateModel]?
    var reloadData = BehaviorRelay<Bool>(value: false)

    // MARK: View Model initialisation with parameters
    init?(networkManager: NetworkManagerProtocol,
          dataSource: CurrencyDataSourceProtocol,
          parseManager: ParseManagerProtocol) {
        self.networkManager = networkManager
        self.dataSource = dataSource
        self.parseManager = parseManager
        CurrencyCache.shared.setPrimaryCurrencies()
    }

    // MARK: Number of section datasource
    func getSectionCountDataSource() -> [HistoryCounterSection] {
        return sections
    }

    // MARK: Number of rows datasource
    func getRowsCountForSection(section: Int) -> Int {
        switch getSectionCountDataSource()[section] {
        case .headerSection:
            return 1
        case .currencies:
            return CurrencyCache.shared.getPrimaryCurrencies().count
        case .addCurrency:
            return 1
        }
    }
    // MARK: Cell Data
    func getCurrenciesValueforRowIndex(index: Int) -> RateModel? {
        return self.historicalDataSource.rates?[index]
    }

    // MARK: Title Value
    var titleLabelValue: String {
        return ""//uiConfig.historicalTitle ?? ""
    }

    func getHistoricalList() {
        self.fetchCurrencyHistoricalData()
    }

    func getDefaultCurrencyFromUserDefaults() -> String {
        return historicalDataSource.base ?? "EUR"
    }

    func getDateArray() -> [String] {
        return Date.getDates(forLastNDays: 30)
    }
}

extension HistoryViewModel {

    // MARK: Fetching Historical Currency Data
    private func fetchCurrencyHistoricalData() {
        shouldShowLoader.accept(true)
        guard let networkManager = networkManager else {
            self.showErrorMessage.accept("Missing Network Manager")
            return
        }
        networkManager.getCurrenciesData(uri: .historyUri) {[weak self] (responseData, error) in
            self?.shouldShowLoader.accept(false)
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard error == nil else {
                    self.showErrorMessage.accept(error)
                    return
                }
                if let responseData = responseData {
                    self.parseResponsetoDataSource(responseData: responseData)
                }
            }
        }
    }

    private func parseResponsetoDataSource(responseData: Data) {
        guard let parseManager = self.parseManager else {
            self.showErrorMessage.accept("Missing Parse Manager")
            return
        }
        parseManager.parseResponseToDataSource(responseData: responseData) {[weak self] (dataSource, error)  in
            guard let self = self else { return }
            guard error == nil else {
                self.showErrorMessage.accept(error)
                return
            }
            if let dataSourceVal = dataSource as? CurrencyDataSource {
                self.historicalDataSource = dataSourceVal
                self.reloadData.accept(true)
            }
        }
    }
}
