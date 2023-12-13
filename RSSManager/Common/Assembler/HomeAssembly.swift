//
//  HomeAssembly.swift
//  RSSManager
//
//  Created by Marko Matijević on 08.12.2023..
//

import Foundation
import Swinject

final class HomeAssembly: Assembly {
    
    func assemble(container: Container) {
        self.assembleRSSFeedViewController(container)
        self.assembleFavouritesViewController(container)
        self.assembleLikedViewController(container)
        self.assembleOptionsViewController(container)
        self.assembleHomeViewController(container)
        self.assembleRSSItemsViewController(container)
    }
    
    private func assembleRSSItemsViewController(_ container: Container) {
        container.register(RSSItemsViewModelProtocol.self) { (resolver, channel: RSSChannel) in
            return RSSItemsViewModel(channel: channel, rssItemService: container.resolve(RSSItemServiceProtocol.self)!, xmlParserService: container.resolve(XMLParserServiceProtocol.self)!, rssChannelService: container.resolve(RSSChannelServiceProtocol.self)!)
        }.inObjectScope(.transient)
        
        container.register(RSSItemsViewController.self) { (resolver, channel: RSSChannel) in
            let controller = RSSItemsViewController(viewModel: container.resolve(RSSItemsViewModelProtocol.self, argument: channel)!)
            return controller
        }.inObjectScope(.transient)
    }
    
    private func assembleHomeViewController(_ container: Container) {
        container.register(HomeViewModelProtocol.self) { r in
            return HomeViewModel(xmlParserService: container.resolve(XMLParserServiceProtocol.self)!)
        }.inObjectScope(.transient)
        
        container.register(HomeViewController.self) { (resolver, tabBarItems: [TabBarItem]) in
            let controller = HomeViewController(viewModel: container.resolve(HomeViewModelProtocol.self), tabBarItems: tabBarItems)
            return controller
        }.inObjectScope(.transient)
    }
    
    private func assembleRSSFeedViewController(_ container: Container) {
        container.register(RSSFeedViewModelProtocol.self) { r in
            return RSSFeedViewModel(xmlParserService: container.resolve(XMLParserServiceProtocol.self)!, rssChannelService: container.resolve(RSSChannelServiceProtocol.self)!)
        }.inObjectScope(.transient)
        
        container.register(RSSFeedViewController.self) { r in
            let controller = RSSFeedViewController(viewModel: container.resolve(RSSFeedViewModelProtocol.self)!)
            return controller
        }.inObjectScope(.transient)
    }
    
    private func assembleFavouritesViewController(_ container: Container) {
        container.register(FavouritesViewModelProtocol.self) { r in
            return FavouritesViewModel(rssChannelService: container.resolve(RSSChannelServiceProtocol.self)!)
        }.inObjectScope(.transient)
        
        container.register(FavouritesViewController.self) { r in
            let controller = FavouritesViewController(viewModel: container.resolve(FavouritesViewModelProtocol.self)!)
            return controller
        }.inObjectScope(.transient)
    }
    
    private func assembleLikedViewController(_ container: Container) {
        container.register(LikedViewModelProtocol.self) { r in
            return LikedViewModel(rssItemService: container.resolve(RSSItemServiceProtocol.self)!)
        }.inObjectScope(.transient)
        
        container.register(LikedViewController.self) { r in
            let controller = LikedViewController(viewModel: container.resolve(LikedViewModelProtocol.self)!)
            return controller
        }.inObjectScope(.transient)
    }
    
    private func assembleOptionsViewController(_ container: Container) {
        container.register(OptionsViewModelProtocol.self) { r in
            return OptionsViewModel(authService: container.resolve(AuthServiceProtocol.self)!, userService: container.resolve(UserServiceProtocol.self)!, userDefaultsService: container.resolve(UserDefaultsServiceProtocol.self)!)
        }.inObjectScope(.transient)
        
        container.register(OptionsViewController.self) { r in
            let controller = OptionsViewController(viewModel: container.resolve(OptionsViewModelProtocol.self)!)
            return controller
        }.inObjectScope(.transient)
    }
    
}
