//
//  ServiceAssembly.swift
//  RSSManager
//
//  Created by Marko Matijević on 10.12.2023..
//

import Foundation
import Swinject

final class ServiceAssembly: Assembly {
    
    func assemble(container: Container) {
        self.assembleAuthService(container)
        self.assembleUserService(container)
        self.assembleXMLParserService(container)
        self.assembleRSSChannelService(container)
        self.assembleRSSItemService(container)
        self.assembleNotificationService(container)
        self.assembleBackgroundService(container)
        self.assembleUserDefaultsService(container)
    }
    
    private func assembleAuthService(_ container: Container) {
        container.register(AuthServiceProtocol.self) { r in
            return AuthService()
        }.inObjectScope(.container)
    }
    
    private func assembleUserService(_ container: Container) {
        container.register(UserServiceProtocol.self) { r in
            return UserService()
        }.inObjectScope(.container)
    }
    
    private func assembleXMLParserService(_ container: Container) {
        container.register(XMLParserServiceProtocol.self) { r in
            return XMLParserService()
        }.inObjectScope(.container)
    }
    
    private func assembleRSSChannelService(_ container: Container) {
        container.register(RSSChannelServiceProtocol.self) { r in
            return RSSChannelService()
        }.inObjectScope(.transient)
    }
    
    private func assembleRSSItemService(_ container: Container) {
        container.register(RSSItemServiceProtocol.self) { r in
            return RSSItemService()
        }.inObjectScope(.transient)
    }
    
    private func assembleBackgroundService(_ container: Container) {
        container.register(BackgroundServiceProtocol.self) { r in
            return BackgroundService(xmlParserService: container.resolve(XMLParserServiceProtocol.self)!, rssChannelService: container.resolve(RSSChannelServiceProtocol.self)!)
        }.inObjectScope(.transient)
    }
    
    private func assembleNotificationService(_ container: Container) {
        container.register(NotificationServiceProtocol.self) { r in
            return NotificationService()
        }.inObjectScope(.transient)
    }
    
    private func assembleUserDefaultsService(_ container: Container) {
        container.register(UserDefaultsServiceProtocol.self) { r in
            return UserDefaultsService()
        }.inObjectScope(.transient)
    }
    
}

