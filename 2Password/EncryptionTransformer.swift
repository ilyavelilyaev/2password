//
//  EncryptionTransformer.swift
//  2Password
//
//  Created by Ilya Velilyaev on 12/12/2017.
//  Copyright © 2017 Ilya Velilyaev. All rights reserved.
//

import Foundation
import KeychainItemWrapper

@objc(EncryptionTransformer)
final class EncryptionTransformer: ValueTransformer {

    private let key: String

    init(key: String) {
        self.key = key
        super.init()
    }

    convenience override init() {
        self.init(key: EncryptionTransformer.defaultKey)
    }

    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }

    override class func allowsReverseTransformation() -> Bool {
        return true
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else {
            return value
        }
        return data.aes256Encrypt(withKey: key)
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else {
            return value
        }
        return data.aes256Decrypt(withKey: key)
    }
}

private extension EncryptionTransformer {

    static let keychainItem: KeychainItemWrapper = {
        let item = KeychainItemWrapper(identifier: "EncryptionTransformer", accessGroup: nil)!
        item.setObject("EncryptionTransformer", forKey: kSecAttrService)
        return item
    }()

    static var defaultKey: String {
      if let key = keychainItem.object(forKey: kSecAttrAccount) as? String, !key.isEmpty {
            return key
        } else {
            let key = generatePassphrase()
            keychainItem.setObject(key, forKey: kSecAttrAccount)
            return key
        }
    }

    static func generatePassphrase() -> String {
        let chars = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        let charsCount = UInt32(chars.count)
        return String((0..<32).map({ _ in
            let idx = Int(arc4random_uniform(charsCount))
            return chars[idx]
        }))
    }
}

