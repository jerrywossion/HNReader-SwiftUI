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

    @State private var selection = Set<HNItem>()
    @State private var selectedItem: HNItem?
    @State private var selectedTab: Tab = .page
    @ObservedObject private var data = HNData()
    @ObservedObject private var userSettings = UserSettings()

    var body: some View {
        return NavigationView {
            List(data.items, id: \.self, selection: $selection) { item in
                HNItemView(item: item)
                    .environmentObject(userSettings)
            }
            .onChange(
                of: selection,
                perform: { selection in
                    if let item = selection.first {
                        userSettings.visitedUrls[item.sourceUrl.absoluteString] = 1
                        UserDefaults.standard.setValue(
                            userSettings.visitedUrls,
                            forKey: UserSettings.Key.visitedUrls.rawValue
                        )
                        selectedItem = item
                        selectedTab = .page
                    }
                }
            )

            if let item = selectedItem {
                TabView(selection: $selectedTab) {
                    HNWebViewController(url: item.sourceUrl)
                        .tabItem { Text(item.from) }
                        .tag(Tab.page)

                    HNWebViewController(url: item.commentUrl)
                        .tabItem { Text(item.comments) }
                        .tag(Tab.comment)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(
                    action: {
                        data.homePage()
                        clearSelection()
                    },
                    label: {
                        Image(sfSymbol: .newspaper)
                    }
                )
            }
            ToolbarItem(placement: .navigation) {
                Button(
                    action: {
                        data.prevPage()
                        clearSelection()
                    },
                    label: {
                        Image(sfSymbol: .arrowBackward)
                    }
                )
            }
            ToolbarItem(placement: .navigation) {
                Button(
                    action: {
                        data.nextPage()
                        clearSelection()
                    },
                    label: {
                        Image(sfSymbol: .arrowForward)
                    }
                )
            }
            ToolbarItem(placement: .navigation) {
                Button(
                    action: {
                        NSApp.keyWindow?.firstResponder?
                            .tryToPerform(
                                #selector(NSSplitViewController.toggleSidebar(_:)),
                                with: nil
                            )
                    },
                    label: {
                        Image(sfSymbol: .sidebarLeft)
                    }
                )
            }
            ToolbarItem(placement: .navigation) {
                Button(
                    action: {
                        if let item = selection.first {
                            NotificationCenter.default.post(
                                name: .reloadPage,
                                object: nil,
                                userInfo: [
                                    UserInfoKey.urlToReload: selectedTab == .page ? item.sourceUrl : item.commentUrl
                                ]
                            )
                        }
                    },
                    label: {
                        Image(sfSymbol: .arrowClockwise)
                    }
                )
            }
            ToolbarItem(placement: .navigation) {
                Button(
                    action: {
                        if let item = selection.first {
                            let url = selectedTab == .page ? item.sourceUrl : item.commentUrl
                            NSWorkspace.shared.open(url)
                        }
                    },
                    label: {
                        Image(sfSymbol: .safari)
                    }
                )
            }
        }
    }

    private func clearSelection() {
        selection.removeAll()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
