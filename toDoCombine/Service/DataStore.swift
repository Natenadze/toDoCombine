//
//  DataStore.swift
//  toDoCombine
//
//  Created by Davit Natenadze on 21.06.24.
//

import Foundation

final class DataStore: ObservableObject {
    @Published var toDos: [ToDo] = []
    @Published var appError: ErrorType? = nil
    @Published var isAlertShowing = false
    init() {
        print(FileManager.docDirURL.path(percentEncoded: true))
        if FileManager().docExist(named: fileName) {
            loadToDos()
        }
    }
    
    func addTodo(_ toDo: ToDo) {
        toDos.append(toDo)
        saveToDos()
    }
    
    func updateToDo(_ toDo: ToDo) {
        guard let index = toDos.firstIndex(where: { $0.id == toDo.id }) else { return }
        toDos[index] = toDo
        saveToDos()
    }
    
    func deleteToDo(at indexSet: IndexSet) {
        toDos.remove(atOffsets: indexSet)
        saveToDos()
    }
    
    func loadToDos() {
        FileManager().readDocument(docName: fileName) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    toDos = try decoder.decode([ToDo].self, from: data)
                } catch {
                    appError = ErrorType(error: .decodingError)
                    isAlertShowing = true
                }
                
            case .failure(let error):
                appError = ErrorType(error: error)
                isAlertShowing = true
            }
        }
    }
    
    func saveToDos() {
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(toDos)
            let jsonString = String(decoding: data, as: UTF8.self)
            FileManager().saveDocument(contents: jsonString, docName: fileName) { error in
                if let error {
                    appError = ErrorType(error: error)
                    isAlertShowing = true
                }
            }
        } catch {
            appError = ErrorType(error: .encodingError)
            isAlertShowing = true
        }
    }
}
