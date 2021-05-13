//
//  MediaRepository.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.05.2021.
//

import Foundation

final class MediaRepository {
    
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d_MMMM_yyyy"
        return dateFormatter
    }()
    private let fileManager: FileManager
    private let mediaFiles: [MediaFile] = [MediaFile]()
    
    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }
    
    func create(mediaFileWithName name: String, extension: String = "m4a") -> MediaFile {
        let createdAt = Date()
        let url = applicationDocumentsDirectory
            .appendingPathComponent(name)
            .appendingPathComponent(Self.dateFormatter.string(from: createdAt))
            .appendingPathExtension(`extension`)
        let mediaFile = MediaFile(id: UUID(), url: url, createdAt: createdAt)
        return mediaFile
    }
    
    func fetch(completion: @escaping ([MediaFile]) -> Void) {
        completion([])
    }
    
    func save(mediaFile: MediaFile) {
        
    }
    
}

private extension MediaRepository {
    
    var applicationDocumentsDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
}
