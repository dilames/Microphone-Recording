//
//  AudioFileTableViewCell.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.05.2021.
//

import ReactiveCocoa
import ReactiveSwift

final class AudioFileTableViewCell: UITableViewCell, ReusableViewModelContainer {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var createdAtLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if #available(iOS 14.0, *) {
            var backgroundConfiguration = UIBackgroundConfiguration.clear()
            backgroundConfiguration.backgroundColor = .clear
            self.backgroundConfiguration = backgroundConfiguration
        }
    }
    
    func didSetViewModel(_ viewModel: AudioFileCellViewModel, lifetime: Lifetime) {
        let output = viewModel.transform()
        
        nameLabel.reactive.text <~ output.name
        createdAtLabel.reactive.text <~ output.createdAt
    }
    
    
}
