//
//  HomeViewModel.swift
//  RSSManager
//
//  Created by Marko Matijević on 08.12.2023..
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeViewModelProtocol: ViewModelProtocol {
    
}

class HomeViewModel: BaseViewModel {
    
    // MARK: - Private properties
    private let xmlParserService: XMLParserServiceProtocol
    
    init(xmlParserService: XMLParserServiceProtocol) {
        self.xmlParserService = xmlParserService
        super.init()
//        let url = "https://podcastfeeds.nbcnews.com/HL4TzgYC"
//        xmlParserService.parseXML(urlString: url, limit: 20).subscribe(onNext: { channel in
//            print(channel)
//        }).disposed(by: disposeBag)
    }
    
}

extension HomeViewModel: HomeViewModelProtocol {
    
}
