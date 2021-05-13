//
//  RecordingService.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.05.2021.
//

import ReactiveSwift
import AVFoundation

struct RecordingSession: AudioRecordingSession {
    
    fileprivate var audioRecorder: AVAudioRecorder?
    fileprivate let audioRecorderStatus: MutableProperty<AudioRecordingStatus> = MutableProperty(wrappedValue: .none)
    
    let mediaFile: MediaFile
    let duration: Property<TimeInterval>
    let status: Property<AudioRecordingStatus>
    
    init(audioRecorder: AVAudioRecorder, mediaFile: MediaFile, on dateScheduler: DateScheduler) {
        let status = Property(capturing: audioRecorderStatus)
        self.audioRecorder = audioRecorder
        self.mediaFile = mediaFile
        self.status = status
        self.duration = Property(
            initial: 0,
            then: SignalProducer
                .timer(interval: .milliseconds(500), on: dateScheduler)
                .take(until: audioRecorderStatus.producer.filter({ $0 == .ended }).skipValues())
                .map({ _ in audioRecorder.currentTime })
                .filter({ _ in status.value == .recording })
                .logEvents(identifier: "Duration")
        )
    }
    
}

final class RecordingService: NSObject, AudioRecordingUseCase {
    
    public var permission: Property<AVAudioSession.RecordPermission>
    
    private let mutableRecordingPermission: MutableProperty<AVAudioSession.RecordPermission>
    private let mediaStorage: MediaRepository
    private let audioSession: AVAudioSession
    private var recordingSession: RecordingSession?
    
    init(audioSession: AVAudioSession = AVAudioSession.sharedInstance(),
         mediaRepository: MediaRepository) {
        self.audioSession = audioSession
        self.mediaStorage = mediaRepository
        self.mutableRecordingPermission = MutableProperty(audioSession.recordPermission)
        self.permission = Property(capturing: mutableRecordingPermission)
    }
    
    func start() -> SignalProducer<AudioRecordingSession, Error> {
        return requestRecordingPermission()
            .filter { $0 == .granted }
            .flatMap(.latest) { [unowned self] _ in latestRecordingSession() }
            .flatMap(.latest) { [unowned self] in $0 == nil ? prepareForRecording() : SignalProducer(value: $0!) }
            .flatMap(.latest, start(recordingSession:))
            .map({ $0 as AudioRecordingSession })
    }
    
    func stop() -> SignalProducer<AudioRecordingSession, Never> {
        return latestRecordingSession()
            .skipNil()
            .flatMap(.latest, stop(recordingSession:))
            .map { $0 as AudioRecordingSession }
    }
    
    func pause() -> SignalProducer<AudioRecordingSession, Never> {
        return latestRecordingSession()
            .skipNil()
            .flatMap(.latest, pause(recordingSession:))
            .map { $0 as AudioRecordingSession }
    }
    
    func requestRecordingPermission() -> SignalProducer<AVAudioSession.RecordPermission, Error> {
        return SignalProducer({ [unowned self] observer, _ in
            audioSession.requestRecordPermission { _ in
                mutableRecordingPermission.value = audioSession.recordPermission
                observer.send(value: mutableRecordingPermission.value)
                observer.sendCompleted()
            }
        })
    }
    
}

// MARK: AVAudioRecorderDelegate
extension RecordingService: AVAudioRecorderDelegate {
    
}

// MARK: Private
private extension RecordingService {
    
    func latestRecordingSession() -> SignalProducer<RecordingSession?, Never> {
        return SignalProducer(value: recordingSession)
    }
    
    func prepareForRecording() -> SignalProducer<RecordingSession, Error> {
        return SignalProducer { [unowned self] observer, _ in
            do {
                try audioSession.setCategory(.playAndRecord)
                try audioSession.setActive(true, options: [])
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ]
                let mediaFile = mediaStorage.create(mediaFileWithName: "Voice Recording ")
                let audioRecorder = try AVAudioRecorder(url: mediaFile.url, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                
                guard
                    audioRecorder.prepareToRecord()
                else {
                    observer.send(error: RecordingError.audioFileCorrupted)
                    return
                }
                
                let session = RecordingSession(
                    audioRecorder: audioRecorder,
                    mediaFile: mediaFile,
                    on: QueueScheduler.main
                )
                observer.send(value: session)
                observer.sendCompleted()
            } catch {
                observer.send(error: error)
            }
        }
    }
    
    func start(recordingSession: RecordingSession) -> SignalProducer<RecordingSession, Error> {
        return SignalProducer { [unowned self] observer, _ in
            self.recordingSession = recordingSession
            recordingSession.audioRecorder?.record()
            recordingSession.audioRecorderStatus.value = .recording
            observer.send(value: recordingSession)
            observer.sendCompleted()
        }
    }
    
    func pause(recordingSession: RecordingSession) -> SignalProducer<RecordingSession, Never> {
        return SignalProducer { observer, _ in
            recordingSession.audioRecorder?.pause()
            recordingSession.audioRecorderStatus.value = .paused
            observer.send(value: recordingSession)
            observer.sendCompleted()
        }
    }
    
    func stop(recordingSession: RecordingSession) -> SignalProducer<RecordingSession, Never> {
        return SignalProducer { [unowned self] observer, _ in
            recordingSession.audioRecorder?.stop()
            recordingSession.audioRecorderStatus.value = .ended
            observer.send(value: recordingSession)
            observer.sendCompleted()
            self.recordingSession = nil
        }
    }
    
}

// MARK: Error
extension RecordingService {
    
    enum RecordingError: Swift.Error {
        case audioFileCorrupted
    }
    
}
