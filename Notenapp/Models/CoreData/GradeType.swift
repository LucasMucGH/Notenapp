//
//  GradeType.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021 Lucas Zischka. All rights reserved.
//
//

import Foundation
import CoreData

@objc(GradeType)
public class GradeType: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<GradeType> {
        return NSFetchRequest<GradeType>(entityName: "GradeType")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var weight: Double
}
