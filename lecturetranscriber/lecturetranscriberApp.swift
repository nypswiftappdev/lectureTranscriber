//
//  lecturetranscriberApp.swift
//  lecturetranscriber
//
//  Created by Shadow33 on 15/1/26.
//

//OK... the template has been set up (hopefully) correctly.
import SwiftUI
import SwiftData

@main
struct lecturetranscriberApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Name.self,
            Lecture.self,
            Course.self
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
