//
//  Notes+CoreDataProperties.swift
//  Create Note App - Core Data
//
//  Created by Buğra Özuğurlu on 29.09.2022.
//
//

import Foundation
import CoreData


extension Notes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notes> {
        return NSFetchRequest<Notes>(entityName: "Notes")
    }

    @NSManaged public var name: String?
    @NSManaged public var date: Date?

}

extension Notes : Identifiable {

}
