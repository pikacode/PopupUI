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
                        .opacity(PopupUI.popups.count > 0 ? 1 : 0)
                        .animation(configuration.to.animation, value: UUID())
                        .allowsHitTesting(!configuration.isOpaque)
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
}
