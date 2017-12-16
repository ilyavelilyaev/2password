//
//  PasswordGenerator.swift
//  2Password
//
//  Created by Ilya Velilyaev on 16/12/2017.
//  Copyright © 2017 Ilya Velilyaev. All rights reserved.
//

import Foundation

final class PasswordGenerator {

    func generatePassword(length: Int) -> String {

        let characters = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")

        let charsCount = UInt32(characters.count)
        return String((0..<length).map({ _ in
            let idx = Int(arc4random_uniform(charsCount))
            return characters[idx]
        }))

    }

}
