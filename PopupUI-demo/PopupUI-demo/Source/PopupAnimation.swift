//
//  PopupAnimation.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/13.
//

import SwiftUI

public class PopupAnimation {
    
    public static var `default` = PopupAnimation(.center, animation: .spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0.35))

    public let position: PopupPosition

    public let animation: Animation 
    
    let duration: TimeInterval

    public init(_ position: PopupPosition = PopupAnimation.default.position, animation: Animation = PopupAnimation.default.animation) {
        self.position = position
        self.animation = animation
        self.duration = animation.duration
    }

}

extension Animation {
    var duration: TimeInterval {
        TimeInterval(description.components(separatedBy: ",").first(where: { $0.contains("duration") })?.components(separatedBy: "duration: ").last ??
                     description.components(separatedBy: ",").first(where: { $0.contains("response") })?.components(separatedBy: "response: ").last  ??
                     "0.35") ?? 0.35
    }
}
