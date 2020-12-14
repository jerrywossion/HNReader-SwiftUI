//
//  HNReader_SwiftUIApp.swift
//  HNReader-SwiftUI
//
//  Created by Jie Weng on 2020/12/13.
//  Copyright © 2020 Jie Weng. All rights reserved.
//

import SwiftUI

@main
struct HNReader_SwiftUIApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowToolbarStyle(UnifiedWindowToolbarStyle(showsTitle: false))
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}
