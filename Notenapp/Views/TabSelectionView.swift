//
//  TabSelectionView.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021 Lucas Zischka. All rights reserved.
//

import SwiftUI

struct TabSelectionView: View {
    var body: some View {
        TabView {
            StudentsTabView()
                .tabItem {
                    Text("Students")
                    Image(systemName: "person")
                }
            
            GradeTypesTabView()
                .tabItem {
                    Text("Grade Types")
                    Image(systemName: "doc.plaintext")
                }
        }
        .accentColor(.red)
    }
}

struct TabSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        TabSelectionView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
