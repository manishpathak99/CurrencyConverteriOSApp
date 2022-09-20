//
//  CurrencyViewController.swift
//  CurrencyApplication
//
//  Created by Manish Pathak on 20/09/22.
//  Copyright © 2022 Manish Pathak. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

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
    fileprivate let loaderView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    // MARK: View Model
    fileprivate var viewModel : CurrencyViewModel!
    fileprivate var disposeBag = DisposeBag()
    
     // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getCurrencyList()
        setupUI()
    }
    
    private func setupLoaderView() {
        loaderView.center = self.view.center
        self.view.addSubview(loaderView)
    }

    private func setupUI(){
        setupLoaderView()
        currencyTextfield.keyboardType = .decimalPad
        dismissKeyboard(currencyTextfield)
    }
    
    func configure(viewModel : CurrencyViewModel){
        self.viewModel = viewModel
    }

    // MARK: - IBOutlet Action
    @IBAction func btnFromCurrencyClicked(_ sender: Any) {
        fromCurrencyClicked()
    }
    
    @IBAction func btnToCurrencyClicked(_ sender: Any) {
        toCurrencyClicked()
    }
    
    @IBAction func swapCurrencyClicked(_ sender: Any) {
        // swap the currency
    }
}

extension CurrencyViewController {
    
    // MARK: - Fileprivate Functions
    fileprivate func fromCurrencyClicked() {
        // open the list of currencies for selection
    }
    
    fileprivate func toCurrencyClicked() {
        // open the list of currencies for selection
    }
}

extension CurrencyViewController {
    
    // MARK: Dismiss Keyboard
    func dismissKeyboard(_ textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    @objc func doneClick() {
        self.view.endEditing(true)
    }
}
