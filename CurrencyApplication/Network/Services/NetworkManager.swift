//
//  NetworkManager.swift
//  CurrencyApplication
//
//  Created by Manish Pathak on 20/09/22.
//  Copyright © 2022 Manish Pathak. All rights reserved.
//

import Foundation

public typealias NetworkManagerCompletion = (_ data: Data?, _ error: String?) -> Swift.Void

protocol NetworkManagerProtocol {
    func getCurrenciesData(uri: CurrencyApi, completion: @escaping NetworkManagerCompletion)
}

enum Result<String> {
    case success
    case failure(String)
}

struct NetworkManager: NetworkManagerProtocol {
    let router = Router<CurrencyApi>()
    let dataHandler = DataHandler()

    func getCurrenciesData(uri: CurrencyApi, completion: @escaping NetworkManagerCompletion) {
        router.request(uri) { data, response, error in
            if error != nil {
                completion(nil, error?.localizedDescription)
            }
            self.dataHandler.responseHandling(data, response) { responseData, error in
                if error != nil {
                    completion(nil, NetworkResponse.noData.rawValue)
                } else {
                    completion(responseData, nil)
                }
            }
        }
    }
}
