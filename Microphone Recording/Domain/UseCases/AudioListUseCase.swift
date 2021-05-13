//
//  AudioListUseCase.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.05.2021.
//

import ReactiveSwift

protocol HasAudioListUseCase {
    var audioList: AudioListUseCase { get }
}

protocol AudioListUseCase {
    func list() -> SignalProducer<MediaFile, Never>
}
