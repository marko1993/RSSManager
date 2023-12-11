//
//  RSSItem.swift
//  RSSManager
//
//  Created by Marko Matijević on 10.12.2023..
//

import Foundation

struct RSSItem {
    var id: String = UUID().uuidString
    var title: String?
    var description: String?
    var imageUrl: String?
    var channelId: String?
}
