//
//  SavedDataItem+CoreDataProperties.swift
//  2Password
//
//  Created by Ilya Velilyaev on 14/12/2017.
//  Copyright © 2017 Ilya Velilyaev. All rights reserved.
//
//

import Foundation
import CoreData


extension SavedDataItem {

    @nonobjc class func fetchRequest() -> NSFetchRequest<SavedDataItem> {
        return NSFetchRequest<SavedDataItem>(entityName: "SavedDataItem")
    }

    @NSManaged var content: NSData
    @NSManaged var id: UUID
    @NSManaged var order: Int32
    @NSManaged var type: String

}

extension SavedDataItem {

    var dataType: StoredDataType {
        get {
            return StoredDataType(rawValue: type)!
        }
        set {
            type = newValue.rawValue
        }
    }

    var typedContent: StoredData {
        get {
            switch dataType {
            case .creditCard:
                return try! JSONDecoder().decode(CreditCardData.self, from: content as Data)
            case .login:
                return try! JSONDecoder().decode(LoginData.self, from: content as Data)
            case .note:
                return try! JSONDecoder().decode(SecureNoteData.self, from: content as Data)
            }
        }
        set {
            switch dataType {
            case .creditCard:
                content = try! JSONEncoder().encode(newValue as! CreditCardData) as NSData
            case .login:
                content = try! JSONEncoder().encode(newValue as! LoginData) as NSData
            case .note:
                content = try! JSONEncoder().encode(newValue as! SecureNoteData) as NSData
            }
        }
    }

}
