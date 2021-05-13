//
//  AudioPlaybackUseCase.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.05.2021.
//

import ReactiveSwift

protocol HasPlaybackUseCase {
    var playback: PlaybackUseCase { get }
}

protocol PlaybackUseCase {
    func prepareForPlaying(mediaFile: MediaFile) -> SignalProducer<Bool, Error>
    func startPlayback() -> SignalProducer<Void, Never>
    func stopPlayback() -> SignalProducer<Void, Never>
}
