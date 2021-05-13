//
//  AudioRecordingUseCase.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.05.2021.
//

import ReactiveSwift

protocol HasAudioRecordingUseCase {
    var recording: AudioRecordingUseCase { get }
}

protocol AudioRecordingUseCase {
    func start() -> SignalProducer<Void, Never>
    func stop() -> SignalProducer<Void, Never>
    func pause() -> SignalProducer<Void, Never>
}
