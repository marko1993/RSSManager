//
//  LoginViewModel.swift
//  RSSManager
//
//  Created by Marko Matijević on 09.12.2023..
//

import Foundation
import RxSwift
import RxCocoa

protocol LoginViewModelProtocol: ViewModelProtocol {
    var onLoginSuccessDriver: Driver<Bool> { get }
    
    func logIn(email: String, password: String)
}

class LoginViewModel: BaseViewModel {
    
    // MARK: - Private properties
    private let authService: AuthServiceProtocol
    private let userService: UserServiceProtocol
    private let onLoginSuccessRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    init(authService: AuthServiceProtocol, userService: UserServiceProtocol) {
        self.authService = authService
        self.userService = userService
        super.init()
    }
    
}

extension LoginViewModel: LoginViewModelProtocol {
    var onLoginSuccessDriver: Driver<Bool> {
        onLoginSuccessRelay.asDriver()
    }
    
    func logIn(email: String, password: String) {
        networkRequestState.accept(.started)
        authService.signIn(email: email, password: password)
            .flatMap { userId -> Observable<Bool> in
                return self.userService.fetchUserData(id: userId)
            }
            .subscribe(onNext: { [weak self] isSuccessfull in
                self?.onLoginSuccessRelay.accept(isSuccessfull)
            }, onError: { [weak self] error in
                self?.errorMessage.accept(error.localizedDescription)
            }, onDisposed: { [weak self] in
                self?.networkRequestState.accept(.finished)
            }).disposed(by: disposeBag)
    }
}

