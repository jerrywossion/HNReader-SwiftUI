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
//    @NSApplicationDelegateAdaptor(HNAppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        Button {
                            NotificationCenter.default.post(name: .homePage, object: nil)
                        } label: {
                            Image(sfSymbol: SFSymbol.newspaper)
                        }
                    }
                    ToolbarItem(placement: .navigation) {
                        Button {
                            NotificationCenter.default.post(name: .prevPage, object: nil)
                        } label: {
                            Image(sfSymbol: SFSymbol.arrowBackward)
                        }
                    }
                    ToolbarItem(placement: .navigation) {
                        Button {
                            NotificationCenter.default.post(name: .nextPage, object: nil)
                        } label: {
                            Image(sfSymbol: SFSymbol.arrowForward)
                        }
                    }
                    ToolbarItem {
                        Spacer()
                    }
                    ToolbarItem(placement: .automatic) {
                        Button {
                            NotificationCenter.default.post(name: .openInBrowser, object: nil)
                        } label: {
                            Image(sfSymbol: SFSymbol.globe)
                        }
                    }
                }
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
