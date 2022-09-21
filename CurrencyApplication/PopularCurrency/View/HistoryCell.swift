//
//  HistoryCell.swift
//  CurrencyApplication
//
//  Created by Manish Pathak on 21/09/22.
//  Copyright © 2022 Manish Pathak. All rights reserved.
//

import UIKit

protocol HistoryCellProtocol: AnyObject {
    func didSelectDate()
}

class HistoryCell: UITableViewCell {

    @IBOutlet private weak var baseCurrencyLabel: UILabel!
    @IBOutlet private weak var dateTextfield: UITextField!
    private let pickerView = UIPickerView()
    private var pickerDataSource = [String]()

    // MARK: Delegate
    weak var delegate: HistoryCellProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    func configure(baseCurrency: String, dateArray: [String]) {
        dateTextfield.inputView = pickerView
        baseCurrencyLabel.text =  baseCurrency
        if dateTextfield.text?.count ?? 0 < 1 {
            dateTextfield.text = dateArray.first
        }
        pickerDataSource = dateArray
    }

    func setupUI() {
        dateTextfield.setBorder(color: .blue)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(HistoryCell.dateTapped))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.dateTextfield.addGestureRecognizer(tapGesture)
        self.dateTextfield.delegate = self
    }

    @objc func dateTapped() {
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.white
        pickerView.dataSource = self
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.gray
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(HistoryCell.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.dateTextfield.inputAccessoryView = toolBar
        self.dateTextfield.inputView = pickerView
        self.dateTextfield.reloadInputViews()
        self.dateTextfield.becomeFirstResponder()
    }

    @objc func doneClick() {
        self.endEditing(true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
extension HistoryCell: UITextFieldDelegate {}

extension HistoryCell: UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: UIPickerView Delegation

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dateTextfield.text = pickerDataSource[row]
        CurrencyCache.shared.setDateSelected(date: pickerDataSource[row])
        delegate?.didSelectDate()
    }
}
