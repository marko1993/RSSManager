//
//  NSMutableAttributedString+Extensions.swift
//  RSSManager
//
//  Created by Marko Matijević on 12.12.2023..
//

import UIKit

extension NSMutableAttributedString {
    func normal(_ value: String, font: UIFont) -> NSMutableAttributedString {
        self.append(NSAttributedString(string: value, attributes: [.font : font]))
        return self
    }
    
    func colored(_ value: String, font: UIFont, color: UIColor) -> NSMutableAttributedString {
        self.append(NSAttributedString(string: value, attributes: [
            .font : font,
            .foregroundColor : color
        ]))
        return self
    }
    
    func bold(_ value: String, fontSize: CGFloat = 18) -> NSMutableAttributedString {
        self.append(NSAttributedString(string: value, attributes: [
            .font : UIFont.boldSystemFont(ofSize: fontSize)
        ]))
        return self
    }
    
}
