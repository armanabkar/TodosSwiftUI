//
//  TodosSwiftUIApp.swift
//  TodosSwiftUI
//
//  Created by Arman Abkar on 6/19/21.
//

import SwiftUI

@main
struct TodosSwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
