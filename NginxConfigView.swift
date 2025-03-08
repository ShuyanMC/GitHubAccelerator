//
//  NginxConfigView.swift
//  GitHubAccelerator
//
//  Created by 老登 on 2025/2/23.
//

import SwiftUI

struct NginxConfigView: View {
    @EnvironmentObject var state: AppState
    
    var body: some View {
        VStack(spacing: 20) {
            Text("反向代理配置").font(.title3)
            
            HStack {
                Text("端口号:")
                TextField("", value: $state.nginxConfig.port, formatter: NumberFormatter())
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 80)
            }
            
            ProgressView(value: state.nginxConfig.progress) {
                Text(state.nginxConfig.progressText)
                    .font(.caption)
            }
            
            Button(action: state.toggleNginx) {
                Text(state.nginxConfig.isRunning ? "停止服务" : "启动加速")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(state.nginxConfig.installedVersion == nil)
            .padding(.top)
        }
        .padding()
        .background(VisualEffectView(material: .hudWindow, blendingMode: .behindWindow))
    }
}
