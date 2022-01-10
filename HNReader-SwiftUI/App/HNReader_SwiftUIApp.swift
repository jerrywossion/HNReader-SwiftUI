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
    @NSApplicationDelegateAdaptor(HNAppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            CommandMenu("Find") {
                Button("Find on page") {
                    NotificationCenter.default.post(name: .findOnPage, object: nil)
                }
                .keyboardShortcut("f")
            }
        }
        .windowToolbarStyle(UnifiedWindowToolbarStyle(showsTitle: false))
    }
}
