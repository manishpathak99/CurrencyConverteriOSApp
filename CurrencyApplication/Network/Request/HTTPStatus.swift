//
//  HTTPStatus.swift
//  CurrencyApplication
//
//  Created by Manish Pathak on 20/09/22.
//  Copyright © 2022 Manish Pathak. All rights reserved.
//

public enum HTTPStatus: Int {
    case success = 200
    case badRequest = 400
    case forbidden = 403
    case notFound = 404
    case serverError = 500
    case noInternet = -999
}
