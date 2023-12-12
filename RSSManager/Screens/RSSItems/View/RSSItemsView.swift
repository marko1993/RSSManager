//
//  RSSItemsView.swift
//  RSSManager
//
//  Created by Marko Matijević on 11.12.2023..
//

import UIKit

class RSSItemsView: UIView, BaseView {
    
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
        itemsTableView.rowHeight = RSSItemCell.rowHeight
        itemsTableView.separatorStyle = .none
        itemsTableView.showsVerticalScrollIndicator = false
        itemsTableView.contentInsetAdjustmentBehavior = .never
        itemsTableView.allowsSelection = true
        itemsTableView.tableHeaderView = nil
        itemsTableView.register(RSSItemCell.self, forCellReuseIdentifier: RSSItemCell.cellIdentifier)
    }
    
    func addSubviews() {
        addSubview(itemsTableView)
    }
    
    func styleSubviews() {
        setupTableView()
    }
    
    func positionSubviews() {
        itemsTableView.fillSuperview(padding: UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0))
    }
    
}
