//
//  CurrencyEndpoint.swift
//  CurrencyApplication
//
//  Created by Manish Pathak on 20/09/22.
//  Copyright © 2022 Manish Pathak. All rights reserved.
//

import Foundation

public enum CurrencyApi {
    case getCurrenciessUri
    case historyUri
}

extension CurrencyApi: EndPointType {

    var path: String {
        switch self {
        case .getCurrenciessUri:
            return "latest"
        case .historyUri:
            return CurrencyCache.shared.getSelectDate()
        }
    }

    var baseURLWithParameter: URL {
       return baseURL.append(parameters) ?? baseURL
    }

    var httpMethod: HTTPMethod {
        return .get
    }

    var task: HTTPTask {
        return .request
    }

    var headers: HTTPHeaders? {
        return nil
    }

    var accessKey: String? {
        guard let accessKey = bundleForKey("ACCESS_KEY") else { return "" }
        return accessKey
    }

    var parameters: [URLQueryItem] {
        switch self {
        case .getCurrenciessUri:
            guard let key = accessKey else {
                return []
            }
            return [URLQueryItem(name: "access_key", value: key)]

        case .historyUri:
            guard let key = accessKey else {
                assertionFailure("Missing accessKey")
                return []
            }
            return [URLQueryItem(name: "access_key", value: key), URLQueryItem(name: "symbols", value: CurrencyCache.shared.getQueryParameter())]
        }
    }
}
