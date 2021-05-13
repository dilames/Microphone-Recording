//
//  ReusableViewModelContainer.swift
//  Flawless Feedback
//
//  Created by Andrew Chersky on 9/26/19.
//  Copyright © 2019 Ahmed Sulaiman. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift

private enum ViewModelContainerKeys {
    static var viewModel = "viewModel"
    static var lifetimeToken = "lifetimeToken"
}

public protocol ReusableViewModelContainer: AnyObject {
    associatedtype ViewModel
    var viewModel: ViewModel? { get set }
    func prepareForReuse()
    func didSetViewModel(_ viewModel: ViewModel, lifetime: Lifetime)
}

private extension ReusableViewModelContainer where Self: NSObject {
    
    var didLoadTrigger: SignalProducer<(), Never> {
        return SignalProducer(value: ())
    }
    
    func set(viewModel model: ViewModel?) {
        dissociate(forKey: &ViewModelContainerKeys.lifetimeToken)
        dissociate(forKey: &ViewModelContainerKeys.viewModel)
        guard let model = model else { return }
        let token = Lifetime.Token()
        associate(value: token, forKey: &ViewModelContainerKeys.lifetimeToken)
        associate(value: model, forKey: &ViewModelContainerKeys.viewModel)
        reactive.makeBindingTarget { $1; $0.didSetViewModel(model, lifetime: Lifetime(token)) } <~ didLoadTrigger
    }
}

public extension ReusableViewModelContainer where Self: NSObject {
    var viewModel: ViewModel? {
        get { return associated(forKey: &ViewModelContainerKeys.viewModel)! }
        set { set(viewModel: newValue) }
    }
}
