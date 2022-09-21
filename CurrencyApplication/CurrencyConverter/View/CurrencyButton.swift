//
//  CurrencyButton.swift
//  CurrencyApplication
//
//  Created by Manish Pathak on 20/09/22.
//  Copyright © 2022 Manish Pathak. All rights reserved.
//

import UIKit

@IBDesignable class CurrencyButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    override func prepareForInterfaceBuilder() {
        setupUI()
    }

    func setupUI() {
        updateCorners(cornerRadius)
        updateBorderColor(borderColor)
        updateBorder(borderWidth)
    }

    func updateBorderColor(_ borderColor: UIColor) {
        layer.borderColor = borderColor.cgColor
    }

    func updateCorners(_ value: CGFloat) {
        layer.cornerRadius = value
    }

    func updateBorder(_ borderWidth: CGFloat) {
        layer.borderWidth = borderWidth
    }

    @IBInspectable var cornerRadius: CGFloat = 15 {
        didSet {
            updateCorners(cornerRadius)
        }
    }

    @IBInspectable var borderWidth: CGFloat = 2 {
        didSet {
            updateBorder(borderWidth)
        }
    }

    @IBInspectable var borderColor: UIColor = UIColor.blue {
        didSet {
            updateBorderColor(borderColor)
        }
    }
}
