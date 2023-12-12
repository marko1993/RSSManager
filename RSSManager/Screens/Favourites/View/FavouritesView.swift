//
//  FavouritesView.swift
//  RSSManager
//
//  Created by Marko Matijević on 09.12.2023..
//

import UIKit

class FavouritesView: UIView, BaseView {
    
    lazy var searchBar: SearchBar = SearchBar(placeholder: K.Strings.favouritesSearchBarPlaceholder)
    lazy var emptyContentView: EmptyContentView = EmptyContentView(descriptionText: K.Strings.favouritesEmptyMessage)
    lazy var channelsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FavouriteChannelCell.self, forCellWithReuseIdentifier: FavouriteChannelCell.cellIdentifier)
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
        addSubview(searchBar)
        addSubview(emptyContentView)
        addSubview(channelsCollectionView)
    }
    
    func styleSubviews() {
        channelsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
    }
    
    func positionSubviews() {
        searchBar.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16))
        searchBar.constrainHeight(40)
        
        emptyContentView.centerInSuperview()
        
        channelsCollectionView.anchor(top: searchBar.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8))
    }
    
}
