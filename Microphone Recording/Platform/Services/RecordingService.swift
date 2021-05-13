//
//  RecordingService.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.05.2021.
//

import ReactiveSwift
import AVFoundation

final private class RecordingSession: AudioRecordingSession {
    
    fileprivate var audioRecorder: AVAudioRecorder?
    fileprivate let audioRecorderStatus: MutableProperty<AudioRecordingStatus> = MutableProperty(wrappedValue: .none)
    
    let mediaFile: MediaFile
    let duration: Property<TimeInterval>
    let status: Property<AudioRecordingStatus>
    
    init(audioRecorder: AVAudioRecorder, mediaFile: MediaFile, on dateScheduler: DateScheduler) {
        self.audioRecorder = audioRecorder
        self.mediaFile = mediaFile
        self.status = Property(capturing: audioRecorderStatus)
        self.duration = Property(initial: 0,
                                 then: SignalProducer
                                    .timer(interval: .milliseconds(10), on: dateScheduler)
                                    .take(until: audioRecorderStatus.producer.filter({ $0 != .ended }).skipValues())
                                    .map({ _ in audioRecorder.currentTime })
        )
    }
    
}

final class RecordingService: NSObject, AudioRecordingUseCase {
    
    private let recordPermission: MutableProperty<AVAudioSession.RecordPermission>
    private let mediaStorage: MediaRepository
    private let audioSession: AVAudioSession
    private var recordingSession: RecordingSession?
    
    init(audioSession: AVAudioSession = AVAudioSession.sharedInstance(),
         mediaStorage: MediaRepository) {
        self.audioSession = audioSession
        self.mediaStorage = mediaStorage
        self.recordPermission = MutableProperty(audioSession.recordPermission)
    }
    
    func start() -> SignalProducer<AudioRecordingSession, Error> {
        prepareForRecording()
            .flatMap(.latest, start(recordingSession:))
            .map { $0 as AudioRecordingSession }
        
    }
    
    func stop() -> SignalProducer<AudioRecordingSession, Never> {
        return latestRecordingSession()
            .flatMap(.latest, stop(recordingSession:))
            .map { $0 as AudioRecordingSession }
    }
    
    func pause() -> SignalProducer<AudioRecordingSession, Never> {
        return latestRecordingSession()
            .flatMap(.latest, pause(recordingSession:))
            .map { $0 as AudioRecordingSession }
    }
    
}

// MARK: AVAudioRecorderDelegate
extension RecordingService: AVAudioRecorderDelegate {
    
    func requestRecordingPermission() -> SignalProducer<AVAudioSession.RecordPermission, Error> {
        return SignalProducer({ [unowned self] observer, _ in
            audioSession.requestRecordPermission { _ in
                recordPermission.value = audioSession.recordPermission
                observer.send(value: recordPermission.value)
                observer.sendCompleted()
            }
        })
    }
    
}

// MARK: Private
private extension RecordingService {
    
    func latestRecordingSession() -> SignalProducer<RecordingSession, Never> {
        return SignalProducer(value: recordingSession).skipNil()
    }
    
    func prepareForRecording() -> SignalProducer<RecordingSession, Error> {
        do {
            try audioSession.setCategory(.record)
            try audioSession.setActive(true, options: [.notifyOthersOnDeactivation])
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            let mediaFile = mediaStorage.create(mediaFileWithName: "Audio Recording")
            let audioRecorder = try AVAudioRecorder(url: mediaFile.url, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            let session = RecordingSession(
                audioRecorder: audioRecorder,
                mediaFile: mediaFile,
                on: QueueScheduler.main
            )
            return SignalProducer(value: session)
        } catch {
            return SignalProducer(error: error)
        }
    }
    
    func start(recordingSession: RecordingSession) -> SignalProducer<RecordingSession, Error> {
        recordingSession.audioRecorder?.record()
        recordingSession.audioRecorderStatus.value = .recoding
        return SignalProducer(value: recordingSession)
    }
    
    func pause(recordingSession: RecordingSession) -> SignalProducer<RecordingSession, Never> {
        recordingSession.audioRecorder?.pause()
        recordingSession.audioRecorderStatus.value = .paused
        return SignalProducer(value: recordingSession)
    }
    
    func stop(recordingSession: RecordingSession) -> SignalProducer<RecordingSession, Never> {
        recordingSession.audioRecorder?.stop()
        recordingSession.audioRecorderStatus.value = .ended
        return SignalProducer(value: recordingSession)
    }
    
}

// MARK: Actions
extension RecordingService {
    
}
