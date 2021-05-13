//
//  AppDelegate.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.05.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private let platform: Platform = Platform()
    private lazy var coordinator: ApplicationCoordinator = ApplicationCoordinator(useCaseProvider: platform)
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = coordinator.window
        coordinator.start()
        return true
    }

}
