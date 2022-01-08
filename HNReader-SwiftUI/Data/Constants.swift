//
//  Constants.swift
//  HNReader-SwiftUI
//
//  Created by Jie Weng on 2020/12/14.
//  Copyright © 2020 Jie Weng. All rights reserved.
//

import AppKit
import SwiftUI

extension NSToolbarItem.Identifier {
    static let homePage = NSToolbarItem.Identifier("homePage")
    static let prevPage = NSToolbarItem.Identifier("prevPage")
    static let nextPage = NSToolbarItem.Identifier("nextPage")
    static let openInBrowser = NSToolbarItem.Identifier("openInBrowser")
}

extension Notification.Name {
    static let homePage = Notification.Name("homePage")
    static let prevPage = Notification.Name("prevPage")
    static let nextPage = Notification.Name("nextPage")
    static let openInBrowser = Notification.Name("openInBrowser")
}

enum UserInfoKey: String {
    case urlToReload
}

enum SFSymbol: String {
    case arrowBackward = "arrow.backward"
    case arrowForward = "arrow.forward"
    case newspaper = "newspaper"
    case safari = "safari"
    case globe = "globe"
    case sidebarLeft = "sidebar.left"
}

extension Image {
    init(sfSymbol: SFSymbol) {
        self.init(systemName: sfSymbol.rawValue)
    }
}

extension NSImage {
    convenience init?(sfSymbol: SFSymbol, accessibilityDescription: String?) {
        self.init(systemSymbolName: sfSymbol.rawValue, accessibilityDescription: accessibilityDescription)
    }
}
