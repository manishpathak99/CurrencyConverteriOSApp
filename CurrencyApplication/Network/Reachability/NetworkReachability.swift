//
//  NetworkReachability.swift
//  CurrencyApplication
//
//  Created by Manish Pathak on 20/09/22.
//  Copyright © 2022 Manish Pathak. All rights reserved.
//

class NetworkReachability {

    private static var instance = NetworkReachability()
    public static func shared() -> NetworkReachability {
        return NetworkReachability.instance
    }
    private init() {}
}

extension NetworkReachability: ReachabilityProtocol {

    func isInternetAvailable() -> Bool {
        return Reachability.isConnectedToNetwork()
    }
}
