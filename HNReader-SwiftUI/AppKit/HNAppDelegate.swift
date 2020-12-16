//
//  HNAppDelegate.swift
//  HNReader-SwiftUI
//
//  Created by Jie Weng on 2020/12/16.
//  Copyright © 2020 Jie Weng. All rights reserved.
//

import AppKit
import SwiftUI

class HNAppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    var toolbarProvider: HNToolbarProvider!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let contentView = ContentView()

        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1920, height: 1080),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.isReleasedWhenClosed = false
        window.setFrame(NSRect(origin: .zero, size: CGSize(width: 1920, height: 1080)), display: true)
        window.center()
        window.setFrameAutosaveName("HNReader")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)

        // setup toolbar
        toolbarProvider = HNToolbarProvider()
        window.toolbar = toolbarProvider.toolbar
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}
