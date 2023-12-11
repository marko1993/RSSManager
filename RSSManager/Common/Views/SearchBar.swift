//
//  SearchBar.swift
//  RSSManager
//
//  Created by Marko Matijević on 10.12.2023..
//

import UIKit
import RxSwift
import RxCocoa

protocol SearchBarDelegate: AnyObject {
    func valueDidChange(_ searchBar: SearchBar, value: String)
}

class SearchBar: UIView, BaseView {
    
    private lazy var imageView: UIImageView = UIImageView(image: UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor.primaryColor))
    lazy var inputTextField: UITextField = UITextField()
    
    private let placeholder: String
    weak var delegate: SearchBarDelegate?
    private let disposeBag = DisposeBag()
    
    init(placeholder: String) {
        self.placeholder = placeholder
        super.init(frame: .zero)
        setupView()
        setupBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBinding() {
        inputTextField.rx.text
            .orEmpty
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.delegate?.valueDidChange(self, value: text)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureView() {
        layer.cornerRadius = 10
        layer.masksToBounds = true
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
        backgroundColor = .clear
    }
    
    private func configureTextField() {
        inputTextField.placeholder = placeholder
        inputTextField.textColor = .black
        inputTextField.font = UIFont.systemFont(ofSize: 14)
        inputTextField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
    }
    
    func addSubviews() {
        addSubview(imageView)
        addSubview(inputTextField)
    }
    
    func styleSubviews() {
        configureView()
        configureTextField()
    }
    
    func positionSubviews() {
        imageView.anchor(leading: leadingAnchor, padding: UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 0))
        imageView.centerYToSuperview()
        imageView.constrainWidth(24)
        imageView.constrainHeight(24)
        
        inputTextField.anchor(leading: imageView.trailingAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 14))
        inputTextField.centerYToSuperview()
        inputTextField.constrainHeight(24)
    }
    
    func getText() -> String? {
        return inputTextField.text
    }
    
    func clearText() {
        inputTextField.text = ""
    }
    
}

