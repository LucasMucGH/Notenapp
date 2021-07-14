//
//  GradeSheetView.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021 Lucas Zischka. All rights reserved.
//

import SwiftUI

struct GradeSheetView: View {
    
    //Sheet
    @Environment(\.presentationMode) var presentationMode
    public let student: Student
    
    //CoreData
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: GradeType.entity(), sortDescriptors: []) private var gradeTypes: FetchedResults<GradeType>
    
    //Input
    @State private var value: Int = 1
    @State private var gradeTypeUUID: UUID? = nil
    
    //Validation
    private let generator: UINotificationFeedbackGenerator = UINotificationFeedbackGenerator()
    private var isValid: Bool {
        return self.gradeTypeUUID != nil
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Value")) {
                    Picker("Value", selection: self.$value) {
                        ForEach(1...6, id: \.self) { value in
                            Text(String(value))
                                .tag(value)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Grade Type")) {
                    Picker("Grade Type", selection: self.$gradeTypeUUID) {
                        Text("Select")
                            .tag(UUID?.none)
                        ForEach(self.gradeTypes) { gradeType in
                            Text(gradeType.name)
                                .tag(gradeType.id as UUID?)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }
            }
            .navigationTitle("Add Grade")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(self.isValid ? .green : .gray)
                        .onTapGesture(perform: self.saveGrade)
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
    
    
    //Save Grade
    private func saveGrade() -> Void {
        withAnimation {
            if self.isValid, let gradeTypeUUID = self.gradeTypeUUID {
                let grade = Grade(id: UUID(), gradeTypeUUID: gradeTypeUUID, value: self.value)
                self.student.grades.append(grade)
                
                do {
                    try self.viewContext.save()
                    
                    self.generator.notificationOccurred(.success)
                    self.presentationMode.wrappedValue.dismiss()
                } catch {
                    print("[GradeSheetView - CoreData] saveGrade: \(error.localizedDescription)")
                    
                    self.generator.notificationOccurred(.error)
                }
            } else {
                print("[GradeSheetView - CoreData] saveGrade: Invalid data")
            }
        }
    }
}

struct GradeSheetView_Previews: PreviewProvider {
    
    static let viewContext = PersistenceController.preview.container.viewContext
    static var student: Student {
        return try! self.viewContext.fetch(Student.fetchRequest()).first as! Student
    }
    
    static var previews: some View {
        EmptyView()
            .sheet(isPresented: .constant(true), content: {
                GradeSheetView(student: self.student)
                    .environment(\.managedObjectContext, self.viewContext)
            })
    }
}
