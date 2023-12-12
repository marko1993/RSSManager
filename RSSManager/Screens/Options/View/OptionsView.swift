//
//  OptionsView.swift
//  RSSManager
//
//  Created by Marko Matijević on 09.12.2023..
//

import UIKit

class OptionsView: UIView, BaseView {
    
    lazy var titleLabel: UILabel = UILabel()
    lazy var notificationsLabel: UILabel = UILabel()
    lazy var notificationsSwitch: UISwitch = UISwitch()
    lazy var logOutButton: Button = Button(text: K.Strings.logout, type: .secondary)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTitleLabel() {
        titleLabel.text = "Notifications"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    func setupNotificationsLabel() {
        notificationsLabel.text = "Switch on to receive notifications for favourite RSS feeds"
        notificationsLabel.textColor = .black
        notificationsLabel.font = UIFont.systemFont(ofSize: 14)
        notificationsLabel.numberOfLines = 0
    }
    
    func setupNotificationsSwitch() {
        notificationsSwitch.onTintColor = UIColor.primaryTransparentColor
    }
    
    func addSubviews() {
        addSubview(titleLabel)
        addSubview(notificationsLabel)
        addSubview(notificationsSwitch)
        addSubview(logOutButton)
    }
    
    func styleSubviews() {
        setupTitleLabel()
        setupNotificationsLabel()
        setupNotificationsSwitch()
    }
    
    func positionSubviews() {
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16))
        titleLabel.constrainHeight(30)
        
        notificationsSwitch.anchor(top: titleLabel.bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 16))
        notificationsSwitch.constrainHeight(40)
        
        notificationsLabel.anchor(leading: leadingAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 66))
        notificationsLabel.centerY(inView: notificationsSwitch)
        notificationsLabel.constrainHeight(40)
        
        logOutButton.anchor(leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 110, right: 16))
        logOutButton.constrainHeight(50)
    }
    
}
