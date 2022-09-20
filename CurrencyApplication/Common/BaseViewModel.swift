//
//  BaseViewModel.swift
//  CurrencyApplication
//
//  Created by Manish Pathak on 20/09/22.
//  Copyright © 2022 Manish Pathak. All rights reserved.
//

import Foundation
import RxCocoa

protocol BaseViewModel: AnyObject {
    var shouldShowLoader: BehaviorRelay<Bool> { get set }
    var showErrorMessage: BehaviorRelay<String?> { get set }
}
