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
    
    
    var body: some View {
        NavigationStack {
            Form {
                VStack {
                    TextField("ToDo", text: $viewModel.name)
                    Toggle("isCompleted", isOn: $viewModel.completed)
                }
            }
            .navigationTitle("ToDo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    cancelButton
                }  
                
                ToolbarItem(placement: .topBarTrailing) {
                    updateSaveButton
                }
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
