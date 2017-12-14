//
//  RegisterRouter.swift
//  2Password
//
//  Created by Ilya Velilyaev on 06/12/2017.
//  Copyright © 2017 Ilya Velilyaev. All rights reserved.
//

import UIKit

final class RegisterRouter {

    private var completion: () -> Void

    init(completion: @escaping () -> Void) {
        self.completion = completion
    }

    private var navigationController: UINavigationController!

    func beginRegistrationRouting() {
        let firstLaunchVC = FirstLaunchViewController.instantiate(completion: {
            self.createPassword()
        })
        let navigationController = UINavigationController(rootViewController: firstLaunchVC)
        AppDelegate.shared.window?.rootViewController = navigationController
        self.navigationController = navigationController
    }

    private func createPassword() {
        let createPasswordVC = CreatePasswordViewController.instantiate { password in
            self.register(password: password)
            self.showThankYou()
        }
        navigationController.pushViewController(createPasswordVC, animated: true)
    }

    private func register(password: String) {
        SecurityEngine.shared.register(with: password)
        Defaults.shared.registered = true
    }
    
    private func showThankYou() {
        let thankYouVC = ThankYouViewController.instantiate()
        navigationController.pushViewController(thankYouVC, animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.completion()
        }
    }

}
