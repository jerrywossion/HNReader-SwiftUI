//
//  HNDetailView.swift
//  HNReader-SwiftUI
//
//  Created by Jie Weng on 2020/12/17.
//  Copyright © 2020 Jie Weng. All rights reserved.
//

import SwiftUI

struct HNDetailView: View {
    enum Tab: String {
        case page
        case comment
    }

    @Binding var item: HNItem
    @State private var selectedTab: Tab = .page
    @State private var selectedSourceUrl: URL
    @State private var selectedCommentUrl: URL

    init(item: Binding<HNItem>) {
        _item = item
        _selectedSourceUrl = State(initialValue: item.wrappedValue.sourceUrl)
        _selectedCommentUrl = State(initialValue: item.wrappedValue.commentUrl)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if selectedTab == .page {
                    HNWebViewController(tag: Tab.page.rawValue, url: $selectedSourceUrl)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                } else {
                    HNWebViewController(tag: Tab.comment.rawValue, url: $selectedCommentUrl)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                }

                VStack {
                    Spacer()

                    Picker(selection: $selectedTab, label: Text("")) {
                        Text(item.from)
                            .tag(Tab.page)

                        Text(item.comments)
                            .tag(Tab.comment)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .background(Color.black)
                }
            }
            .onChange(
                of: item,
                perform: { newItem in
                    selectedSourceUrl = newItem.sourceUrl
                    selectedCommentUrl = newItem.commentUrl
                }
            )
        }
    }
}

struct HNDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HNDetailView(
            item: .constant(
                HNItem(
                    rank: "1. ",
                    title: "Test title",
                    sourceUrl: URL(string: "https://www.google.com")!,
                    commentUrl: URL(string: "https://www.google.com")!,
                    score: "60 points",
                    age: "14 hours ago",
                    comments: "600 comments",
                    from: "google.com"
                )
            )
        )
    }
}
