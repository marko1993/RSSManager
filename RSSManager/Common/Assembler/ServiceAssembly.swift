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
        self.assembleRSSService(container)
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
    
    private func assembleRSSService(_ container: Container) {
        container.register(RSSServiceProtocol.self) { r in
            return RSSService()
        }.inObjectScope(.transient)
    }
    
}

