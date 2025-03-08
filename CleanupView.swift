//
//  CleanupView.swift
//  GitHubAccelerator
//
//  Created by 老登 on 2025/2/23.
//

// CleanupView.swift
import SwiftUI

struct CleanupView: View {
    @EnvironmentObject var state: AppState
    
    var body: some View {
        VStack(spacing: 20) {
            Text("关闭加速")
                .font(.headline)
            
            Text("当前已关闭加速模式，所有修改将被还原。")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("清理缓存") {
                cleanupCache()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private func cleanupCache() {
        // 清理缓存的逻辑
        let command = "echo '\(state.storedPassword)' | sudo -S rm -rf /tmp/github_cache"
        execute(command: command)
    }
    
    private func execute(command: String) {
        let task = Process()
        task.launchPath = "/bin/zsh"
        task.arguments = ["-c", command]
        
        do {
            state.isProcessing = true
            try task.run()
            task.waitUntilExit()
            state.isProcessing = false
        } catch {
            print("执行失败: \(error)")
        }
    }
}
