//
//  Platform.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.05.2021.
//

import Foundation

struct Platform: UseCaseProvider {
    
    var recording: AudioRecordingUseCase = RecordingService()
    var audioList: AudioListUseCase = StorageService()
    
}
