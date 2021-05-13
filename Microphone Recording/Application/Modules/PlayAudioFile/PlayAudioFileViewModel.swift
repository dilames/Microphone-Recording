//
//  PlayAudioFileViewModel.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.05.2021.
//

import ReactiveSwift

struct PlayAudioFileViewModel: ViewModel {
    
    typealias UseCases = HasPlaybackUseCase
    
    struct Handlers {
        let close: Action<Void, Void, Never>
    }
    
    struct Output {
        let name: Property<String>
        let path: Property<String>
        let createdAt: Property<String>
        
        let play: Action<Void, Void, Error>
        let stop: Action<Void, Void, Never>
    }
    
    private let mediaFile: MediaFile
    private let useCases: UseCases
    private let handlers: Handlers
    
    init(useCases: UseCases, handlers: Handlers, mediaFile: MediaFile) {
        self.useCases = useCases
        self.handlers = handlers
        self.mediaFile = mediaFile
    }
    
    func transform(_ input: ()) -> Output {
        let play = Action(execute: play)
        let stop = Action(execute: useCases.playback.stopPlayback)
        handlers.close <~ stop.values
        return Output(
            name: Property(value: "Voice Recording - \(mediaFile.id.uuidString.prefix(7))"),
            path: Property(value: mediaFile.url.path),
            createdAt: Property(value: MediaRepository.stringTime(createdAt: mediaFile.createdAt)),
            play: play,
            stop: stop
        )
    }
    
}

// MARK: Private - Actions
private extension PlayAudioFileViewModel {
    
    func play() -> SignalProducer<Void, Error> {
        return useCases.playback
            .prepareForPlaying(mediaFile: mediaFile)
            .flatMap(.latest, { _ in useCases.playback.startPlayback() })
            .logEvents(identifier: "ViewModel - Play")
    }
    
}
