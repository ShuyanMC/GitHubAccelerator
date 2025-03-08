import Foundation
import Combine
import CryptoKit

class AppState: ObservableObject {
    enum AccelerationMode: String, CaseIterable {
        case hosts = "Hosts修改"
        case nginx = "反向代理"
        case direct = "关闭加速"
    }
    
    // MARK: - Hosts配置
    struct HostsConfig {
        var currentMirrorIndex = 0
        var mirrors = presetMirrors
    }
    
    // MARK: - Nginx配置
    struct NginxConfig {
        var installedVersion: String?
        var isRunning = false
        var port = 8080
        var progress: Double = 0.0
        var progressText: String = "未启动"
        var configFilePath: String {
            NSHomeDirectory() + "/.gh_accelerator/nginx.conf"
        }
        var installPath: String {
            NSHomeDirectory() + "/.gh_accelerator/nginx"
        }
    }
    
    // MARK: - 高级配置
    struct AdvancedConfig {
        var disableHSTS = false
        var autoCleanDNS = true
    }
    
    // MARK: - 发布状态
    @Published var currentMode: AccelerationMode = .direct
    @Published var isProcessing = false
    @Published var storedPassword = ""
    @Published var hostsConfig = HostsConfig()
    @Published var nginxConfig = NginxConfig()
    @Published var advancedSettings = AdvancedConfig()
    @Published var isAccelerating = false  // 加速状态指示
    
    // MARK: - 初始化
    init() {
        loadPassword()
        checkNginxInstallation()
    }
    
    // MARK: - 密码管理
    private func loadPassword() {
        guard let password = SecureStorage.loadPassword() else { return }
        storedPassword = password
    }
    
    func savePassword(_ password: String) -> Bool {
        SecureStorage.save(password: password)
    }
    
    // MARK: - Hosts模式控制
    func applyHostsChanges(completion: @escaping (Bool) -> Void) {
        let mirror = hostsConfig.mirrors[hostsConfig.currentMirrorIndex]
        var command = "echo '\(storedPassword)' | sudo -S sed -i '' '/github.com/d' /etc/hosts\n"
        
        mirror.domains.forEach { domain, ip in
            command += "echo '\(ip)\t\(domain)' | sudo tee -a /etc/hosts\n"
        }
        
        executeCommand(command) { success in
            DispatchQueue.main.async {
                self.isAccelerating = success
                completion(success)
            }
        }
    }
    
    // MARK: - Nginx控制（全自动部署）
    func toggleNginx() {
        if nginxConfig.installedVersion == nil {
            downloadAndInstallNginx()
        } else if nginxConfig.isRunning {
            stopNginx()
        } else {
            startNginx()
        }
    }
    
    private func downloadAndInstallNginx() {
        let version = "1.25.3" // 动态版本需根据系统检测实现
        let url = "https://nginx.org/download/nginx-\(version).tar.gz"
        
        updateProgress(text: "正在下载Nginx...", progress: 0.2)
        executeCommand("mkdir -p \(nginxConfig.installPath) && curl -o \(nginxConfig.installPath)/nginx.tar.gz \(url)") { [weak self] success in
            guard success, let self = self else { return }
            
            self.updateProgress(text: "正在解压...", progress: 0.4)
            self.executeCommand("tar -xzf \(self.nginxConfig.installPath)/nginx.tar.gz -C \(self.nginxConfig.installPath)") { success in
                guard success else { return }
                
                self.updateProgress(text: "正在编译...", progress: 0.6)
                self.executeCommand("cd \(self.nginxConfig.installPath)/nginx-\(version) && ./configure --prefix=\(self.nginxConfig.installPath) && make && make install") { success in
                    self.nginxConfig.installedVersion = success ? version : nil
                    self.updateProgress(text: success ? "就绪" : "安装失败", progress: 1.0)
                    if success { self.startNginx() }
                }
            }
        }
    }
    
    private func startNginx() {
        generateNginxConfig()
        executeCommand("\(nginxConfig.installPath)/sbin/nginx -c \(nginxConfig.configFilePath)") { [weak self] success in
            self?.nginxConfig.isRunning = success
            self?.isAccelerating = success
            self?.updateProgress(text: success ? "运行中" : "启动失败")
        }
    }
    
    private func stopNginx() {
        executeCommand("\(nginxConfig.installPath)/sbin/nginx -s quit") { [weak self] success in
            self?.nginxConfig.isRunning = !success
            self?.isAccelerating = false
        }
    }
    
    private func generateNginxConfig() {
        let config = """
        server {
            listen \(nginxConfig.port);
            server_name localhost;
            location / {
                proxy_pass https://2git.xyz;
                proxy_set_header Host github.com;
                proxy_ssl_server_name on;
            }
        }
        """
        try? config.write(toFile: nginxConfig.configFilePath, atomically: true, encoding: .utf8)
    }
    
    // MARK: - 实用工具
    func executeCommand(_ command: String, completion: @escaping (Bool) -> Void) {
        let fullCommand = "echo '\(storedPassword)' | sudo -S \(command)"
        let task = Process()
        task.launchPath = "/bin/zsh"
        task.arguments = ["-c", fullCommand]
        
        task.terminationHandler = { _ in
            DispatchQueue.main.async {
                completion(task.terminationStatus == 0)
            }
        }
        
        do {
            try task.run()
        } catch {
            completion(false)
        }
    }
    
    private func checkNginxInstallation() {
        executeCommand("\(nginxConfig.installPath)/sbin/nginx -v") { success in
            self.nginxConfig.installedVersion = success ? "已安装" : nil
        }
    }
    
    private func updateProgress(text: String, progress: Double = 0.0) {
        DispatchQueue.main.async {
            self.nginxConfig.progressText = text
            self.nginxConfig.progress = progress
        }
    }
}
