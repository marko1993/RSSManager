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

protocol RSSChannelServiceProtocol {
    func saveChannel(_ channel: RSSChannel) -> Observable<RSSChannel>
    func fetchChannels() -> Observable<[RSSChannel]>
    func setIsChannelFavourite(_ channel: RSSChannel, isFavourite: Bool) -> Observable<RSSChannel>
    func setNewPubDate(_ channel: RSSChannel, pubDate: String) -> Observable<RSSChannel>
    func deleteChannel(_ channel: RSSChannel) -> Observable<Bool>
    func fetchFavouriteChannels(with query: String?) -> Observable<[RSSChannel]>
}

class RSSChannelService {
    private let rssFeedCollection: CollectionReference = Firestore.firestore().collection(K.Networking.Collections.RSSFeed)
}

extension RSSChannelService: RSSChannelServiceProtocol {
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
                                  let urlString = data["url"] as? String,
                                  let pubDate = data["pubDate"] as? String,
                                  let userId = data["userId"] as? String
                            else {
                                continue
                            }
                            let channel = RSSChannel(id: id, title: title, description: description, imageUrl: imageUrl, userId: userId, url: urlString, pubDate: pubDate, isFavourite: isFavourite)
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
    
    func setNewPubDate(_ channel: RSSChannel, pubDate: String) -> Observable<RSSChannel> {
        return Observable.create { observer in
            self.rssFeedCollection.document(channel.id)
                .updateData(["pubDate": pubDate]) { error in
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
                                  let urlString = data["url"] as? String,
                                  let pubDate = data["pubDate"] as? String,
                                  let userId = data["userId"] as? String
                            else {
                                continue
                            }
                            let channel = RSSChannel(id: id, title: title, description: description, imageUrl: imageUrl, userId: userId, url: urlString, pubDate: pubDate, isFavourite: isFavourite)
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
                             "url": channel.url ?? "",
                             "pubDate": channel.pubDate ?? "",
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
    
}
