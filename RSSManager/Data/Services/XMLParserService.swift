//
//  XMLParserService.swift
//  RSSManager
//
//  Created by Marko Matijević on 10.12.2023..
//

import Foundation
import RxSwift

protocol XMLParserServiceProtocol {
    func parseXML(urlString: String, limit: Int) -> Observable<RSSChannel>
    func parseXML(urlStrings: [String], limit: Int) -> Observable<[RSSChannel]>
}

class XMLParserService: XMLParserServiceProtocol {
    func parseXML(urlStrings: [String], limit: Int) -> Observable<[RSSChannel]> {
        let observables: [Observable<RSSChannel>] = urlStrings.map { urlString in
            return parseXML(urlString: urlString, limit: limit)
        }
        return Observable.zip(observables)
    }
    
    func parseXML(urlString: String, limit: Int) -> Observable<RSSChannel> {
        return Observable.create { observer in
            guard let url = URL(string: urlString) else {
                observer.onError(RxError.unknown)
                return Disposables.create()
            }
            let parserDelegate = RSSParserDelegate()
            DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: url)
                    parserDelegate.parseXML(data: data, limit: limit, urlString: urlString)
                    observer.onNext(parserDelegate.channel)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
        .observe(on: MainScheduler.instance)
    }
}
