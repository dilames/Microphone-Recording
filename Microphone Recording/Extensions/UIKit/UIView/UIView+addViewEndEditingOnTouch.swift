//
//  UIView+addViewEndEditingOnTouch.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 25.01.2021.
//

import ReactiveCocoa
import ReactiveSwift

extension UIView {
    
    func addViewEndEditingOnTouch() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapAction(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func viewTapAction(_ sender: Any) {
        endEditing(true)
    }
    
}

extension Reactive where Base: UIView {
    
    var endEditing: BindingTarget<Bool> {
        return makeBindingTarget(on: UIScheduler()) { $0.endEditing($1) }
    }
    
}
