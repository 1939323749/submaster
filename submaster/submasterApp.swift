//
//  submasterApp.swift
//  submaster
//
//  Created by mba on 2023/10/20.
//

import SwiftUI
import SwiftData

@main
struct submasterApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Subscribe.self,
            Tag.self,
            Profile.self,
            Setting.self,
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
