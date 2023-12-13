//
//  BackgroundService.swift
//  RSSManager
//
//  Created by Marko Matijević on 13.12.2023..
//

import Foundation
import BackgroundTasks
import RxSwift

protocol BackgroundServiceProtocol {
    func scheduleBackgroundTask(_ taskCompleted: @escaping (Bool) -> Void)
}

class BackgroundService {
    
    private let xmlParserService: XMLParserServiceProtocol
    private let rssChannelService: RSSChannelServiceProtocol
    private let disposeBag = DisposeBag()
    
    init(xmlParserService: XMLParserServiceProtocol, rssChannelService: RSSChannelServiceProtocol) {
        self.xmlParserService = xmlParserService
        self.rssChannelService = rssChannelService
    }
    
    func checkForUpdates(_ taskCompleted: @escaping (Bool) -> Void) {
        var favourites: [RSSChannel] = []
        rssChannelService.fetchFavouriteChannels(with: nil)
            .flatMap { [unowned self] channels -> Observable<[RSSChannel]> in
                favourites = channels
                return self.xmlParserService.parseXML(urlStrings: channels.map{$0.url ?? ""}, limit: 1)
            }
            .subscribe(onNext: { channels in
                var shouldUpdate: Bool = false
                for i in 0..<favourites.count {
                    if favourites[i].pubDate.isEmptyOrNull() { continue }
                    if favourites[i].pubDate != channels[i].pubDate {
                        shouldUpdate = true
                        break
                    }
                }
                taskCompleted(shouldUpdate)
            }).disposed(by: disposeBag)
    }
}

extension BackgroundService: BackgroundServiceProtocol {
    func scheduleBackgroundTask(_ taskCompleted: @escaping (Bool) -> Void) {
        let backgroundTaskScheduler = BGTaskScheduler.shared
        let identifier = "com.rssmanager.fetchDataTask"
        backgroundTaskScheduler.register(forTaskWithIdentifier: identifier, using: nil) { [weak self] task in
            self?.checkForUpdates(taskCompleted)
            task.setTaskCompleted(success: true)
        }
        let request = BGAppRefreshTaskRequest(identifier: identifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 60 * 6)
        do {
            try backgroundTaskScheduler.submit(request)
        } catch {
            print(error.localizedDescription)
        }
    }
}
