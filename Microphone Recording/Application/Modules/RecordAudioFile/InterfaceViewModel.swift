//
//  InterfaceViewModel.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.05.2021.
//

import ReactiveSwift

struct InterfaceViewModel: ViewModel {
    
    typealias UseCases = HasAudioListUseCase & HasAudioRecordingUseCase
    
    struct Input {
        let indexPath: Signal<IndexPath, Never>
    }
    
    struct Output {
        let isRecordingPermissionGranded: Property<Bool>
        let audioRecordingStatus: Property<AudioRecordingStatus>
        let audioRecordingDuration: Property<TimeInterval>
        let tableViewStructure: Property<[TableViewSection]>
        
        let start: Action<Void, AudioRecordingSession, Error>
        let stop: Action<Void, AudioRecordingSession, Error>
        let pause: Action<Void, AudioRecordingSession, Never>
        let askForPermission: Action<Void, Void, Error>
    }
    
    struct Handlers {
        let playAudio: Action<MediaFile, Void, Never>
    }
    
    private let useCases: UseCases
    private let handlers: Handlers
    
    init(useCases: UseCases, handlers: Handlers) {
        self.useCases = useCases
        self.handlers = handlers
    }
    
    func transform(_ input: Input) -> Output {
        
        let indexPath = Property(initial: IndexPath(row: 0, section: 0), then: input.indexPath)
        
        let start = Action(execute: start)
        let stop = Action(execute: stop)
        let pause = Action(execute: pause)
        let askForRecordingPermission = Action(execute: askForRecordingPermission)
        
        let isRecordingPermissionGranded = useCases.recording.permission.map({ $0 == .granted })
        let audioRecordingSession = Property<AudioRecordingSession?>(
            initial: nil,
            then: SignalProducer
                .merge(start.values.map({ Optional($0) }), stop.values.map(value: .none))
        )
        let audioRecordingStatus = Property(
            initial: .none,
            then: audioRecordingSession.producer.skipNil().map(\.status.producer).flatten(.latest)
                .merge(with: audioRecordingSession.producer.map { $0 == nil }.filter({ $0 == true }).map(value: .none))
                .debounce(0.1, on: QueueScheduler.main)
                .skipRepeats()
        )
        let audioRecordingDuration = Property(
            initial: 0,
            then: audioRecordingSession.producer.skipNil().map(\.duration.producer).flatten(.latest)
                .merge(with: audioRecordingSession.producer.map { $0 == nil }.filter({ $0 }).map(value: 0))
                .skipRepeats()
        )
        let tableViewStructure = Property(
            initial: [],
            then: SignalProducer.merge(
                stop.values.skipValues(), // Update once stop has called
                SignalProducer.executingEmpty
            )
            .flatMap(.latest, { _ in useCases.audioList.list().skipErrors() })
            .map(tableViewStructure(forMediaFiles:))
        )
        
        handlers.playAudio <~ indexPath.producer
            .compactMap({ tableViewStructure.value[safe: $0.section]?.content[safe: $0.row]?.viewModel as? AudioFileCellViewModel })
            .map(\.mediaFile)
        
        return Output(isRecordingPermissionGranded: isRecordingPermissionGranded,
                      audioRecordingStatus: audioRecordingStatus,
                      audioRecordingDuration: audioRecordingDuration,
                      tableViewStructure: tableViewStructure,
                      start: start,
                      stop: stop,
                      pause: pause,
                      askForPermission: askForRecordingPermission)
    }
    
}

// MARK: Private - ViewModels
private extension InterfaceViewModel {
    
    func tableViewStructure(forMediaFiles mediaFiles: [MediaFile]) -> [TableViewSection] {
        let viewModels = mediaFiles.map { AudioFileCellViewModel(mediaFile: $0) }
        let tableViewRows = viewModels.map { TableViewRow(viewModel: $0) }
        let tableViewSection = TableViewSection(content: tableViewRows)
        return [tableViewSection]
    }
    
}

// MARK: Private - Actions
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
    
    func stop() -> SignalProducer<AudioRecordingSession, Error> {
        return useCases.recording
            .stop()
            .flatMap(.latest, { audioRecordingSession in
                useCases.audioList
                    .create(mediaFile: audioRecordingSession.mediaFile)
                    .map(value: audioRecordingSession)
                    .logEvents(identifier: "ViewModel - Save Recording")
            })
            .logEvents(identifier: "ViewModel - Stop Recording")
    }
    
    func pause() -> SignalProducer<AudioRecordingSession, Never> {
        return useCases.recording
            .pause()
            .logEvents(identifier: "ViewModel - Pause Recording")
    }
    
}
