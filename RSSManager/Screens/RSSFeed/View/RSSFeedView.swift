//
//  RSSFeedView.swift
//  RSSManager
//
//  Created by Marko Matijević on 09.12.2023..
//

import UIKit

class RSSFeedView: UIView, BaseView {
    
    lazy var searchBar: SearchBar = SearchBar(placeholder: "Enter RSS url...")
    lazy var addButton: Button = Button(text: "Add", type: .primary)
    lazy var channelsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RSSChannelCell.self, forCellWithReuseIdentifier: RSSChannelCell.cellIdentifier)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        addSubview(addButton)
        addSubview(searchBar)
        addSubview(channelsCollectionView)
    }
    
    func styleSubviews() {
        channelsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
    }
    
    func positionSubviews() {
        addButton.anchor(top: topAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 16))
        addButton.constrainHeight(40)
        addButton.constrainWidth(50)
        
        searchBar.anchor(top: topAnchor, leading: leadingAnchor, trailing: addButton.leadingAnchor, padding: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16))
        searchBar.constrainHeight(40)
        
        channelsCollectionView.anchor(top: searchBar.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
    }
    
}
