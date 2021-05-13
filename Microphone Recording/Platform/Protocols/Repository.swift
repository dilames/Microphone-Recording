//
//  Repository.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.05.2021.
//

import Foundation

protocol Repository {
    associatedtype Entity
    func fetch(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Result<[Entity], Swift.Error>
    func create() -> Result<Entity, Swift.Error>
    func delete(entity: Entity) -> Result<Bool, Swift.Error>
    func save() -> Result<Bool, Error>
}
