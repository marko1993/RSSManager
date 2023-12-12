//
//  FavouritesViewController.swift
//  RSSManager
//
//  Created by Marko Matijević on 09.12.2023..
//

import UIKit
import RxSwift
import RxCocoa

class FavouritesViewController: BaseViewController {
    
    // MARK: - Coordinator methods
    var onChannelTap: (RSSChannel) -> () = { _ in }
    
    // MARK: - Private properties
    private var viewModel: FavouritesViewModelProtocol
    private var favouritesView: FavouritesView
    
    init(viewModel: FavouritesViewModelProtocol, favouritesView: FavouritesView = FavouritesView()) {
        self.viewModel = viewModel
        self.favouritesView = favouritesView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView(favouritesView)
        setupBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getFavouriteRSSChannels()
    }
    
    private func setupBinding() {
        bind(requestState: self.viewModel.networkRequestStateObservable)
        bind(errorMessage: self.viewModel.errorMessageObservable)
        
        viewModel.channelsDriver
            .drive(onNext: { [weak self] channels in
                self?.favouritesView.channelsCollectionView.isHidden = channels.count == 0
                self?.favouritesView.emptyContentView.isHidden = channels.count > 0
            }).disposed(by: disposeBag)
        
        favouritesView.searchBar.inputTextField
            .rx.controlEvent([.editingChanged])
            .asObservable()
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let query = self?.favouritesView.searchBar.getText() else { return }
                self?.viewModel.filterFavourites(query: query)
            }).disposed(by: disposeBag)

        favouritesView.channelsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.channelsDriver
            .drive(favouritesView.channelsCollectionView
                .rx.items(cellIdentifier: FavouriteChannelCell.cellIdentifier, cellType: FavouriteChannelCell.self)) { [unowned self] (_, channel, cell) in
                    cell.configure(with: channel)
                    cell.onTap(disposeBag: self.disposeBag) { [weak self] in
                        self?.onChannelTap(channel)
                    }
            }
            .disposed(by: disposeBag)
    }
    
}

// MARK: - UICollectionView methods
extension FavouritesViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.bounds.width - 32) / 2
        return CGSize(width: cellWidth, height: RSSChannelCell.rowHeight)
    }
}
