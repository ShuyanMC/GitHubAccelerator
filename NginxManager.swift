//
//  NginxManager.swift
//  GitHubAccelerator
//
//  Created by 老登 on 2025/2/23.
//

// NginxManager.swift
import Foundation

class NginxController {
    static let shared = NginxController()
    
    private var process: Process?
    
    func installIfNeeded() {
        let arch = SystemInfo.architecture
        let os = SystemInfo.osVersion
        let url = "https://nginx.org/download/nginx-\(getLatestVersion())_\(os)_\(arch).tar.gz"
        
        execute(command: """
        curl -LO \(url) && \
        tar xzf nginx-*.tar.gz && \
        rm nginx-*.tar.gz && \
        sudo mv nginx-* /usr/local/nginx_accelerator
        """)
    }
    
    func startServer(port: Int) {
        let config = """
        events {}
        http {
            server {
                listen \(port);
                location / {
                    proxy_pass https://2git.xyz;
                    proxy_ssl_server_name on;
                }
            }
        }
        """
        
        do {
            try config.write(toFile: "/tmp/nginx_accelerator.conf", atomically: true, encoding: .utf8)
            execute(command: "sudo /usr/local/nginx_accelerator/sbin/nginx -c /tmp/nginx_accelerator.conf")
        } catch {
            print("配置写入失败: \(error)")
        }
    }
    
    private func getLatestVersion() -> String {
        // 实现版本检测逻辑
        return "1.25.3"
    }
    
    private func execute(command: String) {
        let task = Process()
        task.launchPath = "/bin/zsh"
        task.arguments = ["-c", command]
        try? task.run()
    }
}

struct SystemInfo {
    static var architecture: String {
        var size = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: size)
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        return String(cString: machine)
    }
    
    static var osVersion: String {
        let version = ProcessInfo.processInfo.operatingSystemVersion
        return "macos\(version.majorVersion)_\(version.minorVersion)"
    }
}
