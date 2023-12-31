//
//  OptionsViewModel.swift
//  RSSManager
//
//  Created by Marko Matijević on 09.12.2023..
//

import Foundation
import RxSwift
import RxCocoa

protocol OptionsViewModelProtocol: ViewModelProtocol {
    var onLogOutSuccessDriver: Driver<Bool> { get }
    func logOut()
    func enableNotifications(_ shouldEnable: Bool)
    func areNotificationsEnabled() -> Bool
}

class OptionsViewModel: BaseViewModel {
    
    // MARK: - Private properties
    private let authService: AuthServiceProtocol
    private let userService: UserServiceProtocol
    private let userDefaultsService: UserDefaultsServiceProtocol
    private let onLogOutSuccessRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    init(authService: AuthServiceProtocol, userService: UserServiceProtocol, userDefaultsService: UserDefaultsServiceProtocol) {
        self.authService = authService
        self.userService = userService
        self.userDefaultsService = userDefaultsService
        super.init()
    }
    
}

extension OptionsViewModel: OptionsViewModelProtocol {
    var onLogOutSuccessDriver: Driver<Bool> {
        return onLogOutSuccessRelay.asDriver()
    }
    
    func logOut() {
        networkRequestState.accept(.started)
        authService.logUserOut()
            .subscribe { [weak self] isSuccessfull in
                self?.networkRequestState.accept(.finished)
                if isSuccessfull {
                    self?.userService.clearCurrentUser()
                    self?.onLogOutSuccessRelay.accept(true)
                }
            } onError: { [weak self] error in
                self?.networkRequestState.accept(.finished)
                self?.errorMessage.accept(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    func enableNotifications(_ shouldEnable: Bool) {
        userDefaultsService.setNotificationsEnabled(shouldEnable)
    }
    
    func areNotificationsEnabled() -> Bool {
        return userDefaultsService.areNotificationsEnabled()
    }

}
