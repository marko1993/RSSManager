//
//  TabBarItem.swift
//  RSSManager
//
//  Created by Marko Matijević on 08.12.2023..
//

import UIKit

struct TabBarItem {
    var viewController: BaseViewController?
    let title: String
    let image: String
    let position: Int
    var isSelected: Bool
}
