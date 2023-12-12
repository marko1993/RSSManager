//
//  HomeCoordinator.swift
//  RSSManager
//
//  Created by Marko Matijević on 08.12.2023..
//

import UIKit
import Swinject

class HomeCoordinator: CoordinatorProtocol {
    
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
        self.presentHomeScreen()
    }
    
    func presentHomeScreen() {
        let viewController = Assembler.sharedAssembler.resolver.resolve(HomeViewController.self, argument: getTabBarItems())!
        self.currentViewController = viewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentRSSItemsScreen(channel: RSSChannel) {
        let viewController = Assembler.sharedAssembler.resolver.resolve(RSSItemsViewController.self, argument: channel)!
        self.currentViewController = viewController
        self.navigationController?.present(viewController, animated: true)
    }
    
    private func createRSSFeedTabBarItem() -> TabBarItem {
        let viewController = Assembler.sharedAssembler.resolver.resolve(RSSFeedViewController.self)!
        
        viewController.onChannelTap = { [weak self] channel in
            self?.presentRSSItemsScreen(channel: channel)
        }
        
        return TabBarItem(viewController: viewController, title: K.Strings.rssFeed, image: "newspaper", position: 0, isSelected: true)
    }
    
    private func createFavouritesTabBarItem() -> TabBarItem {
        let viewController = Assembler.sharedAssembler.resolver.resolve(FavouritesViewController.self)!
        
        viewController.onChannelTap = { [weak self] channel in
            self?.presentRSSItemsScreen(channel: channel)
        }
        
        return TabBarItem(viewController: viewController, title: K.Strings.favourites, image: "star", position: 1, isSelected: false)
    }
    
    private func createLikedTabBarItem() -> TabBarItem {
        let viewController = Assembler.sharedAssembler.resolver.resolve(LikedViewController.self)!
        return TabBarItem(viewController: viewController, title: K.Strings.liked, image: "hand.thumbsup", position: 2, isSelected: false)
    }
    
    private func createOptionsTabBarItem() -> TabBarItem {
        let viewController = Assembler.sharedAssembler.resolver.resolve(OptionsViewController.self)!
        
        viewController.didLogOut = { [weak self] in
            self?.shouldEnd()
        }
        
        return TabBarItem(viewController: viewController, title: K.Strings.options, image: "gear", position: 3, isSelected: false)
    }
    
    private func getTabBarItems() -> [TabBarItem] {
        return [
            createRSSFeedTabBarItem(),
            createFavouritesTabBarItem(),
            createLikedTabBarItem(),
            createOptionsTabBarItem(),
        ]
    }
    
}
