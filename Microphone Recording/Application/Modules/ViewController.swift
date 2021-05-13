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
    @IBOutlet private weak var askPermissionButton: ActionButton!
    
    @IBOutlet fileprivate weak var activeStateView: UIView!
    @IBOutlet fileprivate weak var inactiveStateView: UIView!
    
    func didSetViewModel(_ viewModel: InterfaceViewModel, lifetime: Lifetime) {
        let output = viewModel.transform()
        
        reactive.isHiddenPermissionStateView <~ output.isRecordingPermissionGranded
        startButton.reactive.pressed = CocoaAction(output.start)
        pauseButton.reactive.pressed = CocoaAction(output.pause)
        stopButton.reactive.pressed = CocoaAction(output.stop)
        askPermissionButton.reactive.pressed = CocoaAction(output.askForPermission)
    }

}

extension Reactive where Base: ViewController {
    
    var isHiddenPermissionStateView: BindingTarget<Bool> {
        return makeBindingTarget {
            $0.activeStateView.isHidden = !$1
            $0.inactiveStateView.isHidden = $1
        }
    }
    
}
