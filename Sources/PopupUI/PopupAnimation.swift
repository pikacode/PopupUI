//
//  PopupAnimation.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/13.
//

import SwiftUI

public class PopupAnimation {
    
    public static var `default` = PopupAnimation(.center, .spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0.35))

    public var position: PopupPosition

    public var animation: Animation
    
    let duration: TimeInterval

    public init(_ position: PopupPosition = PopupAnimation.default.position, _ animation: Animation = PopupAnimation.default.animation) {
        self.position = position
        self.animation = animation
        self.duration = animation.duration
    }

}

extension PopupAnimation {
    @discardableResult
    public func position(_ position: PopupPosition) -> PopupAnimation {
        self.position = position
        return self
    }
    
    @discardableResult
    public func animation(_ animation: Animation) -> PopupAnimation {
        self.animation = animation
        return self
    }
}

extension Animation {
    var duration: TimeInterval {
        TimeInterval(description.components(separatedBy: ",").first(where: { $0.contains("duration") })?.components(separatedBy: "duration: ").last ??
                     description.components(separatedBy: ",").first(where: { $0.contains("response") })?.components(separatedBy: "response: ").last  ??
                     "0.35") ?? 0.35
    }
}
