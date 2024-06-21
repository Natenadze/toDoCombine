//
//  DataStore.swift
//  toDoCombine
//
//  Created by Davit Natenadze on 21.06.24.
//

import Foundation

final class DataStore: ObservableObject {
    @Published var toDos: [ToDo] = []
    
    init() {
        loadToDos()
    }
    
    func addTodo(_ toDo: ToDo) {
        toDos.append(toDo)
    }
    
    func updateToDo(_ toDo: ToDo) {
        guard let index = toDos.firstIndex(where: { $0.id == toDo.id }) else { return }
        toDos[index] = toDo
    }
    
    func deleteToDo(at indexSet: IndexSet) {
        toDos.remove(atOffsets: indexSet)
    }
    
    func loadToDos() {
        toDos = ToDo.sampleData
    }
    
    func saveToDos() {
        //TODO: - save
    }
}
