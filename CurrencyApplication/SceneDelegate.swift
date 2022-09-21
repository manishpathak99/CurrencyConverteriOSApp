//
//  SceneDelegate.swift
//  CurrencyApplication
//
//  Created by Manish Pathak on 19/09/22.
//  Copyright © 2022 Manish Pathak. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        if let currencyViewController = NavigationRouter.openCurrencyViewController() {
            let navViewController = UINavigationController(rootViewController: currencyViewController)
            window.rootViewController = navViewController
        }
        self.window = window
        window.makeKeyAndVisible()
    }
}
