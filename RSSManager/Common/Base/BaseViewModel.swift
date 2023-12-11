//
//  BaseViewModel.swift
//  RSSManager
//
//  Created by Marko Matijević on 08.12.2023..
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelProtocol {
    var networkRequestStateObservable: Observable<NetworkRequestState> { get }
    var errorMessageObservable: Observable<String?> { get }
}

class BaseViewModel {
    
    let disposeBag = DisposeBag()
    
    let networkRequestState : BehaviorRelay<NetworkRequestState> = BehaviorRelay(value: .finished)
    let errorMessage : BehaviorRelay<String?> = BehaviorRelay(value: nil)
    
}

extension BaseViewModel: ViewModelProtocol {
    var networkRequestStateObservable: Observable<NetworkRequestState> {
        return networkRequestState.asObservable()
    }
    
    var errorMessageObservable: Observable<String?> {
        return errorMessage.asObservable()
    }
    
    
}

