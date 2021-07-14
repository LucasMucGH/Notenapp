//
//  NotenappApp.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021 Lucas Zischka. All rights reserved.
//

import SwiftUI

@main
struct NotenappApp: App {
    #if DEBUG
    let persistenceController = PersistenceController.preview
    #else
    let persistenceController = PersistenceController.shared
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    #endif
    
    var body: some Scene {
        WindowGroup {
            TabSelectionView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
    init() {
        #if !DEBUG
        if self.isFirstLaunch {
            let gradeTypes: [(UUID, String, Double)] = [(UUID(), "Mündlich", 1), (UUID(), "Schulaufgabe", 2)]
            for index in 0..<gradeTypes.count {
                let gradeType = GradeType(context: self.persistenceController.container.viewContext)
                gradeType.id = gradeTypes[index].0
                gradeType.name = gradeTypes[index].1
                gradeType.weight = gradeTypes[index].2
            }
            
            do {
                try self.persistenceController.container.viewContext.save()
                
                self.isFirstLaunch = false
            } catch {
                print("[NotenappApp - CoreData] init: \(error.localizedDescription)")
            }
        }
        #endif
    }
}
