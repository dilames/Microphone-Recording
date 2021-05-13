//
//  CoreDataMediaFile+CoreDataProperties.swift
//  
//
//  Created by Andrew Chersky on 13.05.2021.
//
//

import Foundation
import CoreData


extension CoreDataMediaFile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataMediaFile> {
        return NSFetchRequest<CoreDataMediaFile>(entityName: "CoreDataMediaFile")
    }

    @NSManaged public var url: String?
    @NSManaged public var id: UUID?
    @NSManaged public var createdAt: Date?

}
