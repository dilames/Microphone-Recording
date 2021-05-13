//
//  StorageService.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.05.2021.
//

import ReactiveSwift

final class StorageService: AudioListUseCase {
    
    func list() -> SignalProducer<MediaFile, Never> {
        return .empty
    }
    
}
