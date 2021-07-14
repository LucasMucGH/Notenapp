//
//  StudentSheetView.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021 Lucas Zischka. All rights reserved.
//

import SwiftUI

struct StudentSheetView: View {
    
    //Sheet
    @Environment(\.presentationMode) private var presentationMode
    
    //CoreData
    @Environment(\.managedObjectContext) private var viewContext
    
    //Input
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var class_: String = ""
    
    //Valdiation
    private let generator: UINotificationFeedbackGenerator = UINotificationFeedbackGenerator()
    private var isValid: Bool {
        return self.firstName != "" && self.lastName != "" && self.class_ != ""
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("First name")) {
                    TextField("First name", text: self.$firstName)
                        .disableAutocorrection(true)
                }
                Section(header: Text("Last name")) {
                    TextField("Last name", text: self.$lastName)
                        .disableAutocorrection(true)
                }
                Section(header: Text("Class")) {
                    TextField("Class", text: self.$class_)
                        .disableAutocorrection(true)
                }
            }
            .navigationTitle("Add Student")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(self.isValid ? .green : .gray)
                        .onTapGesture(perform: self.saveStudent)
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
    
    
    //Save Student
    private func saveStudent() -> Void {
        withAnimation {
            if self.isValid {
                let student = Student(context: self.viewContext)
                
                student.id = UUID()
                student.firstName = self.firstName
                student.lastName = self.lastName
                student.class_ = self.class_
                
                do {
                    try self.viewContext.save()
                    
                    self.generator.notificationOccurred(.success)
                    self.presentationMode.wrappedValue.dismiss()
                } catch {
                    print("[StudentSheetView - CoreData] saveStudent: \(error.localizedDescription)")
                    
                    self.generator.notificationOccurred(.error)
                }
            } else {
                print("[StudentSheetView - CoreData] saveStudent: Invalid data")
            }
        }
    }
}

struct StudentSheetView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
            .sheet(isPresented: .constant(true), content: {
                StudentSheetView()
                    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            })
    }
}
