//
//  SecurityEngine.swift
//  2Password
//
//  Created by Ilya Velilyaev on 12/12/2017.
//  Copyright © 2017 Ilya Velilyaev. All rights reserved.
//

import Foundation

final class SecurityEngine {

    static let shared = SecurityEngine()

    private let hashStorage = PasswordHashStorage()

    func register(with password: String) {
        hashStorage.passwordHash = sha256(string: password)
        CoreDataStack.instantiate(password: password)
    }

    func unlock(password: String) -> Bool {
        let hash = sha256(string: password)
        guard let storageHash = hashStorage.passwordHash, storageHash == hash else {
            return false
        }
        CoreDataStack.instantiate(password: password)
        return true
    }

    func lock() {
        CoreDataStack.shared = nil
    }

    func changePassword(old: String, new: String) -> Bool {
        let oldEnteredHash = sha256(string: old)
        guard let storageHash = hashStorage.passwordHash, storageHash == oldEnteredHash else {
            return false
        }

        let newEnteredHash = sha256(string: new)
        hashStorage.passwordHash = newEnteredHash
        return CoreDataStack.shared.changeDBPasskey(old: old, new: new)
    }

}

private extension SecurityEngine {

    func sha256(string: String) -> String {
        guard let data = string.data(using: .utf8) else { return "" }
        let sha = sha256(data: data).base64EncodedString()
        return sha 
    }

    func sha256(data: Data) -> Data {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0, CC_LONG(data.count), &hash)
        }
        return Data(bytes: hash)
    }

}
