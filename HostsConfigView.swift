//
//  HostsConfigView.swift
//  GitHubAccelerator
//
//  Created by 老登 on 2025/2/23.
//

import SwiftUI

struct HostsConfigView: View {
    @EnvironmentObject var state: AppState
    
    var body: some View {
        VStack(spacing: 20) {
            Picker("镜像源选择", selection: $state.hostsConfig.currentMirrorIndex) {
                ForEach(0..<state.hostsConfig.mirrors.count, id: \.self) { index in
                    Text(state.hostsConfig.mirrors[index].name).tag(index)
                }
            }
            .pickerStyle(.automatic)
            
            Button("应用加速配置") {
                state.applyHostsChanges { success in
                    if success {
                        state.currentMode = .hosts
                    }
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(VisualEffectView(material: .hudWindow, blendingMode: .behindWindow))
    }
}
