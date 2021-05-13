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
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter
    }()
    
    private static let dateTimeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd HH:mm:ss"
        return dateFormatter
    }()
    
    private let fileManager: FileManager
    private let repository: CoreDataRepository<CoreDataMediaFile>
    
    init(fileManager: FileManager = FileManager.default, coreDataProvider: CoreDataProvider) {
        self.fileManager = fileManager
        self.repository = CoreDataRepository(managedObjectContext: coreDataProvider.viewContext)
    }
    
    func create(mediaFileWithName name: String, extension: String = "m4a") -> MediaFile {
        let createdAt = Date()
        let documentsDirectoryUrl = documentsDirectory
        let fileUrl = documentsDirectoryUrl
            .appendingPathComponent(name + Self.stringDate(createdAt: createdAt))
            .appendingPathExtension(`extension`)
        if !fileManager.fileExists(atPath: documentsDirectoryUrl.path) {
            try? fileManager.createDirectory(atPath: documentsDirectoryUrl.path, withIntermediateDirectories: true, attributes: nil)
        }
        let mediaFile = MediaFile(id: UUID(), url: fileUrl, createdAt: createdAt)
        return mediaFile
    }
    
    func all() -> Result<[MediaFile], Error> {
        return repository.fetch(predicate: nil, sortDescriptors: nil).map {
            $0.compactMap {
                guard let id = $0.id,
                      let path = $0.url,
                      let createdAt = $0.createdAt,
                      fileManager.fileExists(atPath: path)
                else { return nil }
                return MediaFile(id: id, url: URL(fileURLWithPath: path), createdAt: createdAt)
            }
        }
    }
    
    func add(mediaFile: MediaFile) -> Result<MediaFile, Error> {
        let coreDataMediaFile = repository.create()
        return coreDataMediaFile.map {
            $0.createdAt = mediaFile.createdAt
            $0.id = mediaFile.id
            $0.url = mediaFile.url.path
            return mediaFile
        }
    }
    
    func save() -> Result<Bool, Error> {
        return repository.save()
    }
    
    static func stringDate(createdAt: Date) -> String {
        return dateFormatter.string(from: createdAt)
    }
    
    static func stringTime(createdAt: Date) -> String {
        return dateTimeFormatter.string(from: createdAt)
    }
}

private extension MediaRepository {
    
    var documentsDirectory: URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last!
    }
    
}
