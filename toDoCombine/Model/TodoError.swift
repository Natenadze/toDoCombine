//
//  TodoError.swift
//  toDoCombine
//
//  Created by Davit Natenadze on 23.06.24.
//

import SwiftUI

enum TodoError: Error, LocalizedError {
    case saveError
    case readError
    case decodingError
    case encodingError
    
    var errorDescription: String? {
        switch self {
        case .saveError:
            return NSLocalizedString("Could not save todo, please reinstall the app", comment: "")
        case .readError:
            return NSLocalizedString("Could not load todos, please reinstall the app", comment: "")
        case .decodingError:
            return NSLocalizedString("There was a problem loading your todos, please create a new todo to start over", comment: "")
        case .encodingError:
            return NSLocalizedString("Could not save todo, please reinstall the app", comment: "")
        }
    }
}

struct ErrorType: LocalizedError {
    let error: TodoError
    
    var errorDescription: String? {
        return error.errorDescription
    }
}
