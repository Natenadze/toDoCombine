//
//  FileManager+Extension.swift
//  toDoCombine
//
//  Created by Davit Natenadze on 22.06.24.
//

import Foundation

let fileName = "Todos.json"

extension FileManager {
    static var docDirURL: URL {
        return Self.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func saveDocument(contents: String, docName: String, completion: (TodoError?) -> Void) {
        let url = Self.docDirURL.appendingPathComponent(docName)
        
        do {
            try contents.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            completion(.saveError)
        }
    }
    
    func readDocument(docName: String, completion: (Result<Data, TodoError>) -> Void) {
        let url = Self.docDirURL.appendingPathComponent(docName)
        
        do {
            let data = try Data(contentsOf: url)
            completion(.success(data))
        } catch {
            completion(.failure(.readError))
        }
    }
    
    func docExist(named docName: String) -> Bool {
        fileExists(atPath: Self.docDirURL.appendingPathComponent(docName).path(percentEncoded: true))
    }
}
