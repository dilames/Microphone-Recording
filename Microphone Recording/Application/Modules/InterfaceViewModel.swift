//
//  InterfaceViewModel.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.05.2021.
//

import ReactiveSwift

struct InterfaceViewModel: ViewModel {
    
    typealias UseCases = HasAudioListUseCase & HasAudioRecordingUseCase
    
    private let useCases: UseCases
    
    init(useCases: UseCases) {
        self.useCases = useCases
    }
    
}
