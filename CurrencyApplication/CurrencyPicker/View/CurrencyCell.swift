//
//  CurrencyCell.swift
//  CurrencyApplication
//
//  Created by Manish Pathak on 21/09/22.
//  Copyright © 2022 Manish Pathak. All rights reserved.
//

import UIKit

class CurrencyCell: UITableViewCell {

    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!

    func configure(_ model: RateModel) {
        currencyLabel.text =  model.currency
        rateLabel.text = "\(model.value)"
    }
}
