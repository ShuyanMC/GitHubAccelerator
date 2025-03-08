//
//  SettingsView.swift
//  GitHubAccelerator
//
//  Created by 老登 on 2025/2/22.
//
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var state: AppState
    @State private var newPassword = ""
    @State private var oldPassword = ""
    
    var body: some View {
        Form {
            Section(header: Text("安全设置")) {
                SecureField("旧密码", text: $oldPassword)
                SecureField("新密码", text: $newPassword)
                Button("更新密码") {
                    if SecureStorage.loadPassword() == oldPassword {
                        state.savePassword(newPassword)
                    }
                }
            }
            
            Section(header: Text("服务状态")) {
                Text("Nginx版本: \(state.nginxConfig.installedVersion ?? "未安装")")
                Text("加速状态: \(state.isAccelerating ? "已启用" : "未激活")")
            }
        }
        .padding()
        .frame(width: 400, height: 250)
        .background(VisualEffectView(material: .sidebar, blendingMode: .behindWindow))
    }
}
