//
// PersistenceController.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import CoreData
import Foundation

final class PersistenceController {
    enum StoreKind {
        case inMemory
        case onDisk(groupIdentifier: String?)
    }

    let container: NSPersistentContainer

    init(name: String = "CompetitionStore", kind: StoreKind = .onDisk(groupIdentifier: nil)) {
        let model = CompetitionManagedObjectModel.makeModel()
        container = NSPersistentContainer(name: name, managedObjectModel: model)

        switch kind {
        case .inMemory:
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
        case .onDisk(let groupIdentifier):
            if let identifier = groupIdentifier,
               let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: identifier)?.appendingPathComponent("\(name).sqlite") {
                let description = NSPersistentStoreDescription(url: url)
                container.persistentStoreDescriptions = [description]
            }
        }

        container.loadPersistentStores { _, error in
            if let error {
                assertionFailure("Failed to load persistent stores: \(error)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
    }
}

