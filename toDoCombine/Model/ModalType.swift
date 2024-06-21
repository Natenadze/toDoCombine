//
//  ModalType.swift
//  toDoCombine
//
//  Created by Davit Natenadze on 21.06.24.
//

import SwiftUI

enum ModalType: Identifiable, View {
    case new
    case update(ToDo)
    
    var id: String {
        switch self {
        case .new:
            return "new"
        case .update(_):
            return "update"
        }
    }
    
    var body: some View {
        switch self {
        case .new:
            ToDoFormView(viewModel: ToDoViewModel())
        case .update(let toDo):
            ToDoFormView(viewModel: ToDoViewModel(toDo))
        }
    }
}

