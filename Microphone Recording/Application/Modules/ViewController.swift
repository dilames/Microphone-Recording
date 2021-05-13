//
//  ViewController.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.05.2021.
//

import ReactiveSwift
import ReactiveCocoa

final class ViewController: UIViewController, ViewModelContainer {
    
    @IBOutlet private weak var startButton: ActionButton!
    @IBOutlet private weak var pauseButton: ActionButton!
    @IBOutlet private weak var stopButton: ActionButton!
    
    func didSetViewModel(_ viewModel: InterfaceViewModel, lifetime: Lifetime) {
        
    }


}
