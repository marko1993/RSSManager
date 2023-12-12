//
//  StackItemView.swift
//  RSSManager
//
//  Created by Marko Matijević on 08.12.2023..
//

import UIKit

class TabBarItemView: UIView, BaseView {
    
    private lazy var titleLabel = UILabel()
    private lazy var tabIconImageView = UIImageView()
    private lazy var highlightsView = UIView()
    
    private var isSelected: Bool = false
    private var tabBarItem: TabBarItem
    
    private let higlightBGColor = UIColor.primaryTransparentColor
    private let selectedImageColor = UIColor.white
    private let defualtImageColor = UIColor.gray
    
    init(item: TabBarItem) {
        self.tabBarItem = item
        super.init(frame: .zero)
        setupView()
        setIsSelected(isSelected: tabBarItem.isSelected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setIsSelected(isSelected: Bool) {
        self.isSelected = isSelected
        self.updateUI(isSelected: isSelected)
    }
    
    func getTabBarItem() -> TabBarItem {
        return tabBarItem
    }
    
    private func updateUI(isSelected: Bool) {
        tabBarItem.isSelected = isSelected
        let options: UIView.AnimationOptions = isSelected ? [.curveEaseIn] : [.curveEaseOut]
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: options, animations: {
            self.styleSubviews()
            (self.superview as? UIStackView)?.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func setupTitleLabel() {
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        titleLabel.text = isSelected ? tabBarItem.title : ""
        titleLabel.textColor = isSelected ? selectedImageColor : higlightBGColor
    }
    
    private func setupTabIcon() {
        tabIconImageView.image = UIImage(systemName: tabBarItem.image)?.withRenderingMode(.alwaysTemplate)
        tabIconImageView.tintColor = isSelected ? selectedImageColor : defualtImageColor
    }
    
    private func setupHighlightsView() {
        highlightsView.layer.cornerRadius = 15
        highlightsView.layer.masksToBounds = true
        highlightsView.backgroundColor = isSelected ? higlightBGColor.withAlphaComponent(0.4) : UIColor.clear
    }
    
    func addSubviews() {
        addSubview(highlightsView)
        addSubview(tabIconImageView)
        addSubview(titleLabel)
    }
    
    func styleSubviews() {
        setupTitleLabel()
        setupTabIcon()
        setupHighlightsView()
    }
    
    func positionSubviews() {
        highlightsView.centerInSuperview()
        highlightsView.anchor(size: CGSize(width: 95, height: 35))
        highlightsView.anchor(paddingTop: 3, paddingBottom: 3)
        
        tabIconImageView.anchor(left: leftAnchor, paddingLeft: 2, width: 20, height: 20)
        tabIconImageView.centerY(inView: self)
        
        titleLabel.anchor(left: tabIconImageView.rightAnchor, right: self.rightAnchor, paddingLeft: 2, paddingRight: 2)
        titleLabel.centerY(inView: self)
    }
    
}
