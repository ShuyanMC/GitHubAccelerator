// AppDelegate.swift
import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var popover: NSPopover!

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        setupStatusBar()
    }

    private func setupStatusBar() {
        // 创建状态栏图标
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        // 设置闪电图标
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "bolt.fill", accessibilityDescription: "GitHub Accelerator")
            button.action = #selector(togglePopover(_:))
        }

        // 创建 Popover
        popover = NSPopover()
        popover.contentSize = NSSize(width: 300, height: 200) // 设置 Popover 的大小
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: StatusBarMenuView().environmentObject(AppState()))
    }

    @objc private func togglePopover(_ sender: Any?) {
        if let button = statusItem.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }
}
