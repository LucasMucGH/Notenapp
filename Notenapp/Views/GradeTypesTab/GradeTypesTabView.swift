//
//  GradeTypesTabView.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021 Lucas Zischka. All rights reserved.
//

import SwiftUI

struct GradeTypesTabView: View {
    
    //CoreData
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: GradeType.entity(), sortDescriptors: []) private var gradeTypes: FetchedResults<GradeType>
    
    //View
    @State private var showGradeTypeSheetView: Bool = false
    
    //Validation
    private let generator: UINotificationFeedbackGenerator = UINotificationFeedbackGenerator()
    
    
    var body: some View {
        NavigationView {
            Form {
                ForEach(self.gradeTypes) { gradeType in
                    HStack {
                        Text(gradeType.name)
                            .fixedSize(horizontal: true, vertical: false)
                        Spacer(minLength: 0)
                        Text(String(gradeType.weight))
                            .fixedSize(horizontal: true, vertical: false)
                    }
                }
                .onDelete(perform: self.deleteGradeType)
            }
            .navigationTitle("Grade Types")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.showGradeTypeSheetView = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: self.$showGradeTypeSheetView, content: {
            GradeTypeSheetView()
                .environment(\.managedObjectContext, self.viewContext)
        })
    }
    
    
    //Delete Grade Type
    private func deleteGradeType(offsets: IndexSet) -> Void {
        withAnimation {
            offsets.map { self.gradeTypes[$0] }.forEach(self.viewContext.delete)
            
            do {
                try self.viewContext.save()
                
                self.generator.notificationOccurred(.success)
            } catch {
                print("[GradeTypesTabView - CoreData] deleteGradeType: \(error.localizedDescription)")
                
                self.generator.notificationOccurred(.error)
            }
        }
    }
}

struct GradeTypesTabView_Previews: PreviewProvider {
    static var previews: some View {
        GradeTypesTabView()
    }
}
