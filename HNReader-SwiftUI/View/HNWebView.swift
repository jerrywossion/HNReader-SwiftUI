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
    @Binding var progress: Double

    func makeCoordinator() -> HNWebViewCoordinator {
        return HNWebViewCoordinator(self)
    }

    func makeNSView(context: NSViewRepresentableContext<HNWebView>) -> WKWebView {
        let wkWebView = context.coordinator.wkWebView
        let request = URLRequest(url: url)
        wkWebView.stopLoading()
        wkWebView.load(request)
        return wkWebView
    }

    func updateNSView(_ wkWebView: WKWebView, context: NSViewRepresentableContext<HNWebView>) {
        guard url != context.coordinator.url else { return }
        context.coordinator.url = url

        let request = URLRequest(url: url)
        wkWebView.stopLoading()
        wkWebView.load(request)
    }
}

class HNWebViewCoordinator {
    let parent: HNWebView
    var url: URL
    let wkWebView: WKWebView = WKWebView()
    var subscription: AnyCancellable?

    init(_ parent: HNWebView) {
        self.parent = parent
        self.url = parent.url
        subscription = wkWebView.publisher(for: \.estimatedProgress)
            .sink { value in
                DispatchQueue.main.async { [weak self] in
                    self?.parent.progress = value
                }
            }
    }
}
