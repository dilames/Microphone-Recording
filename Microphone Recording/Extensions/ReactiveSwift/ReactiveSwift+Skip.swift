//
//  ReactiveSwift+Skip.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 26.01.2021.
//

import ReactiveSwift

extension SignalProducer where Value == Void {
    /// A producer for a Signal that sends Void value and immediately completes.
    public static var executingAction: SignalProducer {
        return SignalProducer { observer, _ in
            observer.send(value: ())
            observer.sendCompleted()
        }
    }
}

extension Signal where Value == Void {
    /// A producer for a Signal that sends Void value and immediately completes.
    public static var executingAction: Signal {
        return Signal { observer, _ in
            observer.send(value: ())
            observer.sendCompleted()
        }
    }
}

extension SignalProducer {
    
    public func retryIf(count: Int, predicate: @escaping (Self.Error) -> Bool) -> SignalProducer<Self.Value, Self.Error> {
        precondition(count >= 0)
        return flatMapError { error in
             if predicate(error) && count > 0 {
                return producer.retryIf(count: count - 1, predicate: predicate)
             } else {
                return producer
             }
         }
    }
    
    public func mapSkippingErrors(_ value: @escaping @autoclosure () -> Value) -> SignalProducer<Value, Never> {
        return flatMapError { _ in
            SignalProducer(value: value()).skipErrors()
        }
    }
    
    public func skipErrors() -> SignalProducer<Value, Never> {
        return flatMapError { _ in .empty }
    }
    
    public func skipValues() -> SignalProducer<(), Error> {
        return map { _ in () }
    }
}

extension Signal {
    
    public func skipErrors() -> Signal<Value, Never> {
        return flatMapError { _ in .empty }
    }
    
    public func skipValues() -> Signal<(), Error> {
        return map { _ in () }
    }
}

extension SignalProducer {
    // Should be used instead of -delay() to delay all events
    func stub(_ interval: TimeInterval, on scheduler: DateScheduler, predicate: ((Value) -> Bool)? = nil) -> SignalProducer {
        return SignalProducer { observer, lifetime in
            lifetime += self.start { event in
                
                var timeInterval = scheduler.currentDate
                if let value = event.value, let predicate = predicate {
                    timeInterval = timeInterval.addingTimeInterval(predicate(value) ? interval : 0)
                } else {
                    timeInterval = timeInterval.addingTimeInterval(interval)
                }
                
                scheduler.schedule(after: timeInterval) {
                    if !lifetime.hasEnded {
                        observer.send(event)
                    }
                }
                
            }
            lifetime.observeEnded {
                scheduler.schedule { observer.send(.interrupted) }
            }
        }
    }
    
}
