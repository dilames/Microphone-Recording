//
//  ApplicationCoordinator.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.05.2021.
//

import UIKit
import ReactiveSwift

final class ApplicationCoordinator {
    
    let useCaseProvider: UseCaseProvider
    let window: UIWindow
    
    private var navigationController: UINavigationController
    
    init(useCaseProvider: UseCaseProvider, window: UIWindow = UIWindow(frame: UIScreen.main.bounds)) {
        self.useCaseProvider = useCaseProvider
        self.window = window
        self.navigationController = UINavigationController()
        if #available(iOS 13.0, *) { window.overrideUserInterfaceStyle = .light }
    }
    
    func start() {
        navigationController.setNavigationBarHidden(true, animated: true)
        navigationController.viewControllers = [audioRecordingViewController]
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
}

// MARK: ViewControllers
extension ApplicationCoordinator {
    
    func dismissViewController() ->  SignalProducer<Void, Never> {
        return SignalProducer.executingEmpty
            .start(on: UIScheduler())
            .flatMap(.latest) { [unowned self] in
                navigationController.dismiss(animated: true, completion: nil)
                return .executingEmpty
            }
    }
    
    func openPlayRecording(mediaFile: MediaFile) -> SignalProducer<Void, Never> {
        return SignalProducer.executingEmpty
            .start(on: UIScheduler())
            .flatMap(.latest) { [unowned self] in
                navigationController.present(playAudioFileViewController(mediaFile: mediaFile), animated: true, completion: nil)
                return .executingEmpty
            }
    }
    
    func playAudioFileViewController(mediaFile: MediaFile) -> PlayAudioFileViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PlayAudioFileViewController") as! PlayAudioFileViewController
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overFullScreen
        let handlers = PlayAudioFileViewModel.Handlers(close: Action(execute: dismissViewController))
        let viewModel = PlayAudioFileViewModel(useCases: useCaseProvider,
                                               handlers: handlers,
                                               mediaFile: mediaFile)
        viewController.viewModel = viewModel
        return viewController
    }
    
    var audioRecordingViewController: ViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let handlers = InterfaceViewModel.Handlers(playAudio: Action(execute: openPlayRecording(mediaFile:)))
        let viewModel = InterfaceViewModel(useCases: useCaseProvider, handlers: handlers)
        viewController.viewModel = viewModel
        return viewController
    }
    
}
