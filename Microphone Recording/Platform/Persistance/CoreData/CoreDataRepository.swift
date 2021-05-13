//
//  CoreDataRepository.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.05.2021.
//

import CoreData

final class CoreDataRepository<Entity: NSManagedObject>: Repository {
    
    enum CoreDataError: Swift.Error {
        case failedEntityCreation
        case managedObjectContextHasNoChanges
    }
    
    /// Manipulating and tracking of changes to NSManagedObject
    private let managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func fetch(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Result<[Entity], Error> {
        let fetchRequets = Entity.fetchRequest()
        fetchRequets.predicate = predicate
        fetchRequets.sortDescriptors = sortDescriptors
        return Result(catching: {
            guard let fetchResults = try managedObjectContext.fetch(fetchRequets) as? [Entity] else { return .empty }
            return fetchResults
        })
    }
    
    func create() -> Result<Entity, Error> {
        guard
            let managedObject = NSEntityDescription.insertNewObject(
                forEntityName: String(describing: Entity.self),
                into: managedObjectContext
            ) as? Entity else { return .failure(CoreDataError.failedEntityCreation) }
        return .success(managedObject)
    }
    
    func delete(entity: Entity) -> Result<Bool, Error> {
        managedObjectContext.delete(entity)
        return .success(true)
    }
    
    func save() -> Result<Bool, Error> {
        guard
            managedObjectContext.hasChanges
        else { return .failure(CoreDataError.managedObjectContextHasNoChanges) }
        do {
            try managedObjectContext.save()
            return .success(true)
        } catch {
            managedObjectContext.rollback()
            return .failure(error)
        }
    }
    
}
