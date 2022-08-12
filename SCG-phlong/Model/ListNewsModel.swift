//
//  ListNewsModel.swift
//  SCG-phlong
//
//  Created by phlong on 12/08/2022.
//

import Foundation

struct ListNewsModel: Codable {
    var status: String?
    var totalResuts: Int?
    var articles: [Article] = []
}

struct Article: Codable {
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
}
