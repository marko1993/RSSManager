//
//  AppDelegate.swift
//  RSSManager
//
//  Created by Marko Matijević on 08.12.2023..
//

import UIKit
import IQKeyboardManagerSwift
import FirebaseCore
import Swinject

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var backgroundService: BackgroundServiceProtocol!
    private var notificationService: NotificationServiceProtocol!
    private var userDefaultsService: UserDefaultsServiceProtocol!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        initializeServices()
        if userDefaultsService.areNotificationsEnabled() {
            setupBackgroundTaskForUpdates()
        }
        return true
    }
    
    private func initializeServices() {
        notificationService = Assembler.sharedAssembler.resolver.resolve(NotificationServiceProtocol.self)!
        backgroundService = Assembler.sharedAssembler.resolver.resolve(BackgroundServiceProtocol.self)!
        userDefaultsService = Assembler.sharedAssembler.resolver.resolve(UserDefaultsServiceProtocol.self)!
    }
    
    private func setupBackgroundTaskForUpdates() {
        notificationService.getNotificationsPermission()
        backgroundService.scheduleBackgroundTask { [weak self] showNotification in
            if showNotification {
                self?.notificationService.showLocalNotification()
            }
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

