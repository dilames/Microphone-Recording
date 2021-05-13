//
//  Platform.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.05.2021.
//

import Foundation

struct Platform: UseCaseProvider {
    
    private var mediaRepository = MediaRepository()
    var recording: AudioRecordingUseCase
    var audioList: AudioListUseCase
    
    init() {
        recording = RecordingService(mediaStorage: mediaRepository)
        audioList = StorageService()
    }
    
}
