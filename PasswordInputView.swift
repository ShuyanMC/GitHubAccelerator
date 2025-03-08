//
//  PasswordInputView.swift
//  GitHubAccelerator
//
//  Created by 老登 on 2025/2/22.
//

// PasswordInputView.swift
import SwiftUI

struct PasswordInputView: View {
    @EnvironmentObject var state: AppState
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 20) {
            SecureField("输入管理员密码", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 200)
            
            HStack(spacing: 15) {
                Button("取消") {
                    NSApplication.shared.terminate(nil)
                }
                
                Button("保存") {
                    savePassword()
                }
                .disabled(password.isEmpty)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.windowBackgroundColor))
        )
    }
    
    private func savePassword() {
        guard SecureStorage.save(password: password) else { return }
        state.storedPassword = password
    }
}
