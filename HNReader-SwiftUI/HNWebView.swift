//
//  HNWebView.swift
//  HNReader-SwiftUI
//
//  Created by Jie Weng on 2020/12/13.
//  Copyright © 2020 Jie Weng. All rights reserved.
//

import Combine
import Foundation
import SwiftUI
import WebKit

struct HNWebView: NSViewRepresentable {
    let url: URL

    func makeNSView(context: NSViewRepresentableContext<HNWebView>) -> WKWebView {
        let request = URLRequest(url: url)
        let wkWebView = WKWebView()
        wkWebView.load(request)

        return wkWebView
    }

    func updateNSView(_ wkWebView: WKWebView, context: NSViewRepresentableContext<HNWebView>) {
        let request = URLRequest(url: url)
        wkWebView.stopLoading()
        wkWebView.load(request)
    }
}
