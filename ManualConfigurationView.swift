//
//  ManualConfigurationView.swift
//  GitHubAccelerator
//
//  Created by 老登 on 2025/2/22.
//

// ManualConfigurationView.swift
import SwiftUI

struct ManualConfigurationView: View {
    @EnvironmentObject var state: AppState
    
    var body: some View {
        VStack(spacing: 15) {
            ForEach(Array(state.hostsConfig.mirrors[state.hostsConfig.currentMirrorIndex].domains.keys), id: \.self) { domain in
                HStack {
                    Text(domain)
                        .frame(width: 180, alignment: .leading)
                    TextField("IP地址", text: Binding(
                        get: { state.hostsConfig.mirrors[state.hostsConfig.currentMirrorIndex].domains[domain]! },
                        set: { state.hostsConfig.mirrors[state.hostsConfig.currentMirrorIndex].domains[domain] = $0 }
                    ))
                }
            }
        }
    }
}
