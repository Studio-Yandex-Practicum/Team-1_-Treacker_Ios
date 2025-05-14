//
//  KeyboardObserver.swift
//  Core
//
//  Created by Konstantin Lyashenko on 17.04.2025.
//

import UIKit

public final class KeyboardObserver {

    // MARK: - Private Properties

    private weak var scrollView: UIScrollView?
    private var onKeyboardChange: ((CGFloat, TimeInterval, UIView.AnimationOptions) -> Void)?

    // MARK: - Init

    public init(
        scrollView: UIScrollView? = nil,
        onKeyboardChange: ((CGFloat, TimeInterval, UIView.AnimationOptions) -> Void)? = nil
    ) {
        self.scrollView = scrollView
        self.onKeyboardChange = onKeyboardChange
        registerForKeyboardNotifications()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Private Methods

    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    // MARK: - Actions

    @objc private func keyboardWillShow(notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }

        let options = UIView.AnimationOptions(rawValue: curveValue << 16)
        let height = keyboardFrame.height

        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.scrollView?.contentInset.bottom = height
            self.scrollView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
        })

        onKeyboardChange?(height, duration, options)
    }

    @objc private func keyboardWillHide(notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }

        let options = UIView.AnimationOptions(rawValue: curveValue << 16)

        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.scrollView?.contentInset = .zero
            self.scrollView?.scrollIndicatorInsets = .zero
        })

        onKeyboardChange?(0, duration, options)
    }
}
