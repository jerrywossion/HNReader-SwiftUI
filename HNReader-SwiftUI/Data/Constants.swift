//
//  Constants.swift
//  HNReader-SwiftUI
//
//  Created by Jie Weng on 2020/12/14.
//  Copyright © 2020 Jie Weng. All rights reserved.
//

import Foundation
import SwiftUI

extension Notification.Name {
    static let reloadPage = Notification.Name("reloadPage")
}

enum UserInfoKey: String {
    case urlToReload
}

enum SFSymbol: String {
    case arrowBackward = "arrow.backward"
    case arrowClockwise = "arrow.clockwise"
    case arrowForward = "arrow.forward"
    case newspaper = "newspaper"
    case safari = "safari"
    case sidebarLeft = "sidebar.left"
}

extension Image {
    init(sfSymbol: SFSymbol) {
        self.init(systemName: sfSymbol.rawValue)
    }
}
