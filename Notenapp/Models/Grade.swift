//
//  Grade.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021 Lucas Zischka. All rights reserved.
//

import Foundation
import CoreData

public struct Grade: Codable, Identifiable {
    public var id: UUID
    public var gradeTypeUUID: UUID
    public var value: Int
    
    public var gradeType: GradeType? {
        do {
            let fetchRequest: NSFetchRequest<GradeType> = GradeType.fetchRequest()
            
            #if DEBUG
            let gradeTypes = try PersistenceController.preview.container.viewContext.fetch(fetchRequest)
            #else
            let gradeTypes = try PersistenceController.shared.container.viewContext.fetch(fetchRequest)
            #endif
            
            if let gradeType = gradeTypes.first(where: { $0.id == self.gradeTypeUUID }) {
                return gradeType
            } else {
                print("[Grade - CoreData] gradeType: Inalid UUID")
                return nil
            }
        } catch {
            print("[Grade - CoreData] gradeType: \(error.localizedDescription)")
            return nil
        }
    }
}
