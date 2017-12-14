//
//  Models.swift
//  2Password
//
//  Created by Ilya Velilyaev on 14/12/2017.
//  Copyright © 2017 Ilya Velilyaev. All rights reserved.
//

import Foundation

enum StoredDataType: String {

    case login = "LOGIN"
    case creditCard = "CREDIT_CARD"
    case note = "SECURE_NOTE"

}

protocol StoredData: Codable {

    var fields: [(String, String)] { get }
    var showingTitle: String { get }
    var sensitiveFields: [String] { get }

}

struct LoginData: StoredData {

    enum FieldNames: String {
        case login = "Login"
        case password = "Password"
        case siteName = "Site Name"
    }

    var login: String
    var password: String
    var siteName: String

    var showingTitle: String {
        return siteName
    }

    var fields: [(String, String)] {
        return [(FieldNames.siteName.rawValue, siteName),
                (FieldNames.login.rawValue, login),
                (FieldNames.password.rawValue, password)]
    }

    var sensitiveFields: [String] {
        return [FieldNames.password.rawValue]
    }

}

struct CreditCardData: StoredData {

    enum FieldNames: String {
        case cardHolderName = "Cardholder name"
        case vendor = "Vendor"
        case number = "Card Number"
        case expiryDate = "Expiry Date"
        case pin = "PIN"
    }

    var cardHolderName: String
    var vendor: String
    var number: String
    var expiryDate: String
    var pin: String

    var showingTitle: String {
        guard number.count > 4 else { return vendor }
        return vendor + " *" + number.dropFirst(number.count - 4)
    }

    var fields: [(String, String)] {
        return [(FieldNames.cardHolderName.rawValue, cardHolderName),
                (FieldNames.vendor.rawValue, vendor),
                (FieldNames.number.rawValue, number),
                (FieldNames.expiryDate.rawValue, expiryDate),
                (FieldNames.pin.rawValue, pin)]
    }

    var sensitiveFields: [String] {
        return [FieldNames.pin.rawValue]
    }

}

struct SecureNoteData: StoredData {

    enum FieldNames: String {
        case noteName = "Note name"
        case note = "Note"
    }

    var noteName: String
    var note: String

    var showingTitle: String {
        return noteName
    }

    var fields: [(String, String)] {
        return [(FieldNames.noteName.rawValue, noteName),
                (FieldNames.note.rawValue, note)]
    }

    var sensitiveFields: [String] {
        return []
    }

}
