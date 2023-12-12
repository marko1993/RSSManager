//
//  EmptyContentView.swift
//  RSSManager
//
//  Created by Marko Matijević on 12.12.2023..
//

import UIKit

class EmptyContentView: UIView, BaseView {
    
    private lazy var imageView: UIImageView = UIImageView(image: UIImage(named: "feed"))
    private lazy var descriptionLabel: UILabel = UILabel()
    private lazy var container: UIStackView = UIStackView(arrangedSubviews: [imageView, descriptionLabel])
    
    private let descriptionText: String
    
    init(descriptionText: String) {
        self.descriptionText = descriptionText
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.text = descriptionText
        descriptionLabel.textColor = .lightGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
    }
    
    private func setupContainerView() {
        container.axis = .vertical
        container.spacing = 30
        container.alignment = .center
    }
    
    func addSubviews() {
        addSubview(container)
    }
    
    func styleSubviews() {
        setupDescriptionLabel()
        setupContainerView()
    }
    
    func positionSubviews() {
        descriptionLabel.constrainWidth(250)
        
        imageView.constrainWidth(100)
        imageView.constrainHeight(100)
        
        container.centerInSuperview()
    }

}
