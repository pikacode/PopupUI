//
//  PopupModifier.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/13.
//

import SwiftUI

struct PopupModifier: ViewModifier {
    
    @EnvironmentObject var status: PopupUI.State
    
    var display: Bool { PopupUI.popups.count > 0 }
    
    var popup: PopupUI? { PopupUI.popups.last }
    
    var configuration: PopupConfiguration { popup?.popupView.configuration ?? .default }
    
    func body(content: Content) -> some View {
        ZStack {
            
            content
            
            Group {
                PopupView.sharedBackground
                    .onTapGesture {
                        popup?.hide()
                    }
                
                ForEach(PopupUI.popups, id: \.id) {
                    $0.popupView
                }
            }
            .edgesIgnoringSafeArea(.all)

        }
    }
    
   
}
