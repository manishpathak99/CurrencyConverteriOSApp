//
//  NetworkErrors.swift
//  CurrencyApplication
//
//  Created by Manish Pathak on 20/09/22.
//  Copyright © 2022 Manish Pathak. All rights reserved.
//

enum NetworkResponse: String {
    case success
    case badRequest = "Bad request"
    case failed = "Network request failed."
    case outdated = "The url you requested is outdated."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
    case noresource = "The requested resource does not exist."
    case authenticationError = "You need to be authenticated first."
    case noApiKey = "No API Key was specified or an invalid API Key was specified."
}
