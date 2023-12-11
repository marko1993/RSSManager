//
//  LoginView.swift
//  RSSManager
//
//  Created by Marko Matijević on 09.12.2023..
//

import UIKit

class LoginView: UIView, BaseView {
    
    private lazy var titleLabel: UILabel = UILabel()
    lazy var emailTextField: TextField = TextField(title: K.Strings.email, placeholder: K.Strings.emailPlaceholder, keyboardType: .emailAddress)
    lazy var passwordTextField: TextField = TextField(title: K.Strings.password, placeholder: K.Strings.passwordPlaceholder, isSecureTextEntry: true)
    lazy var loginButton: Button = Button(text: K.Strings.login, type: .primary)
    lazy var registerButton: Button = Button(text: K.Strings.register, type: .secondary)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        addSubview(titleLabel)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)
        addSubview(registerButton)
    }
    
    func styleSubviews() {
        titleLabel.text = K.Strings.appName
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
    }
    
    func positionSubviews() {
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 40, left: 16, bottom: 0, right: 16))
        
        emailTextField.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 40, left: 16, bottom: 0, right: 16))
        
        passwordTextField.anchor(top: emailTextField.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16))
        
        registerButton.anchor(leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 40, right: 16))
        registerButton.constrainHeight(50)
        
        loginButton.anchor(leading: leadingAnchor, bottom: registerButton.topAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16))
        loginButton.constrainHeight(50)
        
    }
    
}

