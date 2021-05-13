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
    @IBOutlet fileprivate weak var askPermissionButton: ActionButton!
    @IBOutlet private weak var durationLabel: UILabel!
    
    @IBOutlet fileprivate weak var activeStateView: UIStackView!
    @IBOutlet fileprivate weak var inactiveStateView: UIView!
    
    func didSetViewModel(_ viewModel: InterfaceViewModel, lifetime: Lifetime) {
        let output = viewModel.transform()
        
        startButton.reactive.isEnabled <~ output.audioRecordingStatus.map({ $0 != .recoding })
        pauseButton.reactive.isEnabled <~ output.audioRecordingStatus.map({ $0 == .paused })
        stopButton.reactive.isEnabled <~ output.audioRecordingStatus.map({ $0 != .ended })
        
        reactive.isHiddenPermissionStateView <~ output.isRecordingPermissionGranded.producer.logEvents()
        durationLabel.reactive.text <~ output.audioRecordingDuration.map(Self.formattedDuration(timeInterval:))
        
        startButton.reactive.pressed = CocoaAction(output.start)
        pauseButton.reactive.pressed = CocoaAction(output.pause)
        stopButton.reactive.pressed = CocoaAction(output.stop)
        askPermissionButton.reactive.pressed = CocoaAction(output.askForPermission)
    }

}

extension ViewController {
    
    class func formattedDuration(timeInterval: TimeInterval?) -> String {
        guard let timeInterval = timeInterval else { return "Start Audio Recording" }
        let hr = Int((timeInterval / 60) / 60)
        let min = Int(timeInterval / 60)
        let sec = Int(timeInterval.truncatingRemainder(dividingBy: 60))
        let string = String(format: "%02d:%02d:%02d", hr, min, sec)
        return string
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
