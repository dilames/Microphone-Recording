//
//  ViewModelInterface.swift
//  Flawless Feedback
//
//  Created by Andrew Chersky on 9/20/19.
//  Copyright © 2019 Ahmed Sulaiman. All rights reserved.
//

public protocol ViewModel {
    associatedtype Input = Void
    associatedtype Output = Void
    func transform(_ input: Input) -> Output
}

public extension ViewModel where Input == Void, Output == Void {
    func transform(_ input: Input) -> Output {}
}

public extension ViewModel where Input == Void {
    func transform() -> Output { return transform(()) }
}
