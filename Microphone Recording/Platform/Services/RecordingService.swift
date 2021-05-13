//
//  RecordingService.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.05.2021.
//

import ReactiveSwift
import AVFoundation

final class RecordingService: NSObject, AudioRecordingUseCase {
    
    private let recordPermission: MutableProperty<AVAudioSession.RecordPermission>
    private let audioSession: AVAudioSession
    private var audioRecorder: AVAudioRecorder?
    
    init(audioSession: AVAudioSession = AVAudioSession.sharedInstance()) {
        self.audioSession = audioSession
        self.recordPermission = MutableProperty(audioSession.recordPermission)
    }
    
    func requestRecordingPermission() -> SignalProducer<AVAudioSession.RecordPermission, Error> {
        return SignalProducer({ [unowned self] observer, _ in
            audioSession.requestRecordPermission { _ in
                recordPermission.value = audioSession.recordPermission
                observer.send(value: recordPermission.value)
                observer.sendCompleted()
            }
        })
    }
    
    func start() -> SignalProducer<Void, Never> {
        do {
            try audioSession.setCategory(.record)
            try audioSession.setActive(true, options: [.notifyOthersOnDeactivation])
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
            ]
            audioRecorder = try AVAudioRecorder(url: <#T##URL#>, settings: settings)
            audioRecorder?.delegate = self
        } catch {
            
        }
        return .empty
    }
    
    func stop() -> SignalProducer<Void, Never> {
        return .empty
    }
    
    func pause() -> SignalProducer<Void, Never> {
        return .empty
    }
    
}

// MARK: Private
extension RecordingService: AVAudioRecorderDelegate {
    
}

// MARK: Actions
extension RecordingService {
    
}
