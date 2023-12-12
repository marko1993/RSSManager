//
//  LikedViewModel.swift
//  RSSManager
//
//  Created by Marko Matijević on 09.12.2023..
//

import Foundation
import RxSwift
import RxCocoa

protocol LikedViewModelProtocol: ViewModelProtocol {
    var rssItemsDriver: Driver<[RSSItem]> { get }
    
    func filterRSSItems(query: String?)
    func openLink(urlString: String)
    func removeRSSItem(_ item: RSSItem)
}

class LikedViewModel: BaseViewModel {
    
    // MARK: - Private properties
    private let rssItemService: RSSItemServiceProtocol
    private let itemsRelay: BehaviorRelay<[RSSItem]> = .init(value: [])
    
    init(rssItemService: RSSItemServiceProtocol) {
        self.rssItemService = rssItemService
        super.init()
    }
    
}

extension LikedViewModel: LikedViewModelProtocol {
    var rssItemsDriver: Driver<[RSSItem]> {
        itemsRelay.asDriver()
    }
    
    func removeRSSItem(_ item: RSSItem) {
        networkRequestState.accept(.started)
        rssItemService.deleteRSSItem(item)
            .flatMap { [unowned self] _ -> Observable<[RSSItem]> in
                return self.rssItemService.fetchRSSItems(with: nil)
            }
            .subscribe(onNext: { [weak self] rssItems in
                self?.itemsRelay.accept(rssItems)
            }, onError: { [weak self] error in
                self?.errorMessage.accept(error.localizedDescription)
            }, onDisposed: { [weak self] in
                self?.networkRequestState.accept(.finished)
            }).disposed(by: disposeBag)
    }
    
    func openLink(urlString: String) {
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func filterRSSItems(query: String?) {
        networkRequestState.accept(.started)
        rssItemService.fetchRSSItems(with: query)
            .subscribe(onNext: { [weak self] rssItems in
                self?.itemsRelay.accept(rssItems)
            }, onError: { [weak self] error in
                self?.errorMessage.accept(error.localizedDescription)
            }, onDisposed: { [weak self] in
                self?.networkRequestState.accept(.finished)
            }).disposed(by: disposeBag)
    }
}
