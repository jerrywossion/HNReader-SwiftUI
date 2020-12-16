//
//  HNWebViewController.swift
//  HNReader-SwiftUI
//
//  Created by Jie Weng on 2020/12/14.
//  Copyright © 2020 Jie Weng. All rights reserved.
//

import Cocoa
import Combine
import SwiftUI
import WebKit

class ProgressBar: NSView {
    var minProgress: Double = 0
    var maxProgress: Double = 1
    var progress: Double = 0 {
        didSet {
            layout()
        }
    }
    var color: NSColor = .systemBlue

    private let indicator = NSView()
    private var indicatorWidthConstraint: NSLayoutConstraint!

    init() {
        super.init(frame: .zero)
        addSubview(indicator)
        indicator.wantsLayer = true
        indicator.layer?.backgroundColor = color.cgColor
        indicator.layer?.cornerRadius = 5

        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            indicator.topAnchor.constraint(equalTo: self.topAnchor),
            indicator.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            indicator.heightAnchor.constraint(equalToConstant: 10),
        ])

        indicatorWidthConstraint = indicator.widthAnchor.constraint(equalToConstant: 0)
        indicatorWidthConstraint.isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder:) not implemented")
    }

    override func layout() {
        super.layout()

        let width = bounds.width * CGFloat(progress)
        indicatorWidthConstraint.constant = width
    }
}

class WebViewController: NSViewController {
    let progressBar = ProgressBar()
    let wkWebView = WKWebView()

    private var subscriptions: Set<AnyCancellable> = []

    override func loadView() {
        view = NSView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        wkWebView.evaluateJavaScript("navigator.userAgent") { [self] (result, error) in
            guard error == nil, let userAgent = result as? String else { return }

            self.wkWebView.customUserAgent = userAgent
        }

        view.addSubview(wkWebView)
        view.addSubview(progressBar)

        wkWebView.translatesAutoresizingMaskIntoConstraints = false
        progressBar.translatesAutoresizingMaskIntoConstraints = false

        let wkWebViewConstraints: [NSLayoutConstraint] = [
            wkWebView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wkWebView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wkWebView.topAnchor.constraint(equalTo: view.topAnchor),
            wkWebView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        let progressBarConstraints: [NSLayoutConstraint] = [
            progressBar.topAnchor.constraint(equalTo: wkWebView.topAnchor),
            progressBar.leadingAnchor.constraint(equalTo: wkWebView.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: wkWebView.trailingAnchor),
        ]

        NSLayoutConstraint.activate(wkWebViewConstraints)
        NSLayoutConstraint.activate(progressBarConstraints)

        wkWebView.publisher(for: \.estimatedProgress)
            .sink { [weak self] value in
                self?.progressBar.progress = value
                if value == 0 {
                    self?.progressBar.isHidden = true
                } else if value == 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self?.progressBar.isHidden = true
                    }
                } else {
                    self?.progressBar.isHidden = false
                }
            }
            .store(in: &subscriptions)

        NotificationCenter.default.publisher(for: .reloadPage)
            .sink { [weak self] notification in
                if let userInfo = notification.userInfo, let url = userInfo[UserInfoKey.urlToReload] as? URL,
                    self?.wkWebView.url == url
                {
                    self?.reload()
                }
            }
            .store(in: &subscriptions)
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
    }

    func load(_ url: URL) {
        wkWebView.load(URLRequest(url: url))
    }

    func reload() {
        wkWebView.reload()
    }
}

struct HNWebViewController: NSViewControllerRepresentable {
    @Binding var url: URL?

    func makeCoordinator() -> HNWebViewCoordinator {
        return HNWebViewCoordinator(url)
    }

    func makeNSViewController(context: Context) -> WebViewController {
        return context.coordinator.webViewController
    }

    func updateNSViewController(_ webViewController: WebViewController, context: Context) {
        guard let url = url, url != context.coordinator.lastUrl || !context.coordinator.loaded else {
            return
        }
        if url != context.coordinator.lastUrl {
            context.coordinator.lastUrl = url
        }
        webViewController.load(url)
    }
}

class HNWebViewCoordinator: NSObject, WKNavigationDelegate {
    let webViewController = WebViewController()
    var lastUrl: URL? {
        didSet {
            loaded = false
        }
    }
    var loaded: Bool = false

    init(_ url: URL?) {
        lastUrl = url

        super.init()

        webViewController.wkWebView.navigationDelegate = self
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loaded = true
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            guard let url = navigationAction.request.url else {
                decisionHandler(.cancel)
                return
            }
            if url == lastUrl {
                decisionHandler(.allow)
            } else {
                NSWorkspace.shared.open(url)
                decisionHandler(.cancel)
            }
        }
        decisionHandler(.allow)
    }
}