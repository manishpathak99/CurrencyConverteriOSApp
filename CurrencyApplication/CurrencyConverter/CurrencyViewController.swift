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

enum ActionState {
    case fromCurrencyClicked
    case toCurrencyClicked
}

final class CurrencyViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var fromCurrencyButton: CurrencyButton!
    @IBOutlet private weak var toCurrencyButton: CurrencyButton!
    @IBOutlet private weak var asOnDateLabel: UILabel!
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
    fileprivate var clickedState : ActionState = .fromCurrencyClicked
    
    private var numberToConvert = BehaviorRelay<Double>(value: 1.0)
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getCurrencyList()
        setupUI()
        bindActions()
    }
    
    private func setupUI(){
        setupLoaderView()
        currencyTextfield.keyboardType = .decimalPad
        currencyTextfield.setBorder(color: .blue)
        convertedTextField.setBorder(color: .blue)
        dismissKeyboard(currencyTextfield)
    }
    
    private func setupLoaderView() {
        loaderView.center = self.view.center
        self.view.addSubview(loaderView)
    }
    
    func configure(viewModel : CurrencyViewModel){
        self.viewModel = viewModel
    }
    
    // MARK: - IBOutlet Action
    @IBAction func btnFromCurrencyClicked(_ sender: Any) {
        // open the list of currencies for selection
        navigateToCurrencyPicker(clickedState: .fromCurrencyClicked)
    }
    
    @IBAction func btnToCurrencyClicked(_ sender: Any) {
        // open the list of currencies for selection
        navigateToCurrencyPicker(clickedState: .toCurrencyClicked)
    }
    
    @IBAction func swapCurrencyClicked(_ sender: Any) {
        // swap the currency
        self.currencyTextfield.resignFirstResponder()
        self.viewModel.swapCurrency()
        self.updateCurrencies()
    }
    
    @IBAction func detailClicked(_ sender: Any) {
        // Navigate to Currency History
        if let viewModel = HistoryViewModel(networkManager: viewModel.networkManager,
                                            dataSource: viewModel.dataSource,
                                            parseManager: viewModel.parseManager) {
            NavigationRouter.openHistoryViewController(fromviewController: self, viewModel: viewModel)
        }
    }
}

extension CurrencyViewController {
    
    private func bindActions() {
        viewModel.shouldShowLoader.asObservable().subscribe { shouldShow in
            if let shouldShow = shouldShow.element {
                DispatchQueue.main.async {
                    if shouldShow {
                        self.loaderView.startAnimating()
                    } else {
                        self.loaderView.stopAnimating()
                        self.loaderView.hidesWhenStopped = true
                    }
                }
            }
        }.disposed(by: disposeBag)
        
        viewModel.showErrorMessage.asObservable().subscribe(onNext: { message in
            if let errorMessage = message {
                DispatchQueue.main.async {
                    self.showAlert(title: &&"Error!", message: errorMessage )
                }
            }
        }).disposed(by: disposeBag)
        
        viewModel.reloadData.asObservable().subscribe { shouldReload in
            if let shouldReload = shouldReload.element {
                DispatchQueue.main.async {
                    if shouldReload{
                        self.updateLabels()
                    }
                }
            }
        }.disposed(by: disposeBag)
        
        numberToConvert.asObservable().subscribe { [unowned self] value in
            self.setConvertedValue(number: self.numberToConvert.value)
            
        }.disposed(by: disposeBag)
        
        currencyTextfield.rx.controlEvent([.editingDidBegin, .editingChanged, .editingDidEnd])
            .asObservable()
            .subscribe(onNext: { [unowned self] in
                self.numberToConvert.accept(Double(self.currencyTextfield.text ?? "1") ?? 1)
            })
            .disposed(by: disposeBag)
    }
    
    private func setConvertedValue(number: Double){
        if let fromVal = fromCurrencyButton.titleLabel?.text,
            let toVal = toCurrencyButton.titleLabel?.text {
            if  let convertedAmount = viewModel.getConvertedAmountToStr(from: fromVal, to: toVal, numberToConvert: number){
                convertedTextField.text = "\(convertedAmount)"
            }
        }
    }
    
    private func navigateToCurrencyPicker(clickedState: ActionState) {
        self.view.endEditing(true)
        self.clickedState = clickedState
        if let viewModel = CurrencyPickerViewModel(dataSource: viewModel.dataSource){
            NavigationRouter.openCurrencyPickerViewController(fromViewController: self, viewModel: viewModel)
        }
    }

    private func updateLabels() {
        asOnDateLabel.text = viewModel.getLabelData()[0]
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

extension CurrencyViewController : UITextFieldDelegate{ }

extension CurrencyViewController : CurrencyPickerViewControllerProtocol{
    func didSelectCurrencyFromList(rateModel: RateModel) {
        if self.clickedState == .fromCurrencyClicked {
            self.viewModel.rateModelArray.insert(rateModel, at: 0)
        } else {
            self.viewModel.rateModelArray.insert(rateModel, at: 1)
        }
        self.updateCurrencies()
    }
    
    private func updateCurrencies() {
        if !self.viewModel.rateModelArray.isEmpty {
            let fromCurrency = self.viewModel.rateModelArray.first
            self.fromCurrencyButton.setTitle(fromCurrency?.currency, for: .normal)
        }
        if viewModel.isBothCurrencySelected() {
            let toCurrency = self.viewModel.rateModelArray.last
            self.toCurrencyButton.setTitle(toCurrency?.currency, for: .normal)
            if self.currencyTextfield.text?.count ?? 0 < 1 {
                self.currencyTextfield.text = "1"
            }
            self.currencyTextfield.becomeFirstResponder()
        }
    }
}
