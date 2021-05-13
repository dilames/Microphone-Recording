//
//  AudioRecordingUseCase.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.05.2021.
//

import ReactiveSwift
import AVFoundation

enum AudioRecordingStatus {
    case none
    case recoding
    case paused
    case ended
}

protocol AudioRecordingSession {
    var mediaFile: MediaFile { get }
    var duration: Property<TimeInterval> { get }
    var status: Property<AudioRecordingStatus> { get }
}

protocol HasAudioRecordingUseCase {
    var recording: AudioRecordingUseCase { get }
}

protocol AudioRecordingUseCase {
    
    var permission: Property<AVAudioSession.RecordPermission> { get }
    func requestRecordingPermission() -> SignalProducer<AVAudioSession.RecordPermission, Error>
    func start() -> SignalProducer<AudioRecordingSession, Error>
    func stop() -> SignalProducer<AudioRecordingSession, Never>
    func pause() -> SignalProducer<AudioRecordingSession, Never>
}
