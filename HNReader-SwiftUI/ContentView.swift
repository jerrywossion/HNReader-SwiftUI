//
//  ContentView.swift
//  HNReader-SwiftUI
//
//  Created by Jie Weng on 2020/12/13.
//  Copyright © 2020 Jie Weng. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var selection = Set<HNItem>()
    @ObservedObject var data = HNData()

    var body: some View {
        NavigationView {
            List(data.items, id: \.self, selection: $selection) { item in
                HNItemView(item: item)
            }

            if let item = selection.first {
                TabView {
                    HNWebView(url: item.sourceUrl)
                        .tabItem { Text(item.from) }
                    HNWebView(url: item.commentUrl)
                        .tabItem { Text(item.comments) }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(
                    action: {
                        data.homePage()
                    },
                    label: {
                        Image(systemName: "newspaper")
                    }
                )
            }
            ToolbarItem(placement: .navigation) {
                Button(
                    action: {
                        data.prevPage()
                    },
                    label: {
                        Image(systemName: "arrow.backward")
                    }
                )
            }
            ToolbarItem(placement: .navigation) {
                Button(
                    action: {
                        data.nextPage()
                    },
                    label: {
                        Image(systemName: "arrow.forward")
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
                        Image(systemName: "sidebar.left")
                    }
                )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
