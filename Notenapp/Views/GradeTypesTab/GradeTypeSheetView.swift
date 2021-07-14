//
//  GradeTypeSheetView.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021 Lucas Zischka. All rights reserved.
//

import SwiftUI
import Combine

struct GradeTypeSheetView: View {
    
    //Sheet
    @Environment(\.presentationMode) var presentationMode
    
    //CoreData
    @Environment(\.managedObjectContext) private var viewContext
    
    //Input
    @State private var name: String = ""
    @State private var weight: String = ""
    
    //Validation
    private let generator: UINotificationFeedbackGenerator = UINotificationFeedbackGenerator()
    private var isValid: Bool {
        return name != "" && Double(self.weight) != nil
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("Name", text: self.$name)
                        .disableAutocorrection(true)
                }
                
                Section(header: Text("Weight")) {
                    TextField("Weight", text: self.$weight)
                        .keyboardType(.numberPad)
                        .disableAutocorrection(true)
                        .onReceive(Just(self.weight)) { newValue in
                            let filtered = newValue.filter { "0123456789.".contains($0) }
                            if filtered != newValue {
                                self.weight = filtered
                                
                                self.generator.notificationOccurred(.warning)
                            }
                        }
                }
            }
            .navigationTitle("Add Grade Type")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(self.isValid ? .green : .gray)
                        .onTapGesture(perform: self.saveGradeType)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.red)
                        .onTapGesture {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                }
            }
        }
    }
    
    
    //Save Grade Type
    private func saveGradeType() -> Void {
        withAnimation {
            if self.isValid, let weight = Double(self.weight) {
                let gradeType = GradeType(context: self.viewContext)
                gradeType.id = UUID()
                gradeType.name = self.name
                gradeType.weight = weight
                
                do {
                    try self.viewContext.save()
                    print("[GradeTypeSheetView - CoreData] saveGradeType: Success")
                    
                    self.generator.notificationOccurred(.success)
                    self.presentationMode.wrappedValue.dismiss()
                } catch {
                    print("[GradeTypeSheetView - CoreData] saveGradeType: \(error.localizedDescription)")
                    
                    self.generator.notificationOccurred(.error)
                }
            } else {
                print("[GradeTypeSheetView - CoreData] saveGradeType: Invalid data")
            }
        }
    }
}

struct GradeTypeSheetView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
            .sheet(isPresented: .constant(true), content: {
                GradeTypeSheetView()
                    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            })
    }
}
