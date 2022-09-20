//
//  NavigationRouter.swift
//  CurrencyApplication
//
//  Created by Manish Pathak on 20/09/22.
//  Copyright © 2022 Manish Pathak. All rights reserved.
//

import Foundation
import UIKit

class NavigationRouter {
    
    static func openCurrencyViewController() -> UIViewController? {
        let networkManager = NetworkManager()
        let currencyDataSource = CurrencyDataSource()
        let parseManager = ParseManager()
        if let viewModel = CurrencyViewModel(networkManager: networkManager,
                                             dataSource: currencyDataSource,
                                             parseManager: parseManager) {
            
            let currencyViewController : CurrencyViewController = UIStoryboard.main.getViewController()
            currencyViewController.configure(viewModel: viewModel)
            return currencyViewController
        }
        return nil
    }
    
    static func openCurrencyPickerViewController(fromViewController : UIViewController, viewModel : CurrencyPickerViewModel){
        let pickerViewController : CurrencyPickerViewController = UIStoryboard.main.getViewController()
        pickerViewController.configure(viewModel: viewModel)
        pickerViewController.delegate = fromViewController as? CurrencyPickerViewControllerProtocol
        fromViewController.present(pickerViewController, animated: true, completion: nil)
    }
}
