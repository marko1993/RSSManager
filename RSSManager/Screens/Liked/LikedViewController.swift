//
//  LikedViewController.swift
//  RSSManager
//
//  Created by Marko Matijević on 09.12.2023..
//

import UIKit
import RxSwift
import RxCocoa

class LikedViewController: BaseViewController {
    
    private var viewModel: LikedViewModelProtocol
    private var likedView: LikedView
    
    init(viewModel: LikedViewModelProtocol, likedView: LikedView = LikedView()) {
        self.viewModel = viewModel
        self.likedView = likedView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView(likedView)
        setupBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.filterRSSItems(query: nil)
    }
    
    private func setupBinding() {
        bind(requestState: self.viewModel.networkRequestStateObservable)
        bind(errorMessage: self.viewModel.errorMessageObservable)
        
        viewModel.rssItemsDriver
            .drive(onNext: { [weak self] items in
                self?.likedView.itemsTableView.isHidden = items.count == 0
                self?.likedView.emptyContentView.isHidden = items.count > 0
            }).disposed(by: disposeBag)
        
        likedView.searchBar.inputTextField
            .rx.controlEvent([.editingChanged])
            .asObservable()
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let query = self?.likedView.searchBar.getText() else { return }
                self?.viewModel.filterRSSItems(query: query.isEmpty ? nil : query)
            }).disposed(by: disposeBag)
        
        viewModel
            .rssItemsDriver
            .drive(likedView.itemsTableView.rx.items(cellIdentifier: LikedItemCell.cellIdentifier, cellType: LikedItemCell.self)) { [weak self] (_, item, cell) in
                cell.configure(with: item)
                self?.setupCellBindings(cell, item: item)
            }
            .disposed(by: disposeBag)
    }
    
    private func setupCellBindings(_ cell: LikedItemCell, item: RSSItem) {
        cell.onTap(disposeBag: self.disposeBag) { [weak self] in
            guard let link = item.link else { return }
            self?.viewModel.openLink(urlString: link)
        }
        cell.deleteImageView.onTap(disposeBag: disposeBag) { [weak self] in
            self?.viewModel.removeRSSItem(item)
        }
    }
    
}
