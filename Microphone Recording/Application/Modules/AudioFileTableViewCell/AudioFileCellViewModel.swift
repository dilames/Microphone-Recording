//
//  AudioFileCellViewModel.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.05.2021.
//

import ReactiveSwift

struct AudioFileCellViewModel: ViewModel {
    
    private let mediaFile: MediaFile
    
    init(mediaFile: MediaFile) {
        self.mediaFile = mediaFile
    }
}
