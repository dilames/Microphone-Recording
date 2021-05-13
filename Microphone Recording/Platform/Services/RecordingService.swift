//
//  RecordingService.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.05.2021.
//

import ReactiveSwift

final class RecordingService: AudioRecordingUseCase {
    
    func start() -> SignalProducer<Void, Never> {
        return .empty
    }
    
    func stop() -> SignalProducer<Void, Never> {
        return .empty
    }
    
    func pause() -> SignalProducer<Void, Never> {
        return .empty
    }
    
}
