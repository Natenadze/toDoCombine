//
//  DataStore.swift
//  toDoCombine
//
//  Created by Davit Natenadze on 21.06.24.
//

import Foundation
import Combine

final class DataStore: ObservableObject {
    @Published var toDos: [ToDo] = []
    @Published var appError: ErrorType? = nil
    @Published var isAlertShowing = false
    
    var subscriptions = Set<AnyCancellable>()
    
    var addToDo    = PassthroughSubject<ToDo, Never>()
    var updateToDo = PassthroughSubject<ToDo, Never>()
    var deleteToDo = PassthroughSubject<IndexSet, Never>()
    var loadTodos = Just(FileManager.docDirURL.appendingPathComponent(fileName))
    
    
    
    init() {
        print(FileManager.docDirURL.path(percentEncoded: true))
        addSubscriptions()
//        if FileManager().docExist(named: fileName) {
//            loadToDos()
//        }
    }
    
    func addSubscriptions() {
        loadTodos
            .filter { FileManager.default.fileExists(atPath: $0.path(percentEncoded: true)) }
            .tryMap { url in
                try Data(contentsOf: url)
            }
            .decode(type: [ToDo].self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue(label: "background queue"))
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] completion in
                switch completion {
                case .finished:
                    toDosSubscription()
                case .failure(let error):
                    if error is TodoError {
                        appError = ErrorType(error: error as! TodoError)
                    } else {
                        appError = ErrorType(error: TodoError.decodingError)
                        toDosSubscription()
                    }
                }
            } receiveValue: { todos in
                self.toDos = todos
            }
            .store(in: &subscriptions)
        
        

        
        addToDo
            .sink { [unowned self] todo in
            self.toDos.append(todo)
//            self.saveToDos()
        }
        .store(in: &subscriptions)
        
        updateToDo
            .sink { [unowned self] todo in
            guard let index = toDos.firstIndex(where: { $0.id == todo.id }) else { return }
            self.toDos[index] = todo
//            self.saveToDos()
        }
        .store(in: &subscriptions)  
        
        deleteToDo
            .sink { [unowned self] indexSet in
                toDos.remove(atOffsets: indexSet)
//                saveToDos()
        }
        .store(in: &subscriptions)
        
    }
    
    func toDosSubscription() {
        $toDos
            .subscribe(on: DispatchQueue(label: "background queue"))
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .encode(encoder: JSONEncoder())
            .tryMap { data in
                try data.write(to: FileManager.docDirURL.appendingPathComponent(fileName))
            }
            .sink { [unowned self] completion in
                switch completion {
                case .finished:
                    print("save complete")
                case .failure(let error):
                    if error is TodoError {
                        appError = ErrorType(error: error as! TodoError)
                    } else {
                        appError = ErrorType(error: TodoError.encodingError)
                    }
                }
            } receiveValue: { _ in
                print("Saving file was successful")
            }
            .store(in: &subscriptions)
    }
    
//    func addTodo(_ toDo: ToDo) {
//        toDos.append(toDo)
//        saveToDos()
//    }
//    
//    func updateToDo(_ toDo: ToDo) {
//        guard let index = toDos.firstIndex(where: { $0.id == toDo.id }) else { return }
//        toDos[index] = toDo
//        saveToDos()
//    }
//    
//    func deleteToDo(at indexSet: IndexSet) {
//        toDos.remove(atOffsets: indexSet)
//        saveToDos()
//    }
//    
//    func loadToDos() {
//        FileManager().readDocument(docName: fileName) { result in
//            switch result {
//            case .success(let data):
//                let decoder = JSONDecoder()
//                do {
//                    toDos = try decoder.decode([ToDo].self, from: data)
//                } catch {
//                    appError = ErrorType(error: .decodingError)
//                    isAlertShowing = true
//                }
//                
//            case .failure(let error):
//                appError = ErrorType(error: error)
//                isAlertShowing = true
//            }
//        }
//    }
    
    
    // MARK: - Comment out after 33-54
//    func saveToDos() {
//        let encoder = JSONEncoder()
//        
//        do {
//            let data = try encoder.encode(toDos)
//            let jsonString = String(decoding: data, as: UTF8.self)
//            FileManager().saveDocument(contents: jsonString, docName: fileName) { error in
//                if let error {
//                    appError = ErrorType(error: error)
//                    isAlertShowing = true
//                }
//            }
//        } catch {
//            appError = ErrorType(error: .encodingError)
//            isAlertShowing = true
//        }
//    }
}
