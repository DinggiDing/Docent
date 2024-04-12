//
//  TodoViewModel.swift
//  Docent_swift
//
//  Created by 성재 on 2022/09/07.
//

import SwiftUI
import RealmSwift

class TodoViewModel: ObservableObject {
    
    private var realm: Realm?
    @Published var tasks: [Todo] = []
    @Published var filteredTasks: [Todo] = []
    
    init() {
        openRealm()
        getAllTasks()
    }
    
    private func openRealm() {
        do {
            let config = Realm.Configuration(schemaVersion: 2)
                        
            Realm.Configuration.defaultConfiguration = config
             realm = try Realm()
        } catch {
            print("Error openning Realm: \(error.localizedDescription)")
        }
    }
    
    func getAllTasks() {
        if let realm = realm {
            let allTasks = realm.objects(Task.self).sorted(by)
            tasks = []
            allTasks.forEach { task in
                tasks.append(task)
            }
        }
    }
}
