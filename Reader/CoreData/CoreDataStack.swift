//
//  CoreDataStack.swift
//  Reader
//
//  Created by Prasoon Tiwari on 27/10/25.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()

    private init() {
        persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    lazy var persistentContainer: NSPersistentContainer = {
        // Use model named "ReaderModel" (we create model programmatically)
        let container = NSPersistentContainer(name: "ReaderModel")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("CoreData failed to load stores: \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        let ctx = context
        if ctx.hasChanges {
            do {
                try ctx.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }

    // Helper to create entity if model isn't generated: We assume you will create an entity "CDArticle" via code below
}
