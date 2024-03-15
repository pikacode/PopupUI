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

    public var dismissWhenTapOutside = false
        
    public var background: AnyView = AnyView(Color.clear)
    
    static var sharedBackground: AnyView = AnyView(Color.clear) {
        didSet {
            PopupState.update()
        }
    }
    
    public var isOpaque: Bool = false
    
    public var isAvoidKeyboard = true
    
    public var padding: CGFloat = 20
    
    public var isSafeArea: Bool = true
    
    var edgeInsets: UIEdgeInsets {
        if isSafeArea {
            let window = UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .compactMap { $0 as? UIWindowScene }
                .first?.windows
                .filter { $0.isKeyWindow }.first
            let top = window?.safeAreaInsets.top ?? 0
            let bottom = window?.safeAreaInsets.bottom ?? 0
            return UIEdgeInsets(top: top + padding, left: padding, bottom: bottom + padding, right: padding)
        } else {
            return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        }
    }
        
    public var dismissCallback: (PopupViewID) -> () = {_ in}
    
    func copy() -> PopupConfiguration {
        let config = PopupConfiguration()
        config.id = id
        config.dismissWhenTapOutside = dismissWhenTapOutside
        config.from = from
        config.stay = stay
        config.to = to
        config.background = background
        config.isOpaque = isOpaque
        config.isAvoidKeyboard = isAvoidKeyboard
        config.padding = padding
        config.isSafeArea = isSafeArea
        config.dismissCallback = dismissCallback
        return config
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
            self.keyboardHeight = 0
            self.keyboardDisplayed = false
        }
    }
}
