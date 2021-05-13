//
//  Platform.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.05.2021.
//

import Foundation

struct Platform: UseCaseProvider {
    
    
    private var coreDataProvider = CoreDataProvider()
    private var mediaRepository: MediaRepository
    
    var recording: AudioRecordingUseCase
    var audioList: AudioListUseCase
    var playback: PlaybackUseCase
    
    init() {
        mediaRepository = MediaRepository(coreDataProvider: coreDataProvider)
        recording = RecordingService(mediaRepository: mediaRepository)
        audioList = StorageService(mediaRepository: mediaRepository)
        playback = PlaybackService()
    }
    
}
