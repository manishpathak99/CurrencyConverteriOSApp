//
//  UIStoryboard.swift
//  CurrencyApplication
//
//  Created by Manish Pathak on 20/09/22.
//  Copyright © 2022 Manish Pathak. All rights reserved.
//

import UIKit
import Foundation

extension UIStoryboard {
    static let main = UIStoryboard(name: "Main", bundle: nil)
    
    func getViewController<T: UIViewController>() -> T {
        return instantiateViewController(withIdentifier: T.storyboardID) as! T
    }
}
