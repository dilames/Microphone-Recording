//
//  ViewModelContainer.swift
//  Flawless Feedback
//
//  Created by Andrew Chersky on 9/20/19.
//  Copyright © 2019 Ahmed Sulaiman. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift

private enum ViewModelContainerKeys {
    static var viewModel = "viewModel"
    static var lifetimeToken = "lifetimeToken"
}

// MARK: - ViewModelContainer
public protocol ViewModelContainer {
    associatedtype ViewModel
    var viewModel: ViewModel { get set }
    func didSetViewModel(_ viewModel: ViewModel, lifetime: Lifetime)
}

public extension ViewModelContainer where Self: NSObject {
    var viewModel: ViewModel {
        get { return associated(forKey: &ViewModelContainerKeys.viewModel)! }
        set { set(viewModel: newValue) }
    }
}

private extension ViewModelContainer where Self: NSObject {
    
    var didLoadTrigger: SignalProducer<(), Never> {
        return self is UIViewController ?
            reactive.trigger(for: #selector(UIViewController.viewDidLoad))
                .take(first: 1)
                .observe(on: UIScheduler())
                .producer
            : .init(value: ())
    }
    
    func set(viewModel model: ViewModel) {
        let token = Lifetime.Token()
        associate(value: token, forKey: &ViewModelContainerKeys.lifetimeToken)
        associate(value: model, forKey: &ViewModelContainerKeys.viewModel)
        reactive.makeBindingTarget { $1; $0.didSetViewModel(model, lifetime: Lifetime(token)) } <~ didLoadTrigger
    }
}
