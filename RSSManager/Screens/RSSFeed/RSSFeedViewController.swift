//
//  RSSFeedViewController.swift
//  RSSManager
//
//  Created by Marko Matijević on 09.12.2023..
//

import UIKit

class RSSFeedViewController: BaseViewController {
    
    // MARK: - Coordinator methods
    var onChannelTap: (RSSChannel) -> () = { _ in }
    
    // MARK: - Private properties
    private var viewModel: RSSFeedViewModelProtocol
    private var rssFeedView: RSSFeedView
    
    init(viewModel: RSSFeedViewModelProtocol, rssFeedView: RSSFeedView = RSSFeedView()) {
        self.viewModel = viewModel
        self.rssFeedView = rssFeedView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView(rssFeedView)
        setupBinding()
        viewModel.getRSSChannels()
    }
    
    private func setupBinding() {
        bind(requestState: self.viewModel.networkRequestStateObservable)
        bind(errorMessage: self.viewModel.errorMessageObservable)
        
        viewModel.channelsDriver
            .drive(onNext: { [weak self] channels in
                self?.rssFeedView.channelsCollectionView.isHidden = channels.count == 0
                self?.rssFeedView.emptyContentView.isHidden = channels.count > 0
            }).disposed(by: disposeBag)
        
        rssFeedView.addButton.onTap(disposeBag: disposeBag) { [weak self] in
            guard let url = self?.rssFeedView.searchBar.getText() else { return }
            self?.viewModel.addRSSFeed(urlString: url)
            self?.rssFeedView.searchBar.clearText()
        }
        
        rssFeedView.channelsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        viewModel.channelsDriver
            .drive(rssFeedView.channelsCollectionView
                .rx.items(cellIdentifier: RSSChannelCell.cellIdentifier, cellType: RSSChannelCell.self)) { [weak self] (_, channel, cell) in
                    cell.configure(with: channel)
                    self?.setupCellBindings(cell, channel: channel)
            }
            .disposed(by: disposeBag)
    }
    
    private func setupCellBindings(_ cell: RSSChannelCell, channel: RSSChannel) {
        cell.onTap(disposeBag: self.disposeBag) { [weak self] in
            self?.onChannelTap(channel)
        }
        cell.favouriteImageView.onTap(disposeBag: disposeBag) { [weak self] in
            self?.viewModel.toogleChannelIsFavourite(channel)
        }
        cell.deleteImageView.onTap(disposeBag: disposeBag) { [weak self] in
            self?.viewModel.deleteChannel(channel)
        }
    }
    
}

// MARK: - UICollectionView methods
extension RSSFeedViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.bounds.width - 32) / 2
        return CGSize(width: cellWidth, height: RSSChannelCell.rowHeight)
    }
}
