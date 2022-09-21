//
//  UITextField.swift
//  CurrencyApplication
//
//  Created by Manish Pathak on 21/09/22.
//  Copyright © 2022 Manish Pathak. All rights reserved.
//

import UIKit

extension UITextField {
    func setBorder(color: UIColor) {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = color.cgColor
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
