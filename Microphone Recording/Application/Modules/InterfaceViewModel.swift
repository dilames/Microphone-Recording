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
        
        let start: Action<Void, Void, Error>
        let stop: Action<Void, Void, Never>
        let pause: Action<Void, Void, Never>
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
        
        return Output(isRecordingPermissionGranded: isRecordingPermissionGranded,
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
    
    func start() -> SignalProducer<Void, Error> {
        return useCases.recording
            .start()
            .logEvents(identifier: "ViewModel - Start Recording")
            .skipValues()
    }
    
    func stop() -> SignalProducer<Void, Never> {
        return useCases.recording
            .stop()
            .logEvents(identifier: "ViewModel - Stop Recording")
            .skipValues()
    }
    
    func pause() -> SignalProducer<Void, Never> {
        return useCases.recording
            .pause()
            .logEvents(identifier: "ViewModel - Pause Recording")
            .skipValues()
    }
    
}
