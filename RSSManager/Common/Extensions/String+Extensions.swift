//
//  String+Extensions.swift
//  RSSManager
//
//  Created by Marko Matijević on 08.12.2023..
//

import Foundation

extension String? {
    func isEmptyOrNull() -> Bool {
        if self == nil { return true }
        return self!.isEmpty
    }
}
