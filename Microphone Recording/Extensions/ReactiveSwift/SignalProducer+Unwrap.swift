//
//  ReactiveSwift+Unwrap.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 28.01.2021.
//

import ReactiveSwift

extension SignalProducer {
    
    func unwrap<WrappedType>(strategy: FlattenStrategy) -> SignalProducer<WrappedType, Never> where Self.Value == SignalProducer<WrappedType, Error>,
                                                                                                    Self.Error == Never {
        return materializeResults()
            .flatMap(strategy) { (result) -> SignalProducer<WrappedType, Never> in
                if case .success(let value) = result { return value }
                return .empty
            }
    }
    
}

extension Signal {
    
    func unwrap<WrappedType>(strategy: FlattenStrategy) -> Signal<WrappedType, Never> where Value == Signal<WrappedType, Error>,
                                                                                            Error == Never {
        return materializeResults()
            .flatMap(strategy) { (result) -> Signal<WrappedType, Never> in
                if case .success(let value) = result { return value }
                return .empty
            }
    }
    
    static func value(_ value: Value) -> Signal<Value, Error> {
        return Signal { (observer, _) in
            observer.send(value: value)
            observer.sendCompleted()
        }
    }
    
}
