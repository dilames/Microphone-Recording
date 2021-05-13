//
//  ApplicationCoordinator.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.05.2021.
//

import UIKit

final class ApplicationCoordinator {
    
    let useCaseProvider: UseCaseProvider
    let window: UIWindow
    
    init(useCaseProvider: UseCaseProvider, window: UIWindow = UIWindow(frame: UIScreen.main.bounds)) {
        self.useCaseProvider = useCaseProvider
        self.window = window
        if #available(iOS 13.0, *) { window.overrideUserInterfaceStyle = .light }
    }
    
    func start() {
        window.rootViewController = audioRecordingViewController
        window.makeKeyAndVisible()
    }
    
}

extension ApplicationCoordinator {
    
    var audioRecordingViewController: ViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let viewModel = InterfaceViewModel(useCases: useCaseProvider)
        viewController.viewModel = viewModel
        return viewController
    }
    
}
