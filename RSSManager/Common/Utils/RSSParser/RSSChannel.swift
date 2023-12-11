//
//  RSS.swift
//  RSSManager
//
//  Created by Marko Matijević on 10.12.2023..
//

import Foundation

struct RSSChannel {
    var id: String = UUID().uuidString
    var title: String?
    var description: String?
    var imageUrl: String?
    var userId: String?
    var isFavourite: Bool = false
    var items: [RSSItem] = []
}
