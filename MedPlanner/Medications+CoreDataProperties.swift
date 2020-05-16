//
//  Medications+CoreDataProperties.swift
//  MedPlanner
//
//  Created by Dominik Boboš on 16/05/2020.
//  Copyright © 2020 Dominik Boboš. All rights reserved.
//
//

import Foundation
import CoreData


extension Medications {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Medications> {
        return NSFetchRequest<Medications>(entityName: "Medications")
    }

    @NSManaged public var name: String?
    @NSManaged public var dateBegin: String?
    @NSManaged public var dateEnd: String?
    @NSManaged public var whenTake: String?

}
