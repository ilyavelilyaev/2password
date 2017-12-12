//
//  MainRouter.swift
//  2Password
//
//  Created by Ilya Velilyaev on 05.12.17.
//  Copyright © 2017 Ilya Velilyaev. All rights reserved.
//

import UIKit

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

    }

    private func beginRegisterRouting() {
        let registerRouter = RegisterRouter(completion: { [unowned self] in
            self.beginMainScreenRouting()
        })
        registerRouter.beginRegistrationRouting()
    }

    private func beginMainScreenRouting() {
        AppDelegate.shared.window?.rootViewController = UIViewController()
    }
    
}
