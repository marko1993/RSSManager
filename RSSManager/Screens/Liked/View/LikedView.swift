//
//  LikedView.swift
//  RSSManager
//
//  Created by Marko Matijević on 09.12.2023..
//

import UIKit

class LikedView: UIView, BaseView {
    
    lazy var searchBar: SearchBar = SearchBar(placeholder: K.Strings.likedSearchBarPlaceholder)
    lazy var emptyContentView: EmptyContentView = EmptyContentView(descriptionText: K.Strings.likedEmptyMessage)
    let itemsTableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        itemsTableView.backgroundColor = .clear
        itemsTableView.rowHeight = LikedItemCell.rowHeight
        itemsTableView.separatorStyle = .none
        itemsTableView.showsVerticalScrollIndicator = false
        itemsTableView.contentInsetAdjustmentBehavior = .never
        itemsTableView.allowsSelection = true
        itemsTableView.tableHeaderView = nil
        itemsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        itemsTableView.register(LikedItemCell.self, forCellReuseIdentifier: LikedItemCell.cellIdentifier)
    }
    
    func addSubviews() {
        addSubview(searchBar)
        addSubview(itemsTableView)
        addSubview(emptyContentView)
    }
    
    func styleSubviews() {
        setupTableView()
    }
    
    func positionSubviews() {
        searchBar.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16))
        searchBar.constrainHeight(40)
        
        emptyContentView.centerInSuperview()
        
        itemsTableView.anchor(top: searchBar.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 16, left: 4, bottom: 16, right: 4))
    }
    
}
