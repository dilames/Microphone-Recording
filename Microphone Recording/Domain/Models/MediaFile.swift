//
//  MediaFile.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.05.2021.
//

import Foundation

struct MediaFile: Hashable {
    let id: UUID
    let url: URL
    let createdAt: Date
}
