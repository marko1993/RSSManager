//
//  Button.swift
//  RSSManager
//
//  Created by Marko Matijević on 10.12.2023..
//

import Foundation

import UIKit

enum ButtonStyle {
    case primary, secondary
}

class Button: UIButton, BaseView {
    
    private var text: String?
    private var attributedText: NSMutableAttributedString?
    private var type: ButtonStyle
    
    init(text: String? = nil, attributedText: NSMutableAttributedString? = nil, type: ButtonStyle) {
        self.text = text
        self.attributedText = attributedText
        self.type = type
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func addSubviews() {
        
    }
    
    func styleSubviews() {
        switch type {
        case .primary:
            setupPrimaryButton()
        case .secondary:
            setupSecondaryButton()
        }
        if let attributedText = attributedText {
            setAttributedTitle(attributedText, for: .normal)
        } else {
            setTitle(text, for: .normal)
        }
    }
    
    func positionSubviews() {
        
    }
    
    private func setupPrimaryButton() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        backgroundColor = .primaryColor
        setTitleColor(.white, for: .normal)
    }
    
    private func setupSecondaryButton() {
        layer.cornerRadius = 8
        layer.borderColor = UIColor.primaryColor.cgColor
        layer.borderWidth = 1
        setTitleColor(.primaryColor, for: .normal)
        layer.masksToBounds = true
    }
    
}
