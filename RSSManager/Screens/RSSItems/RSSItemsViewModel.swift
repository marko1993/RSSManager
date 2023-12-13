//
//  RSSItemsViewModel.swift
//  RSSManager
//
//  Created by Marko Matijević on 11.12.2023..
//

import Foundation
import RxSwift
import RxCocoa

protocol RSSItemsViewModelProtocol: ViewModelProtocol {
    var rssItemsDriver: Driver<[RSSItem]> { get }
    
    func getRSSItems()
    func openLink(urlString: String)
    func likeRSSItem(_ item: RSSItem)
}

class RSSItemsViewModel: BaseViewModel {
    
    // MARK: - Private properties
    private let rssItemService: RSSItemServiceProtocol
    private let rssChannelService: RSSChannelServiceProtocol
    private let xmlParserService: XMLParserServiceProtocol
    private var channel: RSSChannel
    private let itemsRelay: BehaviorRelay<[RSSItem]> = .init(value: [])
    
    init(channel: RSSChannel, rssItemService: RSSItemServiceProtocol, xmlParserService: XMLParserServiceProtocol, rssChannelService: RSSChannelServiceProtocol) {
        self.rssItemService = rssItemService
        self.xmlParserService = xmlParserService
        self.rssChannelService = rssChannelService
        self.channel = channel
        super.init()
    }
    
    private func saveRSSItem(_ item: RSSItem) {
        networkRequestState.accept(.started)
        rssItemService.saveRSSItem(item)
            .subscribe(onNext: { [weak self] item in
                guard var items = self?.itemsRelay.value else { return }
                if let row = items.firstIndex(where: {$0.id == item.id}) {
                    items[row].isLiked = true
                }
                self?.itemsRelay.accept(items)
            }, onError: { [weak self] error in
                self?.errorMessage.accept(error.localizedDescription)
            }, onDisposed: { [weak self] in
                self?.networkRequestState.accept(.finished)
            }).disposed(by: disposeBag)
    }
    
}

extension RSSItemsViewModel: RSSItemsViewModelProtocol {
    var rssItemsDriver: Driver<[RSSItem]> {
        itemsRelay.asDriver()
    }
    
    func likeRSSItem(_ item: RSSItem) {
        if !item.isLiked {
            saveRSSItem(item)
        }
    }
    
    func openLink(urlString: String) {
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func getRSSItems() {
        guard let urlString = channel.url else { return }
        networkRequestState.accept(.started)
        xmlParserService.parseXML(urlString: urlString, limit: 20)
            .flatMap { [unowned self] channel -> Observable<RSSChannel> in
                self.channel.items = channel.items
                self.channel.pubDate = channel.pubDate
                return self.rssChannelService.setNewPubDate(self.channel, pubDate: channel.pubDate ?? "")
            }
            .flatMap { [unowned self] channel -> Observable<[RSSItem]> in
                self.channel.items = channel.items
                return self.rssItemService.fetchRSSItems(with: nil)
            }
            .subscribe(onNext: { [weak self] likedItems in
                guard var items = self?.channel.items else { return }
                let likedTitles = likedItems.map { $0.title }
                likedTitles.forEach { title in
                    if let row = items.firstIndex(where: {$0.title == title}) {
                        items[row].isLiked = true
                    }
                }
                self?.itemsRelay.accept(items)
            }, onError: { [weak self] error in
                self?.errorMessage.accept(error.localizedDescription)
            }, onDisposed: { [weak self] in
                self?.networkRequestState.accept(.finished)
            }).disposed(by: disposeBag)
    }
    
}

