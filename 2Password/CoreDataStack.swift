//
//  CoreDataStack.swift
//  2Password
//
//  Created by Ilya Velilyaev on 12/12/2017.
//  Copyright © 2017 Ilya Velilyaev. All rights reserved.
//

import Foundation
import CoreData
import EncryptedCoreData

class CoreDataStack {

    static var shared: CoreDataStack!

    private(set) var privateMOC: NSManagedObjectContext
    private var model: NSManagedObjectModel
    private var coordinator: NSPersistentStoreCoordinator

    static func instantiate(password: String) {
        shared = CoreDataStack(password: password)
    }

    static func lock() {
        shared = nil
    }

    private let persistentStoreURL: URL = {
        let modelName = "2Password"
        let documentURLs = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory,
                                                    in: FileManager.SearchPathDomainMask.userDomainMask)
        let persistentStoreURL = documentURLs.first?.appendingPathComponent("\(modelName).sqlite", isDirectory: false)
        return persistentStoreURL!
    }()

    init(password: String) {
        let modelName = "2Password"
        let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")!
        model = NSManagedObjectModel(contentsOf: modelURL)!

        coordinator = EncryptedStore.make(model, passcode: password)!

        privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)

        privateMOC.performAndWait {
            self.privateMOC.persistentStoreCoordinator = coordinator
        }

    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    static func flushDatabase() {
        let entities = CoreDataStack.shared.model.entities
        let moc = CoreDataStack.shared.privateMOC
        moc.performAndWait({
            for entity in entities {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
                request.includesPendingChanges = false
                request.includesSubentities = false
                do {
                    let objects = try moc.fetch(request)
                    for object in objects {
                        guard let object = object as? NSManagedObject else {
                            fatalError()
                        }
                        moc.delete(object)
                    }
                } catch {
                    NSLog("Error flushing DB > \(error)")
                }
            }
            do {
                try moc.save()
            } catch {
                NSLog("Error flushing DB > \(error)")
            }
            moc.reset()
        })
    }

    func changeDBPasskey(old: String, new: String) -> Bool {
        guard let encStore = coordinator.persistentStore(for: persistentStoreURL) as? EncryptedStore else {
            return false
        }
        do {
            try encStore.checkAndChangeDatabasePassphrase(old, toNewPassphrase: new)
            return true
        } catch {
            return false
        }
    }
}

