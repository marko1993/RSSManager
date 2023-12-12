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
    }
    
}

extension HomeViewModel: HomeViewModelProtocol {
    
}
