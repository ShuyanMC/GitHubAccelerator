// ContentView.swift
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var state: AppState
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                // 侧边栏
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(AppState.AccelerationMode.allCases, id: \.self) { mode in
                        Button(action: { withAnimation { state.currentMode = mode } }) {
                            HStack {
                                Image(systemName: iconName(for: mode))
                                Text(mode.rawValue)
                                Spacer()
                                if state.currentMode == mode {
                                    Circle().frame(width: 8)
                                }
                            }
                            .foregroundColor(state.currentMode == mode ? .accentColor : .secondary)
                        }
                        .buttonStyle(.plain)
                    }
                    Spacer()
                    StatusIndicator()
                }
                .padding(20)
                .frame(width: 240)
                .background(VisualEffectView(material: .sidebar, blendingMode: .behindWindow))
                
                // 主内容区
                Group {
                    switch state.currentMode {
                    case .hosts: HostsConfigView()
                    case .nginx: NginxConfigView()
                    case .direct: CleanupView()
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color(.windowBackgroundColor))
            }
            
            // 密码输入层
            if state.storedPassword.isEmpty {
                PasswordInputView()
                    .zIndex(1)
            }
        }
        .frame(minWidth: 800, minHeight: 600)
        .animation(.default, value: state.currentMode)
    }
    
    private func iconName(for mode: AppState.AccelerationMode) -> String {
        switch mode {
        case .hosts: return "network"
        case .nginx: return "server.rack"
        case .direct: return "xmark.circle"
        }
    }
    
    private func StatusIndicator() -> some View {
        VStack {
            HStack {
                Circle()
                    .fill(state.isProcessing ? Color.green : Color.gray)
                    .frame(width: 12)
                Text(state.isProcessing ? "运行中" : "已停止")
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.primary.opacity(0.05))
            )
        }
    }
}
