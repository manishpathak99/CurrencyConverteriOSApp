//
//  Utils.swift
//  CurrencyApplication
//
//  Created by Manish Pathak on 20/09/22.
//  Copyright © 2022 Manish Pathak. All rights reserved.
//

import Foundation

func bundleForKey(_ key: String) -> String? {
       return (Bundle.main.infoDictionary?[key] as? String)?
           .replacingOccurrences(of: "\\", with: "")
}

// localization
prefix operator &&

prefix func && (string: String?) -> String {
    guard let string = string else { return "" }
    return NSLocalizedString(string, comment: "")
}

