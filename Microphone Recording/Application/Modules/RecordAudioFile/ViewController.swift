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
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let dataSource = TableViewDataSource(
        rowConstructor: { (tableView, tableViewRow, indexPath) -> UITableViewCell? in
            if let viewModel = tableViewRow.viewModel as? AudioFileCellViewModel {
                let view = tableView.dequeueReusableCell(forType: AudioFileTableViewCell.self, for: indexPath)
                view.viewModel = viewModel
                return view
            }
            return nil
        }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reactive.set(dataSource: dataSource)
    }
    
    func didSetViewModel(_ viewModel: InterfaceViewModel, lifetime: Lifetime) {
        let output = viewModel.transform()
        
        bind(tableView: output)
        bind(actions: output)
        bind(state: output)
    }

}

// MARK: Private
private extension ViewController {
    
    private func bind(tableView output: InterfaceViewModel.Output) {
        let tableViewStructureValues = output.tableViewStructure.producer
        dataSource.bind(with: tableViewStructureValues)
        tableView.reactive.reloadData <~ tableViewStructureValues.skipValues()
    }
    
    private func bind(state output: InterfaceViewModel.Output) {
        startButton.reactive.isEnabled <~ output.audioRecordingStatus.map({ $0 == .recording }).negate()
        pauseButton.reactive.isEnabled <~ output.audioRecordingStatus.map({ $0 == .recording })
        stopButton.reactive.isEnabled <~ output.audioRecordingStatus.map({ $0 == .ended || $0 == .none }).negate()
        reactive.isHiddenPermissionStateView <~ output.isRecordingPermissionGranded
        durationLabel.reactive.text <~ output.audioRecordingDuration.map(Self.formattedDuration(timeInterval:))
    }
    
    private func bind(actions output: InterfaceViewModel.Output) {
        startButton.reactive.pressed = CocoaAction(output.start)
        pauseButton.reactive.pressed = CocoaAction(output.pause)
        stopButton.reactive.pressed = CocoaAction(output.stop)
        askPermissionButton.reactive.pressed = CocoaAction(output.askForPermission)
    }
    
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
