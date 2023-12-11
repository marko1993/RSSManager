//
//  TextField.swift
//  RSSManager
//
//  Created by Marko Matijević on 10.12.2023..
//

import UIKit
import RxSwift
import RxCocoa

protocol TextFieldDelegate: AnyObject {
    func textDidChange(_ textField: TextField, text: String?)
}

class TextField: UIView, BaseView {
    
    private lazy var titleLabel: UILabel = UILabel()
    private lazy var textField: UITextField = UITextField()
    private lazy var container: UIStackView = UIStackView(arrangedSubviews: [titleLabel, textField])
    
    weak var delegate: TextFieldDelegate?
    private let title: String
    private let placeholder: String
    private let keyboardType: UIKeyboardType
    private let isSecureTextEntry: Bool
    private let textInset: CGFloat = 14.0
    private let disposeBag = DisposeBag()
    
    init(title: String, placeholder: String, keyboardType: UIKeyboardType = .default, isSecureTextEntry: Bool = false) {
        self.title = title
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.isSecureTextEntry = isSecureTextEntry
        super.init(frame: .zero)
        setupView()
        setupBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBinding() {
        textField.rx.text.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            if !text.isEmptyOrNull() { self.isWarningEnabled(false) }
            self.delegate?.textDidChange(self, text: text)
        }).disposed(by: disposeBag)
    }
    
    func getText() -> String? {
        return textField.text
    }
    
    func textEmptyOrNull() -> Bool {
        return getText().isEmptyOrNull()
    }
    
    func isWarningEnabled(_ isEnabled: Bool) {
        titleLabel.textColor = isEnabled ? .red : .black
        textField.layer.borderColor = isEnabled ? UIColor.red.cgColor : UIColor.lightGray.cgColor
    }
    
    private func configureContainer() {
        container.axis = .vertical
        container.spacing = 6
    }
    
    private func configureTitleLabel() {
        titleLabel.text = title
    }
    
    private func configureTextField() {
        textField.isSecureTextEntry = isSecureTextEntry
        textField.keyboardType = keyboardType
        textField.placeholder = placeholder
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.backgroundColor = .clear
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        let insetView = UIView(frame: CGRect(x: 0, y: 0, width: textInset, height: 0))
        textField.leftView = insetView
        textField.leftViewMode = .always
        textField.rightView = insetView
        textField.rightViewMode = .always
    }
    
    func addSubviews() {
        addSubview(container)
    }
    
    func styleSubviews() {
        configureContainer()
        configureTitleLabel()
        configureTextField()
    }
    
    func positionSubviews() {
        textField.constrainHeight(50)
        
        container.fillSuperview()
    }
    
}

