//
//  UserDefaultsService.swift
//  RSSManager
//
//  Created by Marko Matijević on 13.12.2023..
//

import Foundation

protocol UserDefaultsServiceProtocol {
    func setNotificationsEnabled(_ isEnabled: Bool)
    func areNotificationsEnabled() -> Bool
}

class UserDefaultsService: UserDefaultsServiceProtocol {
    func areNotificationsEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: K.Strings.notifications)
    }
    
    func setNotificationsEnabled(_ isEnabled: Bool) {
        UserDefaults.standard.set(isEnabled, forKey: K.Strings.notifications)
    }
}
