//
//  NotenappApp.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021 Lucas Zischka. All rights reserved.
//

import SwiftUI

@main
struct NotenappApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            EmptyView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
