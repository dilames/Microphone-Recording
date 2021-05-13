//
//  Reactive+UINavigationBar.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.03.2021.
//

import ReactiveSwift
import ReactiveCocoa

extension Reactive where Base: UINavigationBar {
    
    func verticalPositionAdjustment(for metrics: UIBarMetrics) -> BindingTarget<CGFloat> {
        return makeBindingTarget { $0.setTitleVerticalPositionAdjustment($1, for: metrics) }
    }
    
}
