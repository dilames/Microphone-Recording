//
//  ReactiveSwift+Timer.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 27.01.2021.
//

import ReactiveSwift

extension SignalProducer where Value == Date, Error == Never {
    
    public static func timer(interval: DispatchTimeInterval,
                             on scheduler: DateScheduler,
                             during timeout: DispatchTimeInterval) -> SignalProducer<Value, Error> {
        let boundary = Date().addingTimeInterval(timeout.timeInterval)
        return timer(interval: interval, on: scheduler).take(while: { $0 <= boundary })
    }
    
    public static func elapsingTimer(interval: DispatchTimeInterval,
                                     on scheduler: DateScheduler,
                                     during timeout: DispatchTimeInterval) -> SignalProducer<TimeInterval, Error> {
        let boundary = Date().addingTimeInterval(timeout.timeInterval)
        return timer(interval: interval, on: scheduler)
            .take(while: { $0 <= boundary })
            .map {
                if #available(iOS 13.0, *) {
                    return $0.distance(to: boundary)
                } else {
                    return boundary.timeIntervalSince($0)
                }
            }
    }
    
    public static func renewableTimer(
        interval: DispatchTimeInterval,
        on scheduler: DateScheduler,
        expiresOn timeout: Property<UInt64>
    ) -> SignalProducer<TimeInterval, Error> {
        return timer(interval: interval, on: scheduler)
            .map {
                let startDate = Date()
                let endDate = Date(timeIntervalSince1970: TimeInterval(timeout.value))
                let timeDifferenceInSeconds = endDate.timeIntervalSince(startDate)
                let boundary = Date().addingTimeInterval(timeDifferenceInSeconds)
                
                if #available(iOS 13.0, *) {
                    return $0.distance(to: boundary)
                } else {
                    return boundary.timeIntervalSince($0)
                }
            }
    }
    
}
