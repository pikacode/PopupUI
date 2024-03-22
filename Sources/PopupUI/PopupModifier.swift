//
//  PopupModifier.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/13.
//

import SwiftUI

struct PopupModifier: ViewModifier {
    
    @EnvironmentObject var status: PopupState
    
    var backgroundDuration: TimeInterval { (configuration.from.duration) / 2 }
    
    var configuration: PopupConfiguration { PopupUI.popups.last?.configuration ?? PopupConfiguration.default }
    
    @StateObject var keyboardHelper = KeyboardHeightHelper()
    
    func body(content: Content) -> some View {
        content
            .overlay {
                Group {
                    configuration.background
                        .opacity(backgroundOpacity)
                        .animation(backgroundAnimation, value: UUID())
                        .allowsHitTesting(configuration.isBackgroundOpaque)
                        .onTapGesture {
                            if let popup = PopupUI.popups.last(where: { $0.configuration.dismissWhenTapBackground }) {
                                PopupUI.hide(popup.uniqueID)
                            }
                        }
                    
                    ForEach(PopupUI.popups, id: \.uniqueID) {
                        $0.popupView
                    }
                }
                .edgesIgnoringSafeArea(.all)
            }
    }
    
    var backgroundAnimation: Animation? {
        guard let last = PopupUI.popups.last else { return nil }
        switch last.configuration.status {
        case .show:
            return last.configuration.from.animation
        case .hide:
            return last.configuration.to.animation
        default:
            return nil
        }
    }
    
    var backgroundOpacity: CGFloat {
        switch PopupUI.popups.count {
        case 1:
            if let status = PopupUI.popups.last?.configuration.status {
                switch status {
                case .show:
                    return 1
                default:
                    return 0
                }
            } else {
                return 1
            }
        case 2...:
            return 1
        default:
            return 0
        }
    }
    
}
