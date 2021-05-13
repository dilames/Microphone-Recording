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
    
    func didSetViewModel(_ viewModel: AudioFileCellViewModel, lifetime: Lifetime) {
        
    }
    
    
}
