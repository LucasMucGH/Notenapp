//
//  StudentView.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021 Lucas Zischka. All rights reserved.
//

import SwiftUI

struct StudentView: View {
    
    //NavigationLink
    public let studentUUID: UUID
    private var student: Student? {
        if let student = self.students.first(where: { $0.id == self.studentUUID }) {
            return student
        } else {
            print("[StudentView - SwiftUI] student: Invalid UUID")
            return nil
        }
    }
    
    //CoreData
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Student.entity(), sortDescriptors: []) private var students: FetchedResults<Student>
    
    //View
    @State private var showGradeSheetView: Bool = false
    
    //Validation
    private let generator: UINotificationFeedbackGenerator = UINotificationFeedbackGenerator()
    
    
    var body: some View {
        if self.student == nil {
            ProgressView()
        } else {
            Form {
                Section(header: Text("\(self.student!.finalGrade != nil ? String(format: "%.02f", self.student!.finalGrade!) : "NaN")Ø").bold().font(.title3)) {
                    List {
                        ForEach(self.student!.grades) { grade in
                            HStack {
                                Text(String(grade.value))
                                    .fixedSize(horizontal: true, vertical: false)
                                Spacer(minLength: 0)
                                Text(grade.gradeType?.name ?? "-")
                                    .fixedSize(horizontal: true, vertical: false)
                                Spacer(minLength: 0)
                                Text(String(grade.gradeType?.weight ?? 1))
                                    .fixedSize(horizontal: true, vertical: false)
                            }
                        }
                        .onDelete(perform: self.deleteGrades)
                    }
                }
            }
            .navigationTitle("\(self.student!.firstName) \(self.student!.lastName) \(self.student!.class_)")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.showGradeSheetView = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
            .sheet(isPresented: self.$showGradeSheetView, content: {
                GradeSheetView(student: self.student!)
                    .environment(\.managedObjectContext, self.viewContext)
            })
        }
    }
    
    
    //Delete Grades
    private func deleteGrades(offsets: IndexSet) -> Void {
        withAnimation {
            self.student?.grades.remove(atOffsets: offsets)
            
            do {
                try self.viewContext.save()
                
                self.generator.notificationOccurred(.success)
            } catch {
                print("[StudentView - CoreData] deleteGrades: \(error.localizedDescription)")
                
                self.generator.notificationOccurred(.error)
            }
        }
    }
}

struct StudentView_Previews: PreviewProvider {
    
    static let viewContext = PersistenceController.preview.container.viewContext
    static var student: Student {
        return try! self.viewContext.fetch(Student.fetchRequest()).first as! Student
    }
    
    static var previews: some View {
        NavigationView {
            StudentView(studentUUID: self.student.id)
                .environment(\.managedObjectContext, self.viewContext)
        }
    }
}
