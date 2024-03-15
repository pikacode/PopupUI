//
//  PopupModifier.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/13.
//

import SwiftUI

struct PopupModifier: ViewModifier {
    
    @EnvironmentObject var status: PopupUI.State
            
    func body(content: Content) -> some View {
        ZStack {
            
            content
            
            Group {
                
                PopupView.sharedBackground
                    .onTapGesture {
                        if let popup = PopupUI.popups.last {
                            PopupUI.hide(popup.internalID)
                        }
                    }
                
                ForEach(PopupUI.popups, id: \.id) {
                    $0.popupView
                        .environmentObject($0.state)
                }
            }
            .edgesIgnoringSafeArea(.all)

        }
    }
}
