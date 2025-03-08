//
//  GitHubAcceleratorApp.swift
//  GitHubAccelerator
//
//  Created by 老登 on 2025/2/22.
//

import SwiftUI

@main
struct GitHubAcceleratorApp: App {
    @StateObject private var appState = AppState()
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .frame(minWidth: 800, minHeight: 500)
        }
        .windowStyle(.hiddenTitleBar)
    }
}
