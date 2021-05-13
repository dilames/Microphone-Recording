//
//  PlaybackService.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.05.2021.
//

import ReactiveSwift
import AVFoundation

final class PlaybackService: PlaybackUseCase {
    
    private var player: AVAudioPlayer?
    private let audioSession: AVAudioSession
    
    init(audioSession: AVAudioSession = AVAudioSession.sharedInstance()) {
        self.audioSession = audioSession
    }
    
}

// MARK: Private
extension PlaybackService {
    
    func prepareForPlaying(mediaFile: MediaFile) -> SignalProducer<Bool, Error> {
        return SignalProducer { [unowned self] observer, _ in
            do {
                
                try audioSession.setCategory(.playback)
                try audioSession.setActive(true, options: [])
                
                self.player = try AVAudioPlayer(contentsOf: mediaFile.url)
                self.player?.prepareToPlay()
                self.player?.numberOfLoops = 1
                
                observer.send(value: true)
                observer.sendCompleted()
            } catch {
                observer.send(error: error)
            }
        }
    }
    
    func startPlayback() -> SignalProducer<Void, Never> {
        return SignalProducer({ [unowned self] in player?.play() })
    }
    
    func stopPlayback() -> SignalProducer<Void, Never> {
        return SignalProducer({ [unowned self] in player?.stop() })
    }
    
}
