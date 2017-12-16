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

    var readableType: String {
        switch self {
        case .login: return "Logins"
        case .creditCard: return "Credit cards"
        case .note: return "Secure notes"
        }
    }

    var fields: [String] {
        switch self {
        case .login: return [LoginData.FieldNames.siteName.rawValue, LoginData.FieldNames.login.rawValue, LoginData.FieldNames.password.rawValue]
        case .creditCard: return [CreditCardData.FieldNames.cardHolderName.rawValue, CreditCardData.FieldNames.vendor.rawValue, CreditCardData.FieldNames.number.rawValue, CreditCardData.FieldNames.expiryDate.rawValue, CreditCardData.FieldNames.pin.rawValue]
        case .note: return [SecureNoteData.FieldNames.noteName.rawValue, SecureNoteData.FieldNames.note.rawValue]
        }
    }

}

protocol StoredData: Codable {

    var fields: [(String, String)] { get }
    var showingTitle: String { get }
    var sensitiveFields: [String] { get }

    func encode() -> Data

    func saveDataItem() -> SavedDataItem
    mutating func set(value: String, for field: String)

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

    func encode() -> Data {
        return try! JSONEncoder().encode(self)
    }

    func saveDataItem() -> SavedDataItem {
        var item: SavedDataItem!
        CoreDataStack.shared.privateMOC.performAndWait {
            let entity = NSEntityDescription.insertNewObject(forEntityName: "SavedDataItem", into: CoreDataStack.shared.privateMOC) as! SavedDataItem
            entity.content = try! JSONEncoder().encode(self) as NSData
            entity.type = StoredDataType.login.rawValue
            entity.id = UUID()
            entity.order = 0
            try! CoreDataStack.shared.privateMOC.save()
            item = entity
        }
        return item
    }

    mutating func set(value: String, for field: String) {
        guard let field = FieldNames(rawValue: field) else { return }
        switch field {
        case .login: self.login = value
        case .password: self.password = value
        case .siteName: self.siteName = value
        }
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

    func encode() -> Data {
        return try! JSONEncoder().encode(self)
    }

    func saveDataItem() -> SavedDataItem {
        var item: SavedDataItem!
        CoreDataStack.shared.privateMOC.performAndWait {
            let entity = NSEntityDescription.insertNewObject(forEntityName: "SavedDataItem", into: CoreDataStack.shared.privateMOC) as! SavedDataItem
            entity.content = try! JSONEncoder().encode(self) as NSData
            entity.type = StoredDataType.creditCard.rawValue
            entity.id = UUID()
            entity.order = 0
            try? CoreDataStack.shared.privateMOC.save()
            item = entity
        }
        return item
    }

    mutating func set(value: String, for field: String) {
        guard let field = FieldNames(rawValue: field) else { return }
        switch field {
        case .cardHolderName: self.cardHolderName = value
        case .vendor: self.vendor = value
        case .number: self.number = value
        case .expiryDate: self.expiryDate = value
        case .pin: self.pin = value
        }
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

    func encode() -> Data {
        return try! JSONEncoder().encode(self)
    }
    
    func saveDataItem() -> SavedDataItem {
        var item: SavedDataItem!
        CoreDataStack.shared.privateMOC.performAndWait {
            let entity = NSEntityDescription.insertNewObject(forEntityName: "SavedDataItem", into: CoreDataStack.shared.privateMOC) as! SavedDataItem
            entity.content = try! JSONEncoder().encode(self) as NSData
            entity.type = StoredDataType.note.rawValue
            entity.id = UUID()
            entity.order = 0
            try? CoreDataStack.shared.privateMOC.save()
            item = entity
        }
        return item
    }

    mutating func set(value: String, for field: String) {
        guard let field = FieldNames(rawValue: field) else { return }
        switch field {
        case .note: self.note = value
        case .noteName: self.noteName = value
        }
    }
}
