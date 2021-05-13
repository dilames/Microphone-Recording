//
//  Platform.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.05.2021.
//

import Foundation

protocol HasAudioRecordingUseCase {
    
}

protocol AudioRecordingUseCase {
    func start()
    func stop()
    func pause()
}



struct Platform: UseCaseProvider {
    
}
