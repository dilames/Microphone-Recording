//
//  PlayAudioFileViewController.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.05.2021.
//

import ReactiveCocoa
import ReactiveSwift

final class PlayAudioFileViewController: UIViewController, ViewModelContainer {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var pathLabel: UILabel!
    
    @IBOutlet private weak var playButton: ActionButton!
    @IBOutlet private weak var stopButton: ActionButton!
    
    func didSetViewModel(_ viewModel: PlayAudioFileViewModel, lifetime: Lifetime) {
        let output = viewModel.transform()
        
        nameLabel.reactive.text <~ output.name
        pathLabel.reactive.text <~ output.path
        dateLabel.reactive.text <~ output.createdAt
        
        playButton.reactive.pressed = CocoaAction(output.play)
        stopButton.reactive.pressed = CocoaAction(output.stop)
    }
    
}
