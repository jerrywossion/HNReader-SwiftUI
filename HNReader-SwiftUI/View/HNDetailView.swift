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

    @State private var isHoveringSourceButton: Bool = false
    @State private var isHoveringCommentButton: Bool = false

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

                    HStack {
                        Button(
                            item.from,
                            action: {
                                selectedTab = .page
                            }
                        )
                        .buttonStyle(PlainButtonStyle())
                        .frame(height: 24)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 1)
                        .contentShape(Rectangle())
                        .background(
                            selectedTab == .page
                                ? Color(NSColor.white.withAlphaComponent(0.4))
                                : (isHoveringSourceButton ? Color(NSColor.white.withAlphaComponent(0.2)) : Color.clear)
                        )
                        .cornerRadius(12)
                        .onHover { hovering in
                            isHoveringSourceButton = hovering
                        }

                        Button(
                            item.comments,
                            action: {
                                selectedTab = .comment
                            }
                        )
                        .buttonStyle(PlainButtonStyle())
                        .frame(height: 24)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 1)
                        .contentShape(Rectangle())
                        .background(
                            selectedTab == .comment
                                ? Color(NSColor.white.withAlphaComponent(0.4))
                                : (isHoveringCommentButton ? Color(NSColor.white.withAlphaComponent(0.2)) : Color.clear)
                        )
                        .cornerRadius(12)
                        .onHover { hovering in
                            isHoveringCommentButton = hovering
                        }
                    }
                    .padding(.horizontal, 2)
                    .padding(.vertical, 2)
                    .background(Color(NSColor.selectedTextBackgroundColor))
                    .cornerRadius(14)
                    .offset(y: -2)
                }
            }
            .onChange(
                of: item,
                perform: { newItem in
                    selectedSourceUrl = newItem.sourceUrl
                    selectedCommentUrl = newItem.commentUrl
                    selectedTab = .page
                }
            )
            .onReceive(
                NotificationCenter.default.publisher(for: .openInBrowser),
                perform: { _ in
                    let url = selectedTab == .page ? selectedSourceUrl : selectedCommentUrl
                    NSWorkspace.shared.open(url)
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
                    rank: 0,
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
