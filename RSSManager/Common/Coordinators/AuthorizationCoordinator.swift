//
//  AuthorizationCoordinator.swift
//  RSSManager
//
//  Created by Marko Matijević on 09.12.2023..
//

import UIKit
import Swinject

class AuthorizationCoordinator: CoordinatorProtocol {
    
    var childCoordinators = [CoordinatorProtocol]()
    weak var navigationController: UINavigationController?
    weak var currentViewController: UIViewController?
    private let window: UIWindow
    
    var shouldEnd: () -> () = {}

    init(in window: UIWindow, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.window = window
    }
    
    func start() {
        self.presentLoginScreen()
    }
    
    func presentLoginScreen() {
        let viewController = Assembler.sharedAssembler.resolver.resolve(LoginViewController.self)!
        viewController.didTapRegister = { [weak self] in
            self?.presentRegisterScreen()
        }
        viewController.didSignIn = { [weak self] in
            self?.shouldEnd()
        }
        self.currentViewController = viewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func presentRegisterScreen() {
        let viewController = Assembler.sharedAssembler.resolver.resolve(RegisterViewController.self)!
        viewController.didRegister = { [weak self] in
            self?.shouldEnd()
        }
        self.currentViewController = viewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
