//
//  UITableView.swift
//  CurrencyApplication
//
//  Created by Manish Pathak on 21/09/22.
//  Copyright © 2022 Manish Pathak. All rights reserved.
//

import UIKit

extension UITableView {

    // MARK: Register cell with nib
    func registerNib<T: UITableViewCell>(_: T.Type) {
        let nib = T.nib()
        self.register(nib, forCellReuseIdentifier: T.tableCellReuseIdentifier())
    }
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.tableCellReuseIdentifier(), for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.tableCellReuseIdentifier())")
        }
        return cell
    }
}

extension UIView{
    class func nib() -> UINib {
        return UINib(nibName: className, bundle: nil)
    }
}

extension UITableViewCell {
    class func tableCellReuseIdentifier() -> String {
        return className
    }
}
