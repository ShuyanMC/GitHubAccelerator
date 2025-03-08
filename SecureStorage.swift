//
//  SecureStorage.swift
//  GitHubAccelerator
//
//  Created by 老登 on 2025/2/24.
//

import Foundation
import CryptoKit

struct SecureStorage {
    static func save(password: String) -> Bool {
        do {
            let key = SymmetricKey(size: .bits256)
            let data = Data(password.utf8)
            let sealedBox = try AES.GCM.seal(data, using: key)
            UserDefaults.standard.set(sealedBox.combined, forKey: "encryptedPassword")
            return true
        } catch {
            print("密码保存失败: \(error)")
            return false
        }
    }
    
    static func loadPassword() -> String? {
        guard let combined = UserDefaults.standard.data(forKey: "encryptedPassword"),
              let sealedBox = try? AES.GCM.SealedBox(combined: combined),
              let decryptedData = try? AES.GCM.open(sealedBox, using: SymmetricKey(size: .bits256)) else {
            return nil
        }
        return String(data: decryptedData, encoding: .utf8)
    }
}
