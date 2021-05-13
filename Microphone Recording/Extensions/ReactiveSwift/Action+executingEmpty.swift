//
//  Action+executingEmpty.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 09.02.2021.
//

import ReactiveSwift

extension Action {
    
    static var inputThrought: Action<Input, Input, Error> {
        return Action<Input, Input, Error>(execute: value)
    }
    
    static private func value(_ input: Input) -> SignalProducer<Input, Error> {
        return SignalProducer(value: input)
    }
}

extension Action where Output == Void, Input == Void, Error == Never {
    
    static var executingEmpty: Action {
        return Action(execute: emptyMethod)
    }
    
    static private func emptyMethod(_ input: Input) -> SignalProducer<Output, Error> {
        return .executingEmpty
    }
    
}

extension SignalProducer where Value == Void {
    /// A producer for a Signal that sends Void value and immediately completes.
    public static var executingEmpty: SignalProducer {
        return SignalProducer { observer, _ in
            observer.send(value: ())
            observer.sendCompleted()
        }
    }
}
