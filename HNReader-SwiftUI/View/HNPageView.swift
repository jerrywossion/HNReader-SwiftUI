//
//  HNPageView.swift
//  HNReader-SwiftUI
//
//  Created by Jie Weng on 2020/12/13.
//  Copyright © 2020 Jie Weng. All rights reserved.
//

import SwiftUI

struct HNPageView: View {
    let url: URL
    @State var progress: Double = 0

    var body: some View {
        ZStack(alignment: .top) {
            HNWebView(url: url, progress: $progress)
                .zIndex(0)

            if progress > 0 && progress < 1 {
                ProgressView(value: progress, total: 1)
                    .zIndex(1)
            }
        }
    }
}

struct HNPageView_Previews: PreviewProvider {
    static var previews: some View {
        HNPageView(url: URL(string: "https://127.0.0.1")!, progress: 0.5)
    }
}
