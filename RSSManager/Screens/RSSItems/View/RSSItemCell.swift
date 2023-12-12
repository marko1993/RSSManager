//
//  RSSItemCell.swift
//  RSSManager
//
//  Created by Marko Matijević on 11.12.2023..
//

import UIKit

class RSSItemCell: UITableViewCell, BaseView {
    
    private lazy var titleLabel: UILabel = UILabel()
    private lazy var descriptionLabel: UILabel = UILabel()
    private lazy var itemImageView: UIImageView = UIImageView()
    lazy var containerView: UIView = UIView()
    lazy var likeImageView: UIImageView = UIImageView(image: UIImage(systemName: "hand.thumbsup.fill")!.withRenderingMode(.alwaysTemplate))
    
    static let cellIdentifier = "RSSItemCell"
    static let rowHeight: CGFloat = 130.0
    private var rssItem: RSSItem!
    
    func configure(with rssItem: RSSItem) {
        self.rssItem = rssItem
        setupView()
        titleLabel.text = rssItem.title
        descriptionLabel.text = rssItem.description
        if let stringUrl = rssItem.imageUrl,
           let url = URL(string: stringUrl) {
            itemImageView.sd_setImage(with: url, completed: nil)
        } else {
            itemImageView.image = nil
        }
        likeImageView.tintColor = rssItem.isLiked ? .yellow : .lightGray
    }
    
    private func setupTitleLabel() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.contentMode = .bottomLeft
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 5
        containerView.layer.masksToBounds = true
        containerView.dropShadow()
    }
    
    func addSubviews() {
        addSubview(containerView)
        containerView.addSubview(itemImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(likeImageView)
    }
    
    func styleSubviews() {
        selectionStyle = .none
        contentView.isUserInteractionEnabled = false
        setupContainerView()
        setupTitleLabel()
        setupDescriptionLabel()
    }
    
    func positionSubviews() {
        containerView.fillSuperview(padding: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        
        likeImageView.anchor(top: containerView.topAnchor, trailing: containerView.trailingAnchor, padding: UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 4), size: CGSize(width: 25, height: 25))
        
        itemImageView.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, trailing: containerView.trailingAnchor, padding: UIEdgeInsets(top: 4, left: 4, bottom: 0, right: 4))
        itemImageView.constrainHeight(40)
        
        titleLabel.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, trailing: likeImageView.leadingAnchor, padding: UIEdgeInsets(top: 4, left: 4, bottom: 0, right: 4))
        titleLabel.constrainHeight(40)
        
        descriptionLabel.anchor(top: titleLabel.bottomAnchor, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor, padding: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        
    }
    
}
