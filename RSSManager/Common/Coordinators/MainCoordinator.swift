//
//  MainCoordinator.swift
//  RSSManager
//
//  Created by Marko Matijević on 09.12.2023..
//

import UIKit
import Swinject
import FirebaseAuth

class MainCoordinator: CoordinatorProtocol {
    
    var childCoordinators = [CoordinatorProtocol]()
    weak var navigationController: UINavigationController?
    weak var currentViewController: UIViewController?
    private let window: UIWindow
    var shouldEnd: () -> () = {}
    
    private let authService: AuthServiceProtocol

    init(in window: UIWindow, authService: AuthServiceProtocol = Assembler.sharedAssembler.resolver.resolve(AuthServiceProtocol.self)!) {
        self.window = window
        self.authService = authService
    }
    
    func start() {
        if authService.isUserLoggedIn() {
            startHomeCoordinator()
        } else {
            startAuthorizationCoordinator()
        }
    }
    
    func startHomeCoordinator() {
        let navController = UINavigationController()
        let homeCoordinator = HomeCoordinator(in: self.window, navigationController: navController)
        homeCoordinator.shouldEnd = { [weak self] in
            self?.startAuthorizationCoordinator()
        }
        self.childCoordinators.removeAll()
        self.childCoordinators.append(homeCoordinator)
        self.window.rootViewController = navController
        homeCoordinator.start()
    }
    
    func startAuthorizationCoordinator() {
        let navController = UINavigationController()
        let authorizationsCoordinator = AuthorizationCoordinator(in: self.window, navigationController: navController)
        authorizationsCoordinator.shouldEnd = { [weak self] in
            self?.startHomeCoordinator()
        }
        self.childCoordinators.removeAll()
        self.childCoordinators.append(authorizationsCoordinator)
        window.rootViewController = navController
        authorizationsCoordinator.start()
    }
    
}

