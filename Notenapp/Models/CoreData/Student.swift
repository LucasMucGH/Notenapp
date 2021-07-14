//
//  Student.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021 Lucas Zischka. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Student)
public class Student: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }
    
    @NSManaged public var firstName: String
    @NSManaged public var lastName: String
    @NSManaged public var class_: String
    @NSManaged public var gradesString: String
    @NSManaged public var id: UUID
    
    public var grades: [Grade] {
        get {
            return (try? JSONDecoder().decode([Grade].self, from: Data(self.gradesString.utf8))) ?? []
        }
        set {
            do {
                let reminderData = try JSONEncoder().encode(newValue)
                if let gradesString = String(data: reminderData, encoding:.utf8) {
                    self.gradesString = gradesString
                } else {
                    print("[Student - CoreData] grades: Could not convert the data to a string")
                    self.gradesString = ""
                }
            } catch {
                print("[Student - CoreData] grades: \(error.localizedDescription)")
                self.gradesString = ""
            }
        }
    }
    
    public var finalGrade: Double? {
        var sum: Double = 0
        var count: Double = 0
        
        self.grades.forEach { grade in
            sum += Double(grade.value) * (grade.gradeType?.weight ?? 1)
            count += 1 * (grade.gradeType?.weight ?? 1)
        }
        
        if sum != 0 && count != 0 {
            return sum / count
        } else {
            return nil
        }
    }
}
