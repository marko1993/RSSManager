//
//  RoundedImageView.swift
//  RSSManager
//
//  Created by Marko Matijević on 11.12.2023..
//

import UIKit

class RoundedImageView: UIView, BaseView {
    
    lazy var imageView: UIImageView = UIImageView()
    lazy var backgroundView: UIView = UIView()
    private let image: UIImage
    
    init(image: UIImage) {
        self.image = image.withRenderingMode(.alwaysTemplate)
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImageColor(_ color: UIColor) {
        imageView.tintColor = color
    }
    
    private func setupBackgroundView() {
        backgroundView.backgroundColor = .lightGray.withAlphaComponent(0.7)
        backgroundView.layer.cornerRadius = 13
        backgroundView.layer.masksToBounds = true
    }
    
    private func setupImageView() {
        imageView.image = self.image
        imageView.tintColor = .white
    }
    
    func addSubviews() {
        addSubview(backgroundView)
        backgroundView.addSubview(imageView)
    }
    
    func styleSubviews() {
        setupBackgroundView()
        setupImageView()
    }
    
    func positionSubviews() {
        backgroundView.fillSuperview()
        
        imageView.centerInSuperview()
        imageView.constrainWidth(20)
        imageView.constrainHeight(20)
    }
    
}
