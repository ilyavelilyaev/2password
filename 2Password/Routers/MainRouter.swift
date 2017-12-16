//
//  MainRouter.swift
//  2Password
//
//  Created by Ilya Velilyaev on 05.12.17.
//  Copyright © 2017 Ilya Velilyaev. All rights reserved.
//

import UIKit
import LocalAuthentication

class MainRouter {

    static let shared = MainRouter()

    func beginRouting() {

        if Defaults.shared.registered {
            beginUnlockRouting()
        } else {
            beginRegisterRouting()
        }

    }

    private func beginUnlockRouting() {
        let unlockVC = UnlockViewController.instantiate { [weak self] in
            guard let sself = self else { return }
            LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock") { success, error in
                DispatchQueue.main.async { if success {
                    sself.beginMainScreenRouting()
                    }
                }
            }
        }
        let nvc = UINavigationController(rootViewController: unlockVC)
        AppDelegate.shared.window?.rootViewController = nvc
    }

    private func beginRegisterRouting() {
        let registerRouter = RegisterRouter(completion: { [unowned self] in
            self.beginMainScreenRouting()
        })
        registerRouter.beginRegistrationRouting()
    }

    private func beginMainScreenRouting() {
        let mainSB = UIStoryboard(name: "Main", bundle: .main)
        let tabbarController = mainSB.instantiateInitialViewController()
        AppDelegate.shared.window?.rootViewController = tabbarController
    }
    
}
