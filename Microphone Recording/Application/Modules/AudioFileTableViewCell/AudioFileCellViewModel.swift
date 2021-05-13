//
//  AudioFileCellViewModel.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.05.2021.
//

import ReactiveSwift

struct AudioFileCellViewModel: ViewModel {
    
    struct Output {
        let name: Property<String>
        let createdAt: Property<String>
    }
    
    private let mediaFile: MediaFile
    
    init(mediaFile: MediaFile) {
        self.mediaFile = mediaFile
    }
    
    func transform(_ input: ()) -> Output {
        return Output(
            name: Property(value: mediaFile.url.lastPathComponent),
            createdAt: Property(value: MediaRepository.format(createdAt: mediaFile.createdAt))
        )
    }
}
