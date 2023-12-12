//
//  RSSItemService.swift
//  RSSManager
//
//  Created by Marko Matijević on 12.12.2023..
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import RxSwift

protocol RSSItemServiceProtocol {
    func saveRSSItem(_ item: RSSItem) -> Observable<RSSItem>
    func fetchRSSItems(with queryString: String?) -> Observable<[RSSItem]>
    func deleteRSSItem(_ item: RSSItem) -> Observable<Bool>
}

class RSSItemService {
    private let rssItemCollection: CollectionReference = Firestore.firestore().collection(K.Networking.Collections.RSSItems)
}

extension RSSItemService: RSSItemServiceProtocol {
    func saveRSSItem(_ item: RSSItem) -> Observable<RSSItem> {
        return Observable.create { observer in
            let itemData: [String: Any] = ["id": item.id,
                                           "link": item.link ?? "",
                                           "title": item.title ?? "",
                                           "description": item.description ?? "",
                                           "imageUrl": item.imageUrl ?? "",
                                           "userId": Auth.auth().currentUser?.uid ?? "",
                                           "isLiked": true,
                                           "pubDate": item.pubDate ?? ""]
            self.rssItemCollection.document(item.id).setData(itemData) { error in
                if let error = error {
                    observer.onError(error)
                }
            }
            observer.onNext(item)
            observer.onCompleted()
            return Disposables.create()
        }.observe(on: MainScheduler.instance)
    }
    
    func fetchRSSItems(with queryString: String?) -> Observable<[RSSItem]> {
        return Observable.create { observer in
            self.rssItemCollection
                .whereField("userId", isEqualTo: Auth.auth().currentUser?.uid ?? "")
                .getDocuments { querySnapshot, error in
                    if let error = error {
                        observer.onError(error)
                    } else {
                        var items: [RSSItem] = []
                        for document in querySnapshot?.documents ?? [] {
                            let data = document.data()
                            guard let id = data["id"] as? String,
                                  let link = data["link"] as? String,
                                  let title = data["title"] as? String,
                                  let description = data["description"] as? String,
                                  let imageUrl = data["imageUrl"] as? String,
                                  let userId = data["userId"] as? String,
                                  let isLiked = data["isLiked"] as? Bool,
                                  let pubDate = data["pubDate"] as? String
                            else {
                                continue
                            }
                            let item = RSSItem(id: id, link: link, title: title, description: description, imageUrl: imageUrl, userId: userId, pubDate: pubDate, isLiked: isLiked)
                            items.append(item)
                        }
                        if let queryString = queryString {
                            observer.onNext(items.filter{$0.title!.lowercased().contains(queryString.lowercased())})
                        } else {
                            observer.onNext(items)
                        }
                        observer.onCompleted()
                    }
                }
            return Disposables.create()
        }.observe(on: MainScheduler.instance)
    }
    
    func deleteRSSItem(_ item: RSSItem) -> Observable<Bool> {
        return Observable.create { observer in
            self.rssItemCollection.document(item.id)
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
    
}
