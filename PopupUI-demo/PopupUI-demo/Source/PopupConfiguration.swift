//
//  PopupConfiguration.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/13.
//

import SwiftUI

public class PopupConfiguration {

    static let `default` = PopupConfiguration()
    
    static let sharedBlock: (PopupConfiguration) -> () = { _ in }
    
    enum Position {
        case top
        case bottom
        case left
        case right
        case center
    }
    
    
    var id = PopupView.sharedId
    var position: Position = .center
    var dismissWhenTapOutside = true
    
    var duration: TimeInterval = 0.3
    var animation: Animation = .easeInOut
    
    func copy() -> PopupConfiguration {
        let config = PopupConfiguration()
        config.id = id
        config.position = position
        config.dismissWhenTapOutside = dismissWhenTapOutside
        config.duration = duration
        config.animation = animation
        return config
    }
    
}

extension View {
    
    public func popupUI() -> some View {
        self.modifier(PopupModifier())
    }
    
}

struct PopupModifier: ViewModifier {
    
    @StateObject var popup = PopupUI.shared
    
    func body(content: Content) -> some View {
        ZStack {
            
        }
    }
    
}
