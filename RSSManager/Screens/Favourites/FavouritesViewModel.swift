//
//  FavouritesViewModel.swift
//  RSSManager
//
//  Created by Marko Matijević on 09.12.2023..
//

import Foundation
import RxSwift
import RxCocoa

protocol FavouritesViewModelProtocol: ViewModelProtocol {
    var channelsDriver: Driver<[RSSChannel]> { get }
    
    func getFavouriteRSSChannels()
    func filterFavourites(query: String)
}

class FavouritesViewModel: BaseViewModel {
    
    // MARK: - Private properties
    private let rssService: RSSServiceProtocol
    private let channelsRelay: BehaviorRelay<[RSSChannel]> = .init(value: [])
    
    init(rssService: RSSServiceProtocol) {
        self.rssService = rssService
        super.init()
    }
    
    private func getFavourites(query: String? = nil) {
        networkRequestState.accept(.started)
        rssService.fetchFavouriteChannels(with: query)
            .subscribe(onNext: { [weak self] rssChannels in
                self?.channelsRelay.accept(rssChannels)
            }, onError: { [weak self] error in
                self?.errorMessage.accept(error.localizedDescription)
            }, onDisposed: { [weak self] in
                self?.networkRequestState.accept(.finished)
            }).disposed(by: disposeBag)
    }
    
}

extension FavouritesViewModel: FavouritesViewModelProtocol {
    func filterFavourites(query: String) {
        getFavourites(query: query.isEmpty ? nil : query)
    }
    
    var channelsDriver: Driver<[RSSChannel]> {
        return channelsRelay.asDriver()
    }
    
    func getFavouriteRSSChannels() {
        getFavourites(query: nil)
    }
    
}
