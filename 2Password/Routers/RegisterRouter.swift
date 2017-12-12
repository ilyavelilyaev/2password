//
//  RegisterRouter.swift
//  2Password
//
//  Created by Ilya Velilyaev on 06/12/2017.
//  Copyright © 2017 Ilya Velilyaev. All rights reserved.
//

import UIKit

final class RegisterRouter {

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
            print("password \(password)")
        }
        navigationController.pushViewController(createPasswordVC, animated: true)
    }

}
