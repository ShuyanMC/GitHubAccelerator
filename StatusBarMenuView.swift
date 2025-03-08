//
//  StatusBarMenuView.swift
//  GitHubAccelerator
//
//  Created by 老登 on 2025/2/23.
//
import SwiftUI

struct StatusBarMenuView: View {
    @EnvironmentObject var state: AppState
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "bolt.fill")
                Text("加速状态: \(state.isAccelerating ? "ON" : "OFF")")
            }
            
            Divider()
            
            Button("切换模式") {
                NSApp.sendAction(#selector(NSApplication.terminate), to: nil, from: nil)
            }
            
            Button("打开主界面") {
                NSApp.windows.first?.makeKeyAndOrderFront(nil)
                NSApp.activate(ignoringOtherApps: true)
            }
            
            Divider()
            
            Button("退出") {
                NSApplication.shared.terminate(nil)
            }
        }
        .padding(10)
        .frame(width: 180)
    }
}
