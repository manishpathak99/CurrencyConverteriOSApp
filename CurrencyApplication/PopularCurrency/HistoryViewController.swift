//
//  HistoryViewController.swift
//  CurrencyApplication
//
//  Created by Manish Pathak on 21/09/22.
//  Copyright © 2022 Manish Pathak. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class HistoryViewController: UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var historyTableView: UITableView! {
        didSet {
            self.historyTableView.delegate = self
            self.historyTableView.dataSource = self
            self.historyTableView.registerNib(CurrencyCell.self)
            self.historyTableView.registerNib(HistoryCell.self)
        }
    }

    fileprivate let loaderView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)

    // MARK: View Model
    fileprivate var viewModel: HistoryViewModel!
    fileprivate var disposeBag = DisposeBag()
    fileprivate var numberToConvert = BehaviorRelay<Double>(value: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        titleLabel.text = "Historical Data"
        bindActions()
    }

    func setupUI() {
        setupLoaderView()
        if let firstDate = viewModel.getDateArray().first {
            CurrencyCache.shared.setDateSelected(date: firstDate)
            viewModel.getHistoricalList()
        }
    }

    private func setupLoaderView() {
        loaderView.center = self.view.center
        self.view.addSubview(loaderView)
    }

    func bindActions() {

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

        viewModel.reloadData.asObservable().subscribe { shouldReload in
            if let shouldReload = shouldReload.element {
                DispatchQueue.main.async {
                    if shouldReload {
                        self.historyTableView.reloadData()
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
    }
    func configureViewModel(viewModel: HistoryViewModel) {
        self.viewModel = viewModel
    }
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.getSectionCountDataSource().count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getRowsCountForSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.sections[indexPath.section] {
        case .headerSection:
            if let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.className) as? HistoryCell {
                cell.configure(baseCurrency: viewModel.getDefaultCurrencyFromUserDefaults(),
                               dateArray: viewModel.getDateArray())
                cell.delegate = self
                cell.selectionStyle = .none
                return cell
            }
            return UITableViewCell()
        case .currencies:
            if let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyCell.className) as? CurrencyCell {
                if let model = viewModel.getCurrenciesValueforRowIndex(index: indexPath.row) {
                    cell.configure(model)
                }
                cell.selectionStyle = .none
                return cell
            }
            return UITableViewCell()

        case .addCurrency:
            let cell = UITableViewCell()
            cell.textLabel?.text = "Add More Currency"
            cell.textLabel?.textAlignment = .center
            cell.selectionStyle = .none
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.sections[indexPath.section] {
        case .addCurrency:
            if let viewModel = CurrencyPickerViewModel(dataSource: viewModel.dataSource) {
                NavigationRouter.openCurrencyPickerViewController(fromViewController: self, viewModel: viewModel)
            }
        case _:
            return
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModel.sections[indexPath.section] {
        case .headerSection:
            return 100
        case .addCurrency:
            return 70
        case _:
            return 50
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch viewModel.sections[indexPath.section] {
        case .currencies:
            return true
        case _:
            return false
        }
    }
}
extension HistoryViewController: CurrencyPickerViewControllerProtocol {
    func didSelectCurrencyFromList(rateModel: RateModel) {
        CurrencyCache.shared.setCurrenciesToUserDefaults(currency: rateModel.currency)
        viewModel.getHistoricalList()
    }
}
extension HistoryViewController: HistoryCellProtocol {
    func didSelectDate() {
        viewModel.getHistoricalList()
    }
}
