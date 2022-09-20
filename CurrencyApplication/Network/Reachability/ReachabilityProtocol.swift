//
//  ReachabilityProtocol.swift
//  CurrencyApplication
//
//  Created by Manish Pathak on 20/09/22.
//  Copyright © 2022 Manish Pathak. All rights reserved.
//

import Foundation

protocol ReachabilityProtocol: class {
    func isInternetAvailable() -> Bool
}
