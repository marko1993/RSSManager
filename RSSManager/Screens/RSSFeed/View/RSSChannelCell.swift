//
//  RSSChannelCell.swift
//  RSSManager
//
//  Created by Marko Matijević on 11.12.2023..
//

import UIKit
import SDWebImage

class RSSChannelCell: UICollectionViewCell, BaseView {
    
    lazy var channelImageView: UIImageView = UIImageView()
    lazy var bottomBackgroundView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    lazy var titleLabel: UILabel = UILabel()
    lazy var favouriteImageView: RoundedImageView = RoundedImageView(image: UIImage(systemName: "star.fill")!)
    lazy var deleteImageView: RoundedImageView = RoundedImageView(image: UIImage(systemName: "trash.fill")!)
    
    static let cellIdentifier = "RSSChannelCell"
    static let rowHeight: CGFloat = 150.0
    private var channel: RSSChannel!
    
    func configure(with channel: RSSChannel) {
        self.channel = channel
        titleLabel.text = channel.title
        setupView()
        if let stringUrl = channel.imageUrl,
           let url = URL(string: stringUrl) {
            channelImageView.sd_setImage(with: url, completed: nil)
        } else {
            channelImageView.image = nil
        }
    }
    
    private func configureBackgroundView() {
        bottomBackgroundView.backgroundColor = .clear
        bottomBackgroundView.frame = bounds
        bottomBackgroundView.alpha = 0.5
        bottomBackgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func configureTitleLabel() {
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
    }
    
    private func setupFavouriteImageView() {
        favouriteImageView.setImageColor(channel.isFavourite ? .yellow : .white)
    }
    
    func addSubviews() {
        addSubview(channelImageView)
        addSubview(bottomBackgroundView)
        addSubview(titleLabel)
        addSubview(favouriteImageView)
        addSubview(deleteImageView)
    }
    
    func styleSubviews() {
        backgroundColor = .lightGray
        layer.cornerRadius = 5
        layer.masksToBounds = true
        configureBackgroundView()
        configureTitleLabel()
        setupFavouriteImageView()
    }
    
    func positionSubviews() {
        channelImageView.fillSuperview()
        
        bottomBackgroundView.anchor(leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        bottomBackgroundView.constrainHeight(50)
        
        titleLabel.anchor(leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        titleLabel.constrainHeight(50)
        
        favouriteImageView.anchor(top: topAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 4), size: CGSize(width: 26, height: 26))
        
        deleteImageView.anchor(top: favouriteImageView.bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 4), size: CGSize(width: 28, height: 28))
    }
    
}
