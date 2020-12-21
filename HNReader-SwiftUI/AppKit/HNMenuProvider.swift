//
//  HNMenuProvider.swift
//  HNReader-SwiftUI
//
//  Created by Jie Weng on 2020/12/21.
//  Copyright © 2020 Jie Weng. All rights reserved.
//

import AppKit

class HNMenuProvider: NSMenu {
    override init(title: String) {
        super.init(title: title)

        let aboutMenu = NSMenuItem()
        aboutMenu.submenu = NSMenu(title: "About")
        aboutMenu.submenu?.items = [
            NSMenuItem(title: "About", action: #selector(about(_:)), keyEquivalent: "a")
        ]

        let editMenu = NSMenuItem()
        editMenu.submenu = NSMenu(title: "Edit")
        editMenu.submenu?.items = [
            NSMenuItem(title: "Copy", action: #selector(copy(_:)), keyEquivalent: "c"),
        ]

        items = [aboutMenu, editMenu]
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }

    @objc func about(_ sender: Any?) {
        print("HNReader-SwiftUI")
    }

    @objc func copy(_ sender: Any?) {

    }
}
