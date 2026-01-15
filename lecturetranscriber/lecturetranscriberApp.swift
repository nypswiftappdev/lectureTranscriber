//
//  lecturetranscriberApp.swift
//  lecturetranscriber
//
//  Created by Shadow33 on 15/1/26.
//

// GIVEN AS A TEMPLATE... WILL NEED TO edit this file AFTERWARDS...
import SwiftUI
import SwiftData

@main
struct lecturetranscriberApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
