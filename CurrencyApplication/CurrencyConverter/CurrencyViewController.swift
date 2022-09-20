//
//  CurrencyViewController.swift
//  CurrencyApplication
//
//  Created by Manish Pathak on 20/09/22.
//  Copyright © 2022 Manish Pathak. All rights reserved.
//

import UIKit

class CurrencyViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var fromCurrencyButton: CurrencyButton!
    @IBOutlet private weak var toCurrencyButton: CurrencyButton!
    @IBOutlet private weak var currencyTextfield: UITextField!
    @IBOutlet private weak var convertedTextField: UITextField! {
        didSet{
            convertedTextField.isUserInteractionEnabled = false
        }
    }
    fileprivate let loader = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    // MARK: - IBOutlet Action
    @IBAction func btnFromCurrencyClicked(_ sender: Any) {
        fromCurrencyClicked()
    }
    
    @IBAction func btnToCurrencyClicked(_ sender: Any) {
        toCurrencyClicked()
    }
}

extension CurrencyViewController {
    
    // MARK: - Fileprivate Functions
    fileprivate func fromCurrencyClicked() {
        
    }
    
    fileprivate func toCurrencyClicked() {
        
    }
}
