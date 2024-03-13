//
//  PopupModifier.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/13.
//

import SwiftUI

struct PopupModifier: ViewModifier {
    
    @EnvironmentObject var status: PopupUI.Status
    
    func body(content: Content) -> some View {
        ZStack {
            if PopupUI.popups.count > 0 {
                ForEach(PopupUI.popups, id: \.popupView.id) { popup in
                    popup.popupView
//                        .transition(.move(edge: popup.configuration.position == .top ? .top : .bottom))
//                        .animation(popup.configuration.animation)
//                        .zIndex(1)
//
//                    PopupView(content: popup.content, configuration: popup.configuration)
//                        .transition(.move(edge: popup.configuration.position == .top ? .top : .bottom))
//                        .animation(popup.configuration.animation)
//                        .zIndex(1)
                        .id(popup.id)
                }
            }
            
            content
        }
    }
    
}
