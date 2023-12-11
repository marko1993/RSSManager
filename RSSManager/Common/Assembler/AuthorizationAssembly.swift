//
//  AuthorizationAssembly.swift
//  RSSManager
//
//  Created by Marko Matijević on 09.12.2023..
//

import Foundation
import Swinject

final class AuthorizationAssembly: Assembly {
    
    func assemble(container: Container) {
        self.assembleLoginViewController(container)
        self.assembleRegisterViewController(container)
    }
    
    private func assembleRegisterViewController(_ container: Container) {
        container.register(RegisterViewModelProtocol.self) { r in
            return RegisterViewModel(authService: container.resolve(AuthServiceProtocol.self)!, userService: container.resolve(UserServiceProtocol.self)!)
        }.inObjectScope(.transient)
        
        container.register(RegisterViewController.self) { r in
            let controller = RegisterViewController(viewModel: container.resolve(RegisterViewModelProtocol.self)!)
            return controller
        }.inObjectScope(.transient)
    }
    
    private func assembleLoginViewController(_ container: Container) {
        container.register(LoginViewModelProtocol.self) { r in
            return LoginViewModel(authService: container.resolve(AuthServiceProtocol.self)!, userService: container.resolve(UserServiceProtocol.self)!)
        }.inObjectScope(.transient)
        
        container.register(LoginViewController.self) { r in
            let controller = LoginViewController(viewModel: container.resolve(LoginViewModelProtocol.self)!)
            return controller
        }.inObjectScope(.transient)
    }
    
}
