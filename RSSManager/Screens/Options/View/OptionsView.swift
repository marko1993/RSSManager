//
//  OptionsView.swift
//  RSSManager
//
//  Created by Marko Matijević on 09.12.2023..
//

import UIKit

class OptionsView: UIView, BaseView {
    
    lazy var logOutButton: Button = Button(text: "Log Out", type: .secondary)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        addSubview(logOutButton)
    }
    
    func styleSubviews() {
        
    }
    
    func positionSubviews() {
        logOutButton.anchor(leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 110, right: 16))
        logOutButton.constrainHeight(50)
    }
    
}
