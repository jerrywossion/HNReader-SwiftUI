//
//  HNItemView.swift
//  HNReader-SwiftUI
//
//  Created by Jie Weng on 2020/12/13.
//  Copyright © 2020 Jie Weng. All rights reserved.
//

import SwiftUI

struct HNItemView: View {
    @State var item: HNItem

    var body: some View {
        HStack(alignment: .top) {
            Text(item.rank)
                .frame(alignment: .top)
                .foregroundColor(.orange)

            VStack(alignment: .leading) {
                Text(item.title)
                    .frame(alignment: .leading)

                HStack {
                    Text(item.score)
                    Text(item.age)
                    Text(item.comments)
                    Text(item.from)
                }
                .font(.footnote)
                .foregroundColor(.gray)
            }
        }
    }
}

struct HNItemView_Previews: PreviewProvider {
    static var previews: some View {
        HNItemView(
            item:
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
    }
}
