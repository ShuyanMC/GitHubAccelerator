//
//  BrowserManager.swift
//  GitHubAccelerator
//
//  Created by 老登 on 2025/2/22.
//
// BrowserManager.swift
import Foundation

class BrowserManager {
    static let shared = BrowserManager()
    
    enum BrowserType: String, CaseIterable {
        case safari = "Safari"
        case chrome = "Google Chrome"
        case firefox = "Firefox"
        case edge = "Microsoft Edge"
    }
    
    func disableBrowserSecurity() {
        execute(command: """
        defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool false
        defaults write com.google.Chrome SafeBrowsingEnabled -bool false
        """)
    }
    
    private func execute(command: String) {
        let task = Process()
        task.launchPath = "/bin/zsh"
        task.arguments = ["-c", command]
        try? task.run()
    }
}
