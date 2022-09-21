//
//  CurrencyViewModel.swift
//  CurrencyApplication
//
//  Created by Manish Pathak on 20/09/22.
//  Copyright © 2022 Manish Pathak. All rights reserved.
//

import Foundation
import RxCocoa

final class CurrencyViewModel: BaseViewModel {
    var networkManager: NetworkManagerProtocol!
    var parseManager: ParseManagerProtocol!
    var shouldShowLoader = BehaviorRelay<Bool>(value: false)
    var showErrorMessage = BehaviorRelay<String?>(value: nil)
    var reloadData = BehaviorRelay<Bool>(value: false)
    var dataSource: CurrencyDataSourceProtocol
    var currencyDict = [AnyHashable: RateModel]()

    // MARK: View Model initialisation with parameters
    init?(networkManager: NetworkManagerProtocol,
          dataSource: CurrencyDataSourceProtocol,
          parseManager: ParseManagerProtocol) {
        self.networkManager = networkManager
        self.dataSource = dataSource
        self.parseManager = parseManager
    }

    func getCurrencyList() {
        self.fetchCurrencies()
    }

    func getLabelData() -> [String] {
         var labels  = [String]()
         labels.append(todayDate)
         labels.append(baseCurrency)
         return labels
     }

    private var todayDate: String {
        let today = Date()
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        return "(Rates as on date \(dataSource.date ?? formatter1.string(from: today)))"
    }

    private var baseCurrency: String {
        return "\(&&"Base_Currency") \(dataSource.base ?? "EUR")"
    }
}

extension CurrencyViewModel {
    // MARK: Fetch currency list
    private func fetchCurrencies() {
        shouldShowLoader.accept(true)
        guard let networkManager = networkManager else {
            self.showErrorMessage.accept("Missing Network Manager")
            return
        }
        networkManager.getCurrenciesData(uri: .getCurrenciessUri) {[weak self] (responseData, error) in
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
            if let dataSourceVal = dataSource {
                self.dataSource = dataSourceVal
                self.reloadData.accept(true)
            }
        }
    }
}

extension CurrencyViewModel {

    // MARK: Get Converted Value from source to target currency
    func getConvertedAmountToStr(from: String, to: String, numberToConvert: Double) -> Double? {
        if let inputToEURRate = getCurrencyDefaultValue(fromCurrency: from), let targetToEURRate = getCurrencyDefaultValue(fromCurrency: to) {
            let total = numberToConvert / inputToEURRate * targetToEURRate
            return total.rounded(toPlaces: 4)
        }
        return nil
    }

    private func getCurrencyDefaultValue(fromCurrency: String) -> Double? {
        if let rates = self.dataSource.rates {
            for rate in rates {
                if rate.currency == fromCurrency {
                    return rate.value
                }
            }
        }
        return nil
    }

    func isBothCurrencySelected() -> Bool {
        if let _ = currencyDict[ActionState.fromCurrencyClicked], let _ = currencyDict[ActionState.toCurrencyClicked] { return true }
        return false
    }

    func swapCurrency() {
        if isBothCurrencySelected() {
            let rate = currencyDict[ActionState.fromCurrencyClicked]
            currencyDict[ActionState.fromCurrencyClicked] = currencyDict[ActionState.toCurrencyClicked]
            currencyDict[ActionState.toCurrencyClicked] = rate
        }
    }
}
