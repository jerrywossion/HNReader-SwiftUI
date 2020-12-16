//
//  main.swift
//  HNReader-SwiftUI
//
//  Created by Jie Weng on 2020/12/16.
//  Copyright © 2020 Jie Weng. All rights reserved.
//

import AppKit

let delegate = HNAppDelegate()
NSApplication.shared.delegate = delegate
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
