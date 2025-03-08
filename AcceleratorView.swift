//
//  AcceleratorView.swift
//  GitHubAccelerator
//
//  Created by 老登 on 2025/2/22.
//

// AcceleratorView.swift
import SwiftUI

struct AcceleratorView: View {
    @EnvironmentObject var state: AppState
    
    var body: some View {
        VStack(spacing: 30) {
            ModeSelector()
            DynamicConfigPanel()
            ActionButton()
            StatusIndicator()
        }
        .padding(40)
    }
    
    private func ModeSelector() -> some View {
        Picker("选择加速模式", selection: $state.currentMode) {
            ForEach(AppState.AccelerationMode.allCases, id: \.self) { mode in
                Text(mode.rawValue).tag(mode)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    private func DynamicConfigPanel() -> some View {
        Group {
            switch state.currentMode {
            case .hosts:
                AutoConfigurationView()
            case .nginx:
                ManualConfigurationView()
            case .dns:
                DNSConfigView()
            case .direct:
                CleanupView()
            }
        }
        .transition(.slide)
    }
    
    private func ActionButton() -> some View {
        Button(action: toggleAcceleration) {
            Text(state.isProcessing ? "运行中..." : "立即加速")
                .font(.title2)
                .frame(maxWidth: .infinity)
                .padding()
                .background(state.currentMode == .direct ? Color.gray : Color.blue)
                .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func StatusIndicator() -> some View {
        HStack {
            Circle()
                .fill(state.isProcessing ? Color.green : Color.red)
                .frame(width: 12, height: 12)
            Text(state.isProcessing ? "加速运行中 (\(state.currentMode.rawValue))" : "加速未启用")
        }
    }
    
    private func toggleAcceleration() {
        // 加速逻辑实现
    }
}
