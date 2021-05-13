//
//  Reactive+UITableView.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 22.02.2021.
//

import ReactiveCocoa
import ReactiveSwift

extension Reactive where Base: UITableView {
    
    var backgroundView: BindingTarget<UIView?> {
        return makeBindingTarget {
            $0.backgroundView = $1
        }
    }
    
    var contentOffset: Property<CGPoint> {
        return Property(initial: base.contentOffset, then: base.reactive.producer(for: \.contentOffset))
    }
    
    var performUpdates: BindingTarget<Void> {
        return makeBindingTarget { tableView, _ in
            tableView.reloadData()
            UIView.performWithoutAnimation {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            tableView.setContentOffset(.zero, animated: false)
        }
    }
    
    var willDisplayCellForRowIndexPath: Signal<IndexPath, Never> {
        // swiftlint:disable force_cast
        let delegate = base.delegate as! NSObject
        // swiftlint:enable force_cast
        let selector = #selector(UITableViewDelegate.tableView(_:willDisplay:forRowAt:))
        return delegate.reactive.signal(for: selector).map { $0.last as? IndexPath }.skipNil()
    }
    
    var didSelectItemAtIndexPath: Signal<IndexPath, Never> {
        // swiftlint:disable force_cast
        let delegate = base.delegate as! NSObject
        // swiftlint:enable force_cast
        let selector = #selector(UITableViewDelegate.tableView(_:didSelectRowAt:))
        return delegate.reactive.signal(for: selector).map { $0.last as? IndexPath }.skipNil()
    }
    
}

extension Reactive where Base: UIScrollView {
    
    var scrollToTopAnimated: BindingTarget<Bool> {
        return makeBindingTarget { $0.setContentOffset(.zero, animated: $1) }
    }
    
}
