//
//  HNParser.swift
//  HNReader-SwiftUI
//
//  Created by Jie Weng on 2020/12/13.
//  Copyright © 2020 Jie Weng. All rights reserved.
//

import Foundation
import SwiftSoup

func getHNItems(page: Int = 0, completion: (([HNItem]) -> Void)?) {
    let baseUrlStr = "https://news.ycombinator.com/"
    if let HNUrl = URL(string: "\(baseUrlStr)news?p=\(page)") {
        let task = URLSession.shared.dataTask(with: HNUrl) { (data, response, error) in
            do {
                guard let data = data,
                    let contents = String(data: data, encoding: .utf8)
                else {
                    return
                }

                let doc: Document = try SwiftSoup.parse(contents)
                let athings = try doc.select(".athing")
                var items: [HNItem] = []
                for athing in athings {
                    guard
                        let rankText = try athing.select(".title").first()?.select("td").first()?.select("span")
                            .first()?
                            .text(),
                        let rank = Int(rankText.replacingOccurrences(of: ".", with: ""))
                    else { continue }

                    guard let titleElement = try athing.select(".title").last() else { continue }
                    guard let a = try titleElement.select("a").first() else { continue }
                    let title = try a.text()
                    let sourceUrlStr = try a.attr("href")

                    guard let from = try titleElement.select("span").first()?.select("a").first()?.text() else {
                        continue
                    }

                    guard let commentContainerElement = try athing.nextElementSibling() else { continue }

                    guard let age = try commentContainerElement.select(".age").first()?.text() else { continue }

                    guard let score = try commentContainerElement.select(".score").first()?.text() else {
                        continue
                    }

                    guard let commentElement = try commentContainerElement.select("a").last() else { continue }
                    var commentUrlStr = try commentElement.attr("href")
                    if !commentUrlStr.contains("item?") { continue }
                    commentUrlStr = "\(baseUrlStr)\(commentUrlStr)"
                    let comments = try commentElement.text()

                    guard let sourceUrl = URL(string: sourceUrlStr), let commentUrl = URL(string: commentUrlStr)
                    else {
                        continue
                    }
                    items.append(
                        HNItem(
                            rank: rank,
                            title: title,
                            sourceUrl: sourceUrl,
                            commentUrl: commentUrl,
                            score: score,
                            age: age,
                            comments: comments,
                            from: from
                        )
                    )
                }
                DispatchQueue.main.async {
                    completion?(items.sorted(by: { $0.rank < $1.rank }))
                }
            } catch {

            }
        }
        task.resume()
    } else {
        print("failed getting HN items")
    }
}
