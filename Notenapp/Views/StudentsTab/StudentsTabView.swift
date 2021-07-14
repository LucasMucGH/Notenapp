//
//  StudentsTabView.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021 Lucas Zischka. All rights reserved.
//

import SwiftUI

struct StudentsTabView: View {
    
    //CoreData
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Student.entity(), sortDescriptors: []) private var students: FetchedResults<Student>
    
    //View
    @State private var showStudentSheetView: Bool = false
    
    //Sort
    @State private var sortBy: SortBy = .name
    private var sortedStudents: [Student] {
        switch self.sortBy {
        case .name:
            return self.students.sorted(by: {$0.firstName < $1.firstName})
        case .class:
            return self.students.sorted(by: {$0.class_ < $1.class_})
        case .finalGrade:
            return self.students.filter({ $0.finalGrade != nil }).sorted(by: {$0.finalGrade != nil && $0.finalGrade! < $1.finalGrade! })
        }
    }
    
    //Validation
    private let generator: UINotificationFeedbackGenerator = UINotificationFeedbackGenerator()
    
    
    var body: some View {
        NavigationView {
            Form {
                ForEach(self.sortedStudents) { student in
                    NavigationLink(destination: StudentView(studentUUID: student.id), label: {
                        Text("\(student.firstName) \(student.lastName) \(student.class_)")
                            .fixedSize(horizontal: true, vertical: false)
                        Spacer(minLength: 0)
                        Text("\(student.finalGrade != nil ? String(format: "%.02f", student.finalGrade!) : "NaN")Ø")
                            .bold()
                            .fixedSize(horizontal: true, vertical: false)
                    })
                }
                .onDelete(perform: self.deleteStudents)
            }
            .navigationTitle("Students")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Picker("Sort by", selection: self.$sortBy) {
                        ForEach(SortBy.allCases, id: \.self) { `case` in
                            Text(`case`.rawValue)
                                .tag(`case`)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.showStudentSheetView = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: self.$showStudentSheetView, content: {
            StudentSheetView()
                .environment(\.managedObjectContext, self.viewContext)
        })
    }
    
    //Delete Students
    private func deleteStudents(offsets: IndexSet) -> Void {
        withAnimation {
            offsets.map { self.sortedStudents[$0] }.forEach(self.viewContext.delete)
            
            do {
                try self.viewContext.save()
                
                self.generator.notificationOccurred(.success)
            } catch {
                print("[StudentsTabView - CoreData] deleteStudents: \(error.localizedDescription)")
                
                self.generator.notificationOccurred(.error)
            }
        }
    }
}

struct StudentsTabView_Previews: PreviewProvider {
    static var previews: some View {
        StudentsTabView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
