//
//  EndpointProtocol.swift
//  CurrencyApplication
//
//  Created by Manish Pathak on 20/09/22.
//  Copyright © 2022 Manish Pathak. All rights reserved.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
    var baseURLWithParameter: URL { get }
}

extension EndPointType {
    var baseURL: URL {
        guard let url = URL(string: RequestConfig.baseUrl) else {
            fatalError("BaseUrl cannot be configured")
        }
        return url
    }
    var httpMethod: HTTPMethod {
        return .get
    }
    var headers: HTTPHeaders? {
        return nil
    }
}
