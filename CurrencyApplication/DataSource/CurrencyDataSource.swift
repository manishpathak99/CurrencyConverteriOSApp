//
//  CurrencyDataSource.swift
//  CurrencyApplication
//
//  Created by Manish Pathak on 20/09/22.
//  Copyright © 2022 Manish Pathak. All rights reserved.
//

import Foundation

protocol CurrencyDataSourceProtocol: AnyObject {
    var base: String? {get set}
    var date: String? {get set}
    var rates: [RateModel]? {get set}
    var selectedRates: [RateModel]? {get set}
    func getSectionCount() -> Int
    func getRowCount() -> Int?
}

final class CurrencyDataSource : CurrencyDataSourceProtocol{
    var base: String?
    var date: String?
    var rates: [RateModel]?
    var selectedRates: [RateModel]?
    
    func getSectionCount() -> Int{
        return 1
    }
    func getRowCount() -> Int?{
        return rates?.count
    }
}
