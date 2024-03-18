//
//  PopupConfiguration.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/13.
//

import SwiftUI

public enum PopupPosition: String, CaseIterable {
    case top
    case bottom
    case left
    case right
    case center
}

public class PopupConfiguration {

    public static let `default` = PopupConfiguration()
        
    public var id = PopupUI.sharedId
    
    public var from = PopupAnimation()
    
    public var stay: TimeInterval?
    
    public var to = PopupAnimation()

    public var dismissWhenTapBackground = false
        
    public var background: AnyView = AnyView(Color.clear)
    
    public var padding: CGFloat = 0
    
    public var isSafeArea: Bool = false
    
    public var isOpaque: Bool = true
    
    public var isAvoidKeyboard = true
    
    public var keyboardPadding: CGFloat = 0
    
    public var dismissCallback: (PopupViewID) -> () = {_ in}
    
    public var scaleFrom: CGFloat?
    
    public var scaleTo: CGFloat?
    
    public var opacityFrom: CGFloat?
    
    public var opacityTo: CGFloat?
    
    var status: PopupStatus = .notAppear
}

extension PopupConfiguration {
    func copy() -> PopupConfiguration {
        let config = PopupConfiguration()
        config.id = id
        config.dismissWhenTapBackground = dismissWhenTapBackground
        config.from = from
        config.stay = stay
        config.to = to
        config.background = background
        config.isOpaque = isOpaque
        config.isAvoidKeyboard = isAvoidKeyboard
        config.padding = padding
        config.isSafeArea = isSafeArea
        config.keyboardPadding = keyboardPadding
        config.dismissCallback = dismissCallback
        return config
    }
    
    var edgeInsets: UIEdgeInsets {
        let window = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .filter { $0.isKeyWindow }.first
        let top = window?.safeAreaInsets.top ?? 0
        let bottom = window?.safeAreaInsets.bottom ?? 0
        let systemPadding: CGFloat = 0
        if isSafeArea {
            let left = window?.safeAreaInsets.left ?? 0
            let right = window?.safeAreaInsets.right ?? 0
            return UIEdgeInsets(top: top + padding, left: left + padding, bottom: bottom + padding + systemPadding, right: right + padding)
        } else {
            return UIEdgeInsets(top: padding, left: padding, bottom: padding + systemPadding, right: padding)
        }
    }
    
}

// MARK: - Configuration
extension PopupConfiguration {
    
    @discardableResult
    public func id(_ v: PopupViewID) -> Self {
        id = v
        return self
    }
    
    @discardableResult
    public func dismissWhenTapBackground(_ v: Bool) -> Self {
        dismissWhenTapBackground = v
        return self
    }
    
    @discardableResult
    public func background<Background: View>(_ v: Background) -> Self {
        background = AnyView(v)
        return self
    }
    
    @discardableResult
    public func backgroundClick(_ v: @escaping () -> ()) -> Self {
        dismissCallback = { _ in v() }
        return self
    }
    
    @discardableResult
    public func avoidKeyboard(_ v: Bool) -> Self {
        isAvoidKeyboard = v
        return self
    }
    
    @discardableResult
    public func stay(_ v: TimeInterval) -> Self {
        stay = v
        return self
    }
    
    @discardableResult
    public func from(_ position: PopupPosition, _ animation: Animation = PopupAnimation.default.animation) -> Self {
        from = PopupAnimation(position, animation: animation)
        return self
    }
    
    @discardableResult
    public func to(_ position: PopupPosition, _ animation: Animation = PopupAnimation.default.animation) -> Self {
        to = PopupAnimation(position, animation: animation)
        return self
    }
    
    @discardableResult
    public func isOpaque(_ v: Bool) -> Self {
        isOpaque = v
        return self
    }
    
    @discardableResult
    public func dismissCallback(_ v: @escaping (PopupViewID) -> ()) -> Self {
        dismissCallback = v
        return self
    }
    
    @discardableResult
    public func padding(_ v: CGFloat) -> Self {
        padding = v
        return self
    }
    
    @discardableResult
    public func isSafeArea(_ v: Bool) -> Self {
        isSafeArea = v
        return self
    }
    
    @discardableResult
    public func keyboardPadding(_ v: CGFloat) -> Self {
        keyboardPadding = v
        return self
    }
    
    @discardableResult
    public func scaleFrom(_ v: CGFloat) -> Self {
        scaleFrom = v
        return self
    }
    
    @discardableResult
    public func scaleTo(_ v: CGFloat) -> Self {
        scaleTo = v
        return self
    }
    
    @discardableResult
    public func opacityFrom(_ v: CGFloat) -> Self {
        opacityFrom = v
        return self
    }
    
    @discardableResult
    public func opacityTo(_ v: CGFloat) -> Self {
        opacityTo = v
        return self
    }
    
    @discardableResult
    public func scale(from: CGFloat, to: CGFloat) -> Self {
        scaleFrom(from)
        scaleTo(to)
        return self
    }
    
    @discardableResult
    public func opacity(from: CGFloat, to: CGFloat) -> Self {
        opacityFrom(from)
        opacityTo(to)
        return self
    }
    
}

class KeyboardHeightHelper: ObservableObject {

    @Published var keyboardHeight: CGFloat = 0
    @Published var keyboardDisplayed: Bool = false

    init() {
        self.listenForKeyboardNotifications()
    }

    private func listenForKeyboardNotifications() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                               object: nil,
                                               queue: .main) { (notification) in
            guard let userInfo = notification.userInfo,
                  let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

            self.keyboardHeight = keyboardRect.height
            self.keyboardDisplayed = true
        }

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                               object: nil,
                                               queue: .main) { (notification) in
            DispatchQueue.main.async {
                self.keyboardHeight = 0
                self.keyboardDisplayed = false
            }
        }
    }
}
