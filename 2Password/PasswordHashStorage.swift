//
//  PasswordHashStorage.swift
//  2Password
//
//  Created by Ilya Velilyaev on 12/12/2017.
//  Copyright © 2017 Ilya Velilyaev. All rights reserved.
//

import Foundation
import KeychainItemWrapper

final class PasswordHashStorage {

    private let keychainItem: KeychainItemWrapper = {
        let item = KeychainItemWrapper(identifier: "PasswordHashStorage", accessGroup: nil)!
        item.setObject("PasswordHashStorage", forKey: kSecAttrService)
        return item
    }()

    var passwordHash: String? {
        get {
            if let key = keychainItem.object(forKey: kSecAttrAccount) as? String, !key.isEmpty {
                return key
            }
            return nil
        }
        set {
            if let value = newValue {
                keychainItem.setObject(value, forKey: kSecAttrAccount)
            } else {
                keychainItem.resetKeychainItem()
            }
        }
    }

}
