//
//  PopupConfiguration.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/13.
//

import SwiftUI

enum PopupPosition {
    case top
    case bottom
    case left
    case right
    case center
}

public class PopupConfiguration {

    static let `default` = PopupConfiguration()
    
    static let sharedBlock: (PopupConfiguration) -> () = { _ in }
    
    var id = PopupView.sharedId
    
    var from = PopupAnimation()
    
    var stay: TimeInterval = .infinity
    
    var to = PopupAnimation()

    var dismissWhenTapOutside = true
        
    var background: AnyView = AnyView(Color.black.opacity(0.2))
    
    var isOpaque: Bool = false
    
    var isAvoidKeyboard = true
    
    var dismissCallback: (PopupViewID) -> () = {_ in}
    
    func copy() -> PopupConfiguration {
        let config = PopupConfiguration()
        config.id = id
        config.dismissWhenTapOutside = dismissWhenTapOutside
        config.from = from
        config.stay = stay
        config.to = to
        
        return config
    }
    
    func id(_ v: PopupViewID) -> Self {
        id = v
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
            self.keyboardHeight = 0
            self.keyboardDisplayed = false
        }
    }
}
