//
//  RegisterViewModel.swift
//  RSSManager
//
//  Created by Marko Matijević on 09.12.2023..
//

import Foundation
import RxSwift
import RxCocoa

protocol RegisterViewModelProtocol: ViewModelProtocol {
    var onRegisterSuccessDriver: Driver<Bool> { get }
    
    func register(name: String, email: String, password: String)
}

class RegisterViewModel: BaseViewModel {
    
    // MARK: - Private properties
    private let authService: AuthServiceProtocol
    private let userService: UserServiceProtocol
    private let onRegisterSuccessRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    init(authService: AuthServiceProtocol, userService: UserServiceProtocol) {
        self.authService = authService
        self.userService = userService
        super.init()
    }
    
}

extension RegisterViewModel: RegisterViewModelProtocol {
    var onRegisterSuccessDriver: Driver<Bool> {
        return onRegisterSuccessRelay.asDriver()
    }
    
    func register(name: String, email: String, password: String) {
        networkRequestState.accept(.started)
        authService.register(name: name, email: email, password: password)
            .flatMap { [unowned self] user -> Observable<User> in
                return self.userService.saveUser(user)
            }
            .subscribe(onNext: { [weak self] user in
                self?.onRegisterSuccessRelay.accept(true)
            }, onError: { [weak self] error in
                self?.errorMessage.accept(error.localizedDescription)
            }, onDisposed: { [weak self] in
                self?.networkRequestState.accept(.finished)
            }).disposed(by: disposeBag)
    }
    
}

