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
            progressBar.topAnchor.constraint(equalTo: view.topAnchor),
            progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
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

    override func viewWillLayout() {
        super.viewWillLayout()
        view.translatesAutoresizingMaskIntoConstraints = false
        guard let superView = view.superview else { return }
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor),
            view.leadingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    func load(_ url: URL) {
        wkWebView.load(URLRequest(url: url))
    }

    func reload() {
        wkWebView.reload()
    }
}

struct HNWebViewController: NSViewControllerRepresentable {
    let url: URL

    func makeNSViewController(context: Context) -> WebViewController {
        return WebViewController()
    }

    func updateNSViewController(_ webViewController: WebViewController, context: Context) {
        webViewController.load(url)
    }
}
