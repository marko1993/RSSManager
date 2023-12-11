//
//  RSSFeedViewModel.swift
//  RSSManager
//
//  Created by Marko Matijević on 09.12.2023..
//

import Foundation
import RxSwift
import RxCocoa

protocol RSSFeedViewModelProtocol: ViewModelProtocol {
    var channelsDriver: Driver<[RSSChannel]> { get }
    
    func addRSSFeed(urlString: String)
    func getRSSChannels()
    func toogleChannelIsFavourite(_ channel: RSSChannel)
    func deleteChannel(_ channel: RSSChannel)
}

class RSSFeedViewModel: BaseViewModel {
    
    // MARK: - Private properties
    private let xmlParserService: XMLParserServiceProtocol
    private let rssService: RSSServiceProtocol
    private let channelsRelay: BehaviorRelay<[RSSChannel]> = .init(value: [])
    
    init(xmlParserService: XMLParserServiceProtocol, rssService: RSSServiceProtocol) {
        self.xmlParserService = xmlParserService
        self.rssService = rssService
        super.init()
    }
    
    private func addChannel(_ channel: RSSChannel) {
        var channels = channelsRelay.value
        channels.append(channel)
        self.channelsRelay.accept(channels)
    }
    
}

extension RSSFeedViewModel: RSSFeedViewModelProtocol {
    var channelsDriver: Driver<[RSSChannel]> {
        return channelsRelay.asDriver()
    }
    
    func deleteChannel(_ channel: RSSChannel) {
        networkRequestState.accept(.started)
        rssService.deleteChannel(channel)
            .flatMap { [unowned self] isSuccess -> Observable<[RSSChannel]> in
                return self.rssService.fetchChannels()
            }
            .subscribe(onNext: { [weak self] channels in
                self?.channelsRelay.accept(channels)
            }, onError: { [weak self] error in
                self?.errorMessage.accept(error.localizedDescription)
            }, onDisposed: { [weak self] in
                self?.networkRequestState.accept(.finished)
            }).disposed(by: disposeBag)
    }
    
    func toogleChannelIsFavourite(_ channel: RSSChannel) {
        networkRequestState.accept(.started)
        rssService.setIsChannelFavourite(channel, isFavourite: !channel.isFavourite)
            .flatMap { [unowned self] channel -> Observable<[RSSChannel]> in
                return self.rssService.fetchChannels()
            }
            .subscribe(onNext: { [weak self] channels in
                self?.channelsRelay.accept(channels)
            }, onError: { [weak self] error in
                self?.errorMessage.accept(error.localizedDescription)
            }, onDisposed: { [weak self] in
                self?.networkRequestState.accept(.finished)
            }).disposed(by: disposeBag)
    }
    
    func getRSSChannels() {
        networkRequestState.accept(.started)
        rssService.fetchChannels()
            .subscribe(onNext: { [weak self] rssChannels in
                self?.channelsRelay.accept(rssChannels)
            }, onError: { [weak self] error in
                self?.errorMessage.accept(error.localizedDescription)
            }, onDisposed: { [weak self] in
                self?.networkRequestState.accept(.finished)
            }).disposed(by: disposeBag)
    }
    
    func addRSSFeed(urlString: String) {
        networkRequestState.accept(.started)
        xmlParserService.parseXML(urlString: urlString, limit: 20)
            .flatMap { [unowned self] channel -> Observable<RSSChannel> in
                return self.rssService.saveChannel(channel)
            }
            .flatMap { [unowned self] channel -> Observable<RSSChannel> in
                return self.rssService.saveChannelItems(channel)
            }
            .subscribe(onNext: { [weak self] channel in
                self?.addChannel(channel)
            }, onError: { [weak self] error in
                self?.errorMessage.accept(error.localizedDescription)
            }, onDisposed: { [weak self] in
                self?.networkRequestState.accept(.finished)
            }).disposed(by: disposeBag)
    }
    
}
