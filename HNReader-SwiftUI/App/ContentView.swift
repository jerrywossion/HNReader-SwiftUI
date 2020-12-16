//
//  ContentView.swift
//  HNReader-SwiftUI
//
//  Created by Jie Weng on 2020/12/13.
//  Copyright © 2020 Jie Weng. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    enum Tab {
        case page
        case comment
    }

    @State private var selection: HNItem?
    @State private var selectedTab: Tab = .page
    @State private var selectedItemSourceUrl: URL?
    @State private var selectedItemCommentUrl: URL?
    @State private var selectedItemFrom: String = "Page"
    @State private var selectedItemComments: String = "Comments"
    @ObservedObject private var data = HNData()
    @ObservedObject private var userSettings = UserSettings()

    var body: some View {
        return NavigationView {
            List(data.items, id: \.self, selection: $selection) { item in
                HNItemView(item: item)
                    .environmentObject(userSettings)
            }
            .frame(minWidth: 500)
            .onChange(
                of: selection,
                perform: { selection in
                    if let item = selection {
                        userSettings.visitedUrls[item.sourceUrl.absoluteString] = 1
                        UserDefaults.standard.setValue(
                            userSettings.visitedUrls,
                            forKey: UserSettings.Key.visitedUrls.rawValue
                        )
                        selectedTab = .page
                        selectedItemSourceUrl = item.sourceUrl
                        selectedItemCommentUrl = item.commentUrl
                        selectedItemFrom = item.from
                        selectedItemComments = item.comments
                    }
                }
            )

            TabView(selection: $selectedTab) {
                HNWebViewController(url: $selectedItemSourceUrl)
                    .tabItem { Text(selectedItemFrom) }
                    .tag(Tab.page)

                HNWebViewController(url: $selectedItemCommentUrl)
                    .tabItem { Text(selectedItemComments) }
                    .tag(Tab.comment)
            }
         }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
