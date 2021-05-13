//
//  InterfaceViewModel.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.05.2021.
//

import ReactiveSwift

struct InterfaceViewModel: ViewModel {
    
    typealias UseCases = HasAudioListUseCase & HasAudioRecordingUseCase
    
    struct Output {
        
        let isRecordingPermissionGranded: Property<Bool>
        let audioRecordingStatus: Property<AudioRecordingStatus>
        let audioRecordingDuration: Property<TimeInterval>
        
        let start: Action<Void, AudioRecordingSession, Error>
        let stop: Action<Void, AudioRecordingSession, Never>
        let pause: Action<Void, AudioRecordingSession, Never>
        let askForPermission: Action<Void, Void, Error>
    }
    
    private let useCases: UseCases
    
    init(useCases: UseCases) {
        self.useCases = useCases
    }
    
    func transform(_ input: ()) -> Output {
        
        let start = Action(execute: start)
        let stop = Action(execute: stop)
        let pause = Action(execute: pause)
        let askForRecordingPermission = Action(execute: askForRecordingPermission)
        
        let isRecordingPermissionGranded = useCases.recording.permission.map({ $0 == .granted })
        let audioRecordingSession = Property<AudioRecordingSession?>(
            initial: nil,
            then: SignalProducer
                .merge(start.values.map({ Optional($0) }),
                       stop.values.map(value: .none))
        )
        let audioRecordingStatus = Property(
            initial: .none,
            then: audioRecordingSession.producer
                .flatMap(.latest, { $0?.status.producer ?? SignalProducer(value: .none) })
        )
        let audioRecordingDuration = Property<TimeInterval>(
            initial: 0,
            then:
                audioRecordingSession.producer
                .flatMap(.latest, { $0?.duration.producer ?? SignalProducer(value: 0) })
        )
        
        return Output(isRecordingPermissionGranded: isRecordingPermissionGranded,
                      audioRecordingStatus: audioRecordingStatus,
                      audioRecordingDuration: audioRecordingDuration,
                      start: start,
                      stop: stop,
                      pause: pause,
                      askForPermission: askForRecordingPermission)
    }
    
}

// MARK: Actions
private extension InterfaceViewModel {
    
    func askForRecordingPermission() -> SignalProducer<Void, Error> {
        return useCases.recording
            .requestRecordingPermission()
            .logEvents(identifier: "ViewModel - Permission")
            .skipValues()
    }
    
    func start() -> SignalProducer<AudioRecordingSession, Error> {
        return useCases.recording
            .start()
            .logEvents(identifier: "ViewModel - Start Recording")
    }
    
    func stop() -> SignalProducer<AudioRecordingSession, Never> {
        return useCases.recording
            .stop()
            .logEvents(identifier: "ViewModel - Stop Recording")
    }
    
    func pause() -> SignalProducer<AudioRecordingSession, Never> {
        return useCases.recording
            .pause()
            .logEvents(identifier: "ViewModel - Pause Recording")
    }
    
}
