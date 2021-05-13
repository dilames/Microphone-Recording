//
//  Action+enabledIf.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 29.01.2021.
//

import ReactiveSwift

extension Action where Value == Void {
    
    /// Initializes an `Action` that uses a property as its state.
    ///
    /// When the `Action` is asked to start the execution, a unit of work — represented by
    /// a `SignalProducer` — would be created by invoking `execute` with the latest value
    /// of the state.
    ///
    /// - parameters:
    ///   - state: A property to be the state of the `Action`.
    ///   - enabledIf: A property to be a isEnabled of the `Action`.
    ///   - execute: A closure that produces a unit of work, as `SignalProducer`, to
    ///              be executed by the `Action`.
    public convenience init<P: PropertyProtocol>(state: P,
                                                 enabledIf isEnabled: Property<Bool>,
                                                 execute: @escaping (P.Value) -> SignalProducer<Output, Error>) {
        self.init(state: state.combineLatest(with: isEnabled).map { $0.0 },
                  enabledIf: { state in return isEnabled.value },
                  execute: { state, _ in execute(state) })
    }
    
}
