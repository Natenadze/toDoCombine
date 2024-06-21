//
//  todo.swift
//  toDoCombine
//
//  Created by Davit Natenadze on 21.06.24.
//

import Foundation

struct ToDo: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var completed: Bool = false
    
    static var sampleData: [ToDo] {
        [
            ToDo(name: "Get smth"),
            ToDo(name: "make an appointment", completed: true)
        ]
    }
}
