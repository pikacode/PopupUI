//
//  PopupAnimation.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/13.
//

import SwiftUI

class PopupAnimation {
    
    static var `default` = PopupAnimation(.center, animation: .spring(dampingFraction: 0.5, blendDuration: 0.2))

    let position: PopupPosition
    
    let animation: Animation 
    
    let duration: TimeInterval

    init(_ position: PopupPosition = PopupAnimation.default.position, animation: Animation = PopupAnimation.default.animation) {
        self.position = position
        self.animation = animation
        self.duration = TimeInterval(animation.description.components(separatedBy: ",").first(where: { $0.contains("duration") })?.components(separatedBy: "duration: ").last ?? "0.35") ?? 0.35
    }

}
