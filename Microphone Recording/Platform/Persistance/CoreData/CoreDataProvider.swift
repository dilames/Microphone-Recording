//
//  CoreDataProvider.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.05.2021.
//

import CoreData

final class CoreDataProvider {
    
    private struct Constants {
        static let persistentContainerName: String = "Microphone_Recording"
    }
    
    private var persistentContainer: NSPersistentContainer
    
    init() {
        self.persistentContainer = NSPersistentContainer(name: Constants.persistentContainerName)
        self.persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func backgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
}
