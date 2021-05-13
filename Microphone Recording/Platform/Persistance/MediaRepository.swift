//
//  MediaRepository.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.05.2021.
//

import Foundation

final class MediaRepository {
    
    private let fileManager: FileManager
    private let mediaFiles: [MediaFile] = [MediaFile]()
    
    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }
    
    func fetch() -> [MediaFile] {
        
    }
    
    func save(mediaFile: MediaFile) {
        
    }
    
}

private extension MediaRepository {
    
    var applicationDocumentsDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
}
