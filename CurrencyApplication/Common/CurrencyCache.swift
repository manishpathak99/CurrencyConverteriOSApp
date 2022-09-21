//
//  CurrencyCache.swift
//  CurrencyApplication
//
//  Created by Manish Pathak on 21/09/22.
//  Copyright © 2022 Manish Pathak. All rights reserved.
//

import Foundation

class CurrencyCache {
    static private(set) var shared = CurrencyCache()
    private init(){}
    private let selectedDateKey = "SelectedDate"
    private let currenciesKey = "Currencies"
    
    func setDateSelected(date : String){
        Utils.setUserDefaultData(date, forKey: selectedDateKey)
    }
    
    func getSelectDate() -> String{
        if let selectedDate = Utils.getUserDefaultsData(forKey: selectedDateKey) as? String{
            return selectedDate
        }
        return ""
    }
    
    func setCurrenciesToUserDefaults(currency: String) {
        var array = [String]()
        if isAlreadyStoredCurrency(for: currency){
            return
        }
        if let saved = Utils.getUserDefaultsData(forKey: currenciesKey) as? [String]{
            array = saved
            array.append(currency)
            Utils.setUserDefaultData(array, forKey: currenciesKey)
        }
    }
    
    func setPrimaryCurrencies(){
        Utils.setUserDefaultData(["USD", "PLN", "GBP", "CAD"], forKey: currenciesKey)
    }
    func getPrimaryCurrencies() -> [String]{
        if let savedCurrencies = Utils.getUserDefaultsData(forKey: currenciesKey) as? [String]{
            return savedCurrencies
        }
        return []
    }
    
    func getQueryParameter() -> String{
        return getPrimaryCurrencies().joined(separator: ",")
    }
    
    func isAlreadyStoredCurrency(for name: String) -> Bool {
        if let defaultCurrency = Utils.getUserDefaultsData(forKey: currenciesKey) as? [String] {
            for value in defaultCurrency {
                if value == name {
                    return true
                }
            }
        }
        return false
    }
}
