//
//  Persistence.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021 Lucas Zischka. All rights reserved.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let gradeTypes: [(UUID, String, Double)] = [(UUID(), "Mündlich", 1), (UUID(), "Schulaufgabe", 2)]
        for index in 0..<gradeTypes.count {
            let gradeType = GradeType(context: viewContext)
            gradeType.id = gradeTypes[index].0
            gradeType.name = gradeTypes[index].1
            gradeType.weight = gradeTypes[index].2
        }
        
        let students: [(String, String, String)] = [("Lucas", "Zischka", "Q11d"), ("Navid", "Geranmayeh", "Q11b"), ("Minh", "Vu", "Q11d"), ("Alex", "Vergara", "Q11d"), ("Max", "Bürger", "Q11c"), ("Sebastian", "Ludwig", "Q11a"), ("Laura", "Fichtel", "Q11b"), ("Hannah", "Geml", "Q11a"), ("Aisling", "Moloney", "Q11c")]
        for index in 0..<students.count {
            let student = Student(context: viewContext)
            student.id = UUID()
            student.firstName = students[index].0
            student.lastName = students[index].1
            student.class_ = students[index].2
            
            var grades: [Grade] = []
            for _ in 0..<Array(0..<10).randomElement()! {
                let grade = Grade(id: UUID(), gradeTypeUUID: gradeTypes.randomElement()!.0, value: Array(1...6).randomElement()!)
                grades.append(grade)
            }
            student.grades = grades
        }
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    let container: NSPersistentCloudKitContainer
    
    init(inMemory: Bool = false) {
        self.container = NSPersistentCloudKitContainer(name: "Notenapp")
        if inMemory {
            self.container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        self.container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                print("[PersistenceController - init()] gradeType: \(error.localizedDescription)")
            }
        })
    }
}
