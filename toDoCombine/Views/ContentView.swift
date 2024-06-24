//
//  ContentView.swift
//  toDoCombine
//
//  Created by Davit Natenadze on 21.06.24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var dataStore: DataStore
    @State private var modalType: ModalType? = nil
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(dataStore.toDos) { item in
                    
                    Button {
                        modalType = .update(item)
                    } label: {
                        Text(item.name)
                            .strikethrough(item.completed)
                            .foregroundStyle(item.completed ? .green : .primary)
                    }
                }
                .onDelete (perform: dataStore.deleteToDo.send)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("My ToDos").font(.title2)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        modalType = .new
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(.blue)
                            .font(.title2)
                    }
                   
                }
            }
            .sheet(item: $modalType) { $0 }
            .alert(isPresented: $dataStore.isAlertShowing, error: dataStore.appError) {
             
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(DataStore())
}
