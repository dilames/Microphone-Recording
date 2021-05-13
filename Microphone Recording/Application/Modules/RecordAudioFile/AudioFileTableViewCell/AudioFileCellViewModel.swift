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
        let name = "Voice Recording - \(mediaFile.id.uuidString.prefix(7))"
        return Output(
            name: Property(value: name),
            createdAt: Property(value: MediaRepository.stringTime(createdAt: mediaFile.createdAt))
        )
    }
}
