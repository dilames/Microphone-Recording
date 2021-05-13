//
//  UIScrollView.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 25.01.2021.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

extension UIView {
    
    func onChangeKeyboardNotification(animateConstraintChanges changesClosure: @escaping (KeyboardChangeContext) -> Void) {
        NotificationCenter.default.reactive.keyboardChange
            .take(during: reactive.lifetime)
            .observe(on: UIScheduler())
            .observeValues {
                changesClosure($0)
                UIView.animate(
                    withDuration: $0.animationDuration,
                    animations: { [weak self] in self?.layoutIfNeeded() })
            }
    }
    
}

extension UIScrollView {
    
    func adjustInsetsOnKeyboardNotification(extraBottomInset: CGFloat = 0.0, scrollingToBottom: Bool = false) {
        NotificationCenter.default.reactive.keyboardChange
            .take(during: reactive.lifetime)
            .observe(on: UIScheduler())
            .observeValues { [weak self] context in
                guard let self = self else { return }
                UIView.animate(withDuration: context.animationDuration, animations: {
                    self.contentInset.bottom = UIScreen.main.bounds.height - context.endFrame.origin.y - extraBottomInset
                    self.verticalScrollIndicatorInsets.bottom = self.contentInset.bottom
                })
        }
        if scrollingToBottom {
            NotificationCenter.default.reactive
                .notifications(forName: UIResponder.keyboardWillShowNotification)
                .take(during: reactive.lifetime)
                .observeValues { [weak self] notification in
                    guard let self = self else { return }
                    if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
                        let yOffset = self.contentSize.height - self.bounds.height + self.contentInset.bottom
                        let offset = CGPoint(x: self.contentOffset.x, y: yOffset)
                        UIView.animate(withDuration: TimeInterval(duration), animations: {
                            self.setContentOffset(offset, animated: false)
                        })
                    }
            }
        }
    }
    
    func scrollToBottom(animated: Bool = false) {
        let yOffset = contentSize.height - bounds.height + contentInset.bottom
        let offset = CGPoint(x: contentOffset.x, y: yOffset)
        UIView.animate(withDuration: animated ?  0.3 : 0.0) {
            self.setContentOffset(offset, animated: false)
        }
    }
}
