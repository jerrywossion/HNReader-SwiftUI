//
//  HNData.swift
//  HNReader-SwiftUI
//
//  Created by Jie Weng on 2020/12/13.
//  Copyright © 2020 Jie Weng. All rights reserved.
//

import Combine
import Foundation

struct HNItem: Equatable, Hashable {
    var rank: Int
    var title: String
    var sourceUrl: URL
    var commentUrl: URL
    var score: String
    var age: String
    var comments: String
    var from: String

    static func == (lhs: HNItem, rhs: HNItem) -> Bool {
        return lhs.sourceUrl == rhs.sourceUrl && lhs.commentUrl == rhs.commentUrl
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(sourceUrl)
        hasher.combine(commentUrl)
    }
}

class HNData: ObservableObject {
    @Published var items: [HNItem]
    private var currentPage: Int = 1
    private var subscriptions: Set<AnyCancellable> = []
    private lazy var notificationSubscriptions: [Notification.Name: () -> Void] = [
        .prevPage: self.prevPage,
        .nextPage: self.nextPage,
        .homePage: self.homePage,
    ]

    private func fetchHNItems() {
        items.removeAll()
        getHNItems(
            page: currentPage,
            completion: { [self] items in
                self.items.append(contentsOf: items)
            }
        )
    }

    init() {
        self.items = []
        fetchHNItems()

        NotificationCenter.default.publisher(for: .prevPage).sink { [weak self] _ in self?.prevPage() }
            .store(in: &subscriptions)
        NotificationCenter.default.publisher(for: .nextPage).sink { [weak self] _ in self?.nextPage() }
            .store(in: &subscriptions)
        NotificationCenter.default.publisher(for: .homePage).sink { [weak self] _ in self?.homePage() }
            .store(in: &subscriptions)
    }

    func prevPage() {
        guard currentPage > 1 else { return }
        currentPage -= 1
        fetchHNItems()
    }

    func nextPage() {
        currentPage += 1
        fetchHNItems()
    }

    func homePage() {
        currentPage = 1
        fetchHNItems()
    }
}

class UserSettings: ObservableObject {
    enum Key: String {
        case visitedUrls
    }

    @Published var visitedUrls: [String: Int] = [:]

    init() {
        if let visitedUrls = UserDefaults.standard.dictionary(forKey: Key.visitedUrls.rawValue) as? [String: Int] {
            self.visitedUrls = visitedUrls
        }
    }
}
