//
//  AutoConfigurationView.swift
//  GitHubAccelerator
//
//  Created by 老登 on 2025/2/22.
//

// AutoConfigurationView.swift
import SwiftUI

struct AutoConfigurationView: View {
    @EnvironmentObject var state: AppState
    
    var body: some View {
        VStack {
            Picker("选择镜像源", selection: $state.hostsConfig.currentMirrorIndex) {
                ForEach(0..<state.hostsConfig.mirrors.count, id: \.self) { index in
                    Text(state.hostsConfig.mirrors[index].name).tag(index)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            Text("当前镜像服务器：\(state.hostsConfig.mirrors[state.hostsConfig.currentMirrorIndex].name)")
                .font(.caption)
        }
    }
}
