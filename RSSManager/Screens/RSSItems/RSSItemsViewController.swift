//
//  RSSItemsViewController.swift
//  RSSManager
//
//  Created by Marko Matijević on 11.12.2023..
//

import UIKit

class RSSItemsViewController: BaseViewController {
    
    private var viewModel: RSSItemsViewModelProtocol
    private var rssItemsView: RSSItemsView
    
    init(viewModel: RSSItemsViewModelProtocol, rssItemsView: RSSItemsView = RSSItemsView()) {
        self.viewModel = viewModel
        self.rssItemsView = rssItemsView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView(rssItemsView)
        setupBinding()
        viewModel.getRSSItems()
    }
    
    private func setupBinding() {
        bind(requestState: self.viewModel.networkRequestStateObservable)
        bind(errorMessage: self.viewModel.errorMessageObservable)
        
        viewModel
            .rssItemsDriver
            .drive(rssItemsView.itemsTableView.rx.items(cellIdentifier: RSSItemCell.cellIdentifier, cellType: RSSItemCell.self)) { [weak self] (_, item, cell) in
                cell.configure(with: item)
                self?.setupCellBindings(cell, item: item)
            }
            .disposed(by: disposeBag)
    }
    
    private func setupCellBindings(_ cell: RSSItemCell, item: RSSItem) {
        cell.onTap(disposeBag: self.disposeBag) { [weak self] in
            guard let link = item.link else { return }
            self?.viewModel.openLink(urlString: link)
        }
        cell.likeImageView.onTap(disposeBag: disposeBag) { [weak self] in
            self?.viewModel.likeRSSItem(item)
        }
    }
    
}

