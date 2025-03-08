import Foundation
import CryptoKit

struct SecureStorage {
    static func save(password: String) -> Bool {
        let key = SymmetricKey(size: .bits256)
        guard let data = password.data(using: .utf8) else { return false }
        let sealedBox = try! AES.GCM.seal(data, using: key)
        UserDefaults.standard.set(sealedBox.combined, forKey: "encryptedPassword")
        return true
    }
    
    static func loadPassword() -> String? {
        guard let combined = UserDefaults.standard.data(forKey: "encryptedPassword"),
              let sealedBox = try? AES.GCM.SealedBox(combined: combined),
              let decrypted = try? AES.GCM.open(sealedBox, using: SymmetricKey(size: .bits256)) else {
            return nil
        }
        return String(data: decrypted, encoding: .utf8)
    }
}
