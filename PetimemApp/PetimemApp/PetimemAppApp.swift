//
//  PetimemAppApp.swift
//  PetimemApp
//
//  Created by wei feng on 2024-03-15.
//

import SwiftUI
import SwiftData
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

@main
struct PetimemAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
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
            NavigationStack{
                //          ContentView()
                SplashScreenView()
                //LoginView()
            }
        }
        .modelContainer(sharedModelContainer)
        //.modelContainer(for: [Expense.self])
    }
    
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
