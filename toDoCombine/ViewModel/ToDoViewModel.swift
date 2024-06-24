//
//  ToDoViewModel.swift
//  toDoCombine
//
//  Created by Davit Natenadze on 21.06.24.
//

import Foundation

final class ToDoViewModel: ObservableObject {
    @Published var name = ""
    @Published var completed = false
    
    var id: String?
    
    var updating: Bool {
        id != nil
    }
    
    var isDisabled: Bool {
        name.isEmpty
    }
    
    init() {}
    
    init(_ currentToDo: ToDo) {
        self.name = currentToDo.name
        self.completed = currentToDo.completed
        id = currentToDo.id
    }
}
