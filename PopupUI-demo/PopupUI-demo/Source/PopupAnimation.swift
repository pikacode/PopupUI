//
//  PopupAnimation.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/13.
//

import SwiftUI

class PopupAnimation {

    var position: PopupPosition = .bottom
    
    var animation: Animation = .default
    
    var duration: TimeInterval = 0.25

    init(_ position: PopupPosition = .bottom, animation: Animation = .default, duration: TimeInterval = 0.25) {
        self.position = position
        self.animation = animation
        self.duration = duration
    }

}
