//
//  Defaults.swift
//  2Password
//
//  Created by Ilya Velilyaev on 06/12/2017.
//  Copyright © 2017 Ilya Velilyaev. All rights reserved.
//

import Foundation

class Defaults {

    static let shared = Defaults()

    var registered: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "key.registered")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "key.registered")
        }
    }

}
