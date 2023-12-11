//
//  BaseView.swift
//  RSSManager
//
//  Created by Marko Matijević on 08.12.2023..
//

import UIKit

protocol BaseView where Self: UIView {
    func addSubviews()
    func styleSubviews()
    func positionSubviews()
}

extension BaseView {
    func setupView() {
        addSubviews()
        styleSubviews()
        positionSubviews()
    }
}

