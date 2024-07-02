//
//  ToDoFormView.swift
//  toDoCombine
//
//  Created by Davit Natenadze on 21.06.24.
//

import SwiftUI

struct ToDoFormView: View {
    @EnvironmentObject var dataStore: DataStore
    @ObservedObject var viewModel: ToDoViewModel
    @Environment(\.dismiss) var dismiss
    
    enum FocusField {
        case todo
    }
    
    @FocusState private var focusedField: FocusField?
    
    
    var body: some View {
        NavigationStack {
            Form {
                VStack {
                    TextField("ToDo", text: $viewModel.name)
                        .focused($focusedField, equals: .todo)
                    
                    Toggle("isCompleted", isOn: $viewModel.completed)
                }
            }
            .task { focusedField = .todo }
            .navigationTitle("ToDo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    cancelButton
                }  
                
                ToolbarItem(placement: .topBarTrailing) {
                    updateSaveButton
                }
                
//                ToolbarItemGroup(placement: .keyboard) {
//                    HStack {
//                        Button("Done") { focusedField = nil }
//                            .frame(maxWidth: .infinity, alignment: .trailing)
//                    }
//                 
//                }
            }
            .onTapGesture {
                focusedField = nil
            }
        }
    }
}

// MARK: - Extension
extension ToDoFormView {
    
    func updateToDo() {
        let todo = ToDo(id: viewModel.id!, name: viewModel.name, completed: viewModel.completed)
        dataStore.updateToDo.send(todo)
        dismiss()
    }
    
    func addToDo() {
        let todo = ToDo(name: viewModel.name, completed: viewModel.completed)
        dataStore.addToDo.send(todo)
        dismiss()
    }
    
    var cancelButton: some View {
        Button("Cancel") {
            dismiss()
        }
    }
    
    var updateSaveButton: some View {
        Button(viewModel.updating ? "Update" : "Save") {
            viewModel.updating ? updateToDo() : addToDo()
        }
        .disabled(viewModel.isDisabled)
    }
}


#Preview {
    ToDoFormView(viewModel: ToDoViewModel())
        .environmentObject(DataStore())
}
