//
//  Reactive+UICollectionView.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 16.03.2021.
//

import ReactiveSwift
import ReactiveCocoa

extension Reactive where Base: UICollectionView {
    
    var contentOffset: Property<CGPoint> {
        return Property(initial: base.contentOffset,
                        then: base.reactive
                            .producer(for: \.contentOffset)
                            .take(during: base.reactive.lifetime))
    }
    
    var contentSize: Property<CGSize> {
        return Property(initial: base.contentSize,
                        then: base.reactive
                            .producer(for: \.contentSize)
                            .take(during: base.reactive.lifetime))
    }
    
}
