// MirrorConfig.swift
import Foundation

struct MirrorConfig: Identifiable {
    let id = UUID()
    let name: String
    let domains: [String: String]
}

let presetMirrors = [
    MirrorConfig(
        name: "2Git镜像",
        domains: [
            "github.com": "51.158.204.132",
            "www.github.com": "51.158.204.132",
            "raw.githubusercontent.com": "51.158.204.132"
        ]
    ),
    MirrorConfig(
        name: "FastGit镜像",
        domains: [
            "github.com": "140.82.60.100",
            "www.github.com": "140.82.60.100",
            "raw.githubusercontent.com": "140.82.60.100"
        ]
    )
]
