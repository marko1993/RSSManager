//
//  RSSService.swift
//  RSSManager
//
//  Created by Marko Matijević on 11.12.2023..
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import RxSwift

protocol RSSServiceProtocol {
    func saveChannel(_ channel: RSSChannel) -> Observable<RSSChannel>
    func saveChannelItems(_ channel: RSSChannel) -> Observable<RSSChannel>
    func fetchChannels() -> Observable<[RSSChannel]>
    func setIsChannelFavourite(_ channel: RSSChannel, isFavourite: Bool) -> Observable<RSSChannel>
    func deleteChannel(_ channel: RSSChannel) -> Observable<Bool>
    func fetchFavouriteChannels(with query: String?) -> Observable<[RSSChannel]>
}

class RSSService {
    private let rssFeedCollection: CollectionReference = Firestore.firestore().collection(K.Networking.Collections.RSSFeed)
    private let rssItemCollection: CollectionReference = Firestore.firestore().collection(K.Networking.Collections.RSSItems)
}

extension RSSService: RSSServiceProtocol {
    func fetchFavouriteChannels(with queryString: String?) -> Observable<[RSSChannel]> {
        return Observable.create { observer in
            self.rssFeedCollection
                .whereField("userId", isEqualTo: Auth.auth().currentUser?.uid ?? "")
                .whereField("isFavourite", isEqualTo: true)
                .getDocuments { querySnapshot, error in
                    if let error = error {
                        observer.onError(error)
                    } else {
                        var channels: [RSSChannel] = []
                        for document in querySnapshot?.documents ?? [] {
                            let data = document.data()
                            guard let id = data["id"] as? String,
                                  let title = data["title"] as? String,
                                  let description = data["description"] as? String,
                                  let imageUrl = data["imageUrl"] as? String,
                                  let isFavourite = data["isFavourite"] as? Bool,
                                  let userId = data["userId"] as? String
                            else {
                                continue
                            }
                            let channel = RSSChannel(id: id, title: title, description: description, imageUrl: imageUrl, userId: userId, isFavourite: isFavourite)
                            channels.append(channel)
                        }
                        if let queryString = queryString {
                            observer.onNext(channels.filter{$0.title!.lowercased().contains(queryString.lowercased())})
                        } else {
                            observer.onNext(channels)
                        }
                        observer.onCompleted()
                    }
                }
            return Disposables.create()
        }.observe(on: MainScheduler.instance)
    }
    
    func deleteChannel(_ channel: RSSChannel) -> Observable<Bool> {
        return Observable.create { observer in
            self.rssFeedCollection.document(channel.id)
                .delete { error in
                    if let error = error {
                        observer.onError(error)
                    } else {
                        observer.onNext(true)
                        observer.onCompleted()
                    }
                }
            return Disposables.create()
        }.observe(on: MainScheduler.instance)
    }
    
    func setIsChannelFavourite(_ channel: RSSChannel, isFavourite: Bool) -> Observable<RSSChannel> {
        return Observable.create { observer in
            self.rssFeedCollection.document(channel.id)
                .updateData(["isFavourite": isFavourite]) { error in
                    if let error = error {
                        observer.onError(error)
                    } else {
                        observer.onNext(channel)
                        observer.onCompleted()
                    }
                }
            return Disposables.create()
        }.observe(on: MainScheduler.instance)
    }
    
    func fetchChannels() -> Observable<[RSSChannel]> {
        return Observable.create { observer in
            self.rssFeedCollection
                .whereField("userId", isEqualTo: Auth.auth().currentUser?.uid ?? "")
                .getDocuments { querySnapshot, error in
                    if let error = error {
                        observer.onError(error)
                    } else {
                        var channels: [RSSChannel] = []
                        for document in querySnapshot?.documents ?? [] {
                            let data = document.data()
                            guard let id = data["id"] as? String,
                                  let title = data["title"] as? String,
                                  let description = data["description"] as? String,
                                  let imageUrl = data["imageUrl"] as? String,
                                  let isFavourite = data["isFavourite"] as? Bool,
                                  let userId = data["userId"] as? String
                            else {
                                continue
                            }
                            let channel = RSSChannel(id: id, title: title, description: description, imageUrl: imageUrl, userId: userId, isFavourite: isFavourite)
                            channels.append(channel)
                        }
                        observer.onNext(channels)
                        observer.onCompleted()
                    }
                }
            return Disposables.create()
        }.observe(on: MainScheduler.instance)
    }
    
    func saveChannel(_ channel: RSSChannel) -> Observable<RSSChannel> {
        return Observable.create { observer in
            let userRef = self.rssFeedCollection.document(channel.id)
            userRef.setData(["id": channel.id,
                             "title": channel.title ?? "",
                             "description": channel.description ?? "",
                             "imageUrl": channel.imageUrl ?? "",
                             "isFavourite": channel.isFavourite,
                             "userId": Auth.auth().currentUser?.uid ?? ""]) {  error in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(channel)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }.observe(on: MainScheduler.instance)
    }
    
    func saveChannelItems(_ channel: RSSChannel) -> Observable<RSSChannel> {
        return Observable.create { observer in
            for item in channel.items {
                let itemData: [String: Any] = ["id": item.id,
                                               "title": item.title ?? "",
                                               "description": item.description ?? "",
                                               "imageUrl": item.imageUrl ?? "",
                                               "channelId": item.channelId ?? ""]
                self.rssItemCollection.document(item.id).setData(itemData) { error in
                    if let error = error {
                        observer.onError(error)
                    }
                }
            }
            observer.onNext(channel)
            observer.onCompleted()
            return Disposables.create()
        }.observe(on: MainScheduler.instance)
    }
    
}
