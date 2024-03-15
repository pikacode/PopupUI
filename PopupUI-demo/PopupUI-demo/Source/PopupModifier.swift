//
//  PopupModifier.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/13.
//

import SwiftUI

struct PopupModifier: ViewModifier {
    
    @EnvironmentObject var status: PopupState
    
    var backgroundDuration: TimeInterval {
        return (PopupUI.popups.last?.configuration.from.duration ??
                PopupConfiguration.default.from.duration) / 2
    }
            
    func body(content: Content) -> some View {
        ZStack {
            
            content
            
            Group {
                
                PopupView.sharedBackground
                    .opacity(PopupUI.popups.count > 0 ? 1 : 0)
                    .animation(.easeIn(duration: backgroundDuration), value: UUID())
                    .onTapGesture {
                        if let popup = PopupUI.popups.last(where: { $0.configuration.dismissWhenTapOutside }) {
                            PopupUI.hide(popup.uniqueID)
                        }
                    }
                
                ForEach(PopupUI.popups, id: \.uniqueID) {
                    $0.popupView
//                        .environmentObject($0.state)
                }
            }
            .edgesIgnoringSafeArea(.all)

        }
    }
}
