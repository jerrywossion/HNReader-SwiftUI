//
//  ContentView.swift
//  HNReader-SwiftUI
//
//  Created by Jie Weng on 2020/12/13.
//  Copyright © 2020 Jie Weng. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: HNItem?
    @State private var selectedItem: HNItem = HNItem(
        rank: 0,
        title: "",
        sourceUrl: URL(string: "about:blank")!,
        commentUrl: URL(string: "about:blank")!,
        score: "",
        age: "",
        comments: "No Comments",
        from: "Empty Page"
    )
    @ObservedObject private var data = HNData()
    @ObservedObject private var userSettings = UserSettings()

    var body: some View {
        return NavigationView {
            List(data.items, id: \.self, selection: $selection) { item in
                HNItemView(item: item)
                    .environmentObject(userSettings)
                    .contextMenu {
                        Button(action: {
                            NSWorkspace.shared.open(item.sourceUrl)

                        }) {
                            Text("Open Webpage in Browser")
                            Image(systemName: "link.circle")
                        }
                        Button(action: {
                            NSWorkspace.shared.open(item.commentUrl)

                        }) {
                            Text("Open Comments in Browser")
                            Image(systemName: "line.2.horizontal.decrease.circle")
                        }
                        Divider()
                        Button(action: {
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString(item.sourceUrl.absoluteString, forType: .string)

                        }) {
                            Text("Copy Webpage URL")
                            Image(systemName: "link")
                        }
                        Button(action: {
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString(item.commentUrl.absoluteString, forType: .string)

                        }) {
                            Text("Copy Comments URL")
                            Image(systemName: "text.bubble")
                        }
                    }
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
                        selectedItem = item
                    }
                }
            )

            HNDetailView(item: $selectedItem)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
