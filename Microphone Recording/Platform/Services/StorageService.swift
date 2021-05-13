//
//  StorageService.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.05.2021.
//

import ReactiveSwift

final class StorageService: AudioListUseCase {
    
    private weak var mediaRepository: MediaRepository!
    private var mutableMediaList: MutableProperty<[MediaFile]> = MutableProperty<[MediaFile]>([])
    lazy var mediaList: Property<[MediaFile]> = Property<[MediaFile]>(initial: [], then: mutableMediaList.producer)
    
    init(mediaRepository: MediaRepository) {
        self.mediaRepository = mediaRepository
    }
    
    func list() -> SignalProducer<[MediaFile], Error> {
        return SignalProducer(result: mediaRepository.all())
    }
    
    func create(mediaFile: MediaFile) -> SignalProducer<MediaFile, Error> {
        return SignalProducer(result: mediaRepository.add(mediaFile: mediaFile))
            .combineLatest(with: save())
            .map({ $0.0 })
    }
    
}

// MARK: Private
private extension StorageService {
    
    func save() -> SignalProducer<Bool, Error> {
        return SignalProducer(result: mediaRepository.save())
    }
    
}
