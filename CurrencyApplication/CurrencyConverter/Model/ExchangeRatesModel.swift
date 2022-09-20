//
//  ExchangeRatesModel.swift
//  CurrencyApplication
//
//  Created by Manish Pathak on 20/09/22.
//  Copyright © 2022 Manish Pathak. All rights reserved.
//

struct ExchangeRatesModel: BaseModel {
    let base: String
    let date: String
    let rates: [String: Double]
}
