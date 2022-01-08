//
//  HNToolbarProvider.swift
//  HNReader-SwiftUI
//
//  Created by Jie Weng on 2020/12/16.
//  Copyright © 2020 Jie Weng. All rights reserved.
//

import AppKit

class HNToolbarProvider: NSObject, NSToolbarDelegate {
    lazy var toolbar: NSToolbar = {
        let toolbar = NSToolbar()
        toolbar.delegate = self
        toolbar.displayMode = .iconOnly
        return toolbar
    }()

    private let toolbarItemIdentifiers: [NSToolbarItem.Identifier] = [
        .homePage,
        .flexibleSpace,
        .prevPage,
        .nextPage,
        .toggleSidebar,
        .sidebarTrackingSeparator,
        .flexibleSpace,
        .openInBrowser,
    ]

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return toolbarItemIdentifiers
    }

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return toolbarItemIdentifiers
    }

    func toolbar(
        _ toolbar: NSToolbar,
        itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
        willBeInsertedIntoToolbar flag: Bool
    ) -> NSToolbarItem? {
        switch itemIdentifier {
        case .homePage:
            return createToolbarItem(
                itemIdentifier: itemIdentifier,
                action: #selector(onHomePage(_:)),
                label: "HackerNews Homepage",
                imageSymbol: .newspaper
            )
        case .prevPage:
            return createToolbarItem(
                itemIdentifier: itemIdentifier,
                action: #selector(onPrevPage(_:)),
                label: "Previous Page of HackerNews List",
                imageSymbol: .arrowBackward
            )
        case .nextPage:
            return createToolbarItem(
                itemIdentifier: itemIdentifier,
                action: #selector(onNextPage(_:)),
                label: "Next Page of HackerNews List",
                imageSymbol: .arrowForward
            )
        case .openInBrowser:
            return createToolbarItem(
                itemIdentifier: itemIdentifier,
                action: #selector(onOpenInBrowser(_:)),
                label: "Open in browser",
                imageSymbol: .globe
            )
        default:
            break
        }
        return nil
    }

    private func createToolbarItem(
        itemIdentifier: NSToolbarItem.Identifier,
        action: Selector,
        label: String,
        imageSymbol: SFSymbol
    ) -> NSToolbarItem {
        let item = NSToolbarItem(itemIdentifier: itemIdentifier)
        item.target = self
        item.action = action
        let label = label
        item.image = NSImage(sfSymbol: imageSymbol, accessibilityDescription: label)
        return item
    }

    @objc func onHomePage(_ sender: Any?) {
        NotificationCenter.default.post(name: .homePage, object: nil)
    }

    @objc func onPrevPage(_ sender: Any?) {
        NotificationCenter.default.post(name: .prevPage, object: nil)
    }

    @objc func onNextPage(_ sender: Any?) {
        NotificationCenter.default.post(name: .nextPage, object: nil)
    }

    @objc func onOpenInBrowser(_ sender: Any?) {
        NotificationCenter.default.post(name: .openInBrowser, object: nil)
    }
}
