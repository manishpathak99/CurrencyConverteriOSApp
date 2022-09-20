//
//  UIViewController.swift
//  CurrencyApplication
//
//  Created by Manish Pathak on 20/09/22.
//  Copyright © 2022 Manish Pathak. All rights reserved.
//

import UIKit

extension UIViewController {
    static var storyboardID: String {
        return className
    }
    
    func showAlert(title : String, message : String){
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Ok",
                                         style: .destructive) {(_: UIAlertAction) in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
