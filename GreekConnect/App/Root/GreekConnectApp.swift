//
//  GreekConnectApp.swift
//  GreekConnect
//
//  Created by Hayden Romick on 12/2/24.
//

import SwiftUI
import Firebase // Import Firebase if you are using it

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure() // Initialize Firebase
        return true
    }
}

@main
struct GreekConnectApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

