//
//  DatabaseFetcher.swift
//  2Password
//
//  Created by Ilya Velilyaev on 15/12/2017.
//  Copyright © 2017 Ilya Velilyaev. All rights reserved.
//

import Foundation

final class DatabaseFetcher {

    func fetchCatalogueItems() -> [SavedDataItem] {
        let fetchRequest = NSFetchRequest<SavedDataItem>(entityName: "SavedDataItem")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        var result = [SavedDataItem]()
        CoreDataStack.shared.privateMOC.performAndWait {
            do {
                result = try CoreDataStack.shared.privateMOC.fetch(fetchRequest)
            } catch {
                print(error.localizedDescription)
            }
        }
        return result
    }

}
