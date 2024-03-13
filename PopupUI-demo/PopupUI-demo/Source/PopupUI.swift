//
//  PopupUI.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/13.
//

import SwiftUI

class PopupUI: ObservableObject {
    
    
    static let shared = PopupUI()
    
    let popupView = PopupView.shared
    
    static var popups: [PopupUI] = []
    
    @discardableResult
    static func show<PopupContent: View>(@ViewBuilder _ view: @escaping () -> PopupContent,
                                         config: (PopupConfiguration) -> () = PopupConfiguration.sharedBlock) -> PopupUI {
        
        let configuration = PopupConfiguration.default.copy()
        config(configuration)
        
        if configuration.id == PopupView.sharedId {
            PopupView.shared.content = AnyView(view())
            PopupView.shared.isPresented = true
        } else {
            let popup = PopupView(content: AnyView(view()), configuration: configuration)
            popup.isPresented = true
            popups.append(PopupUI())
        }
        
        withAnimation {
//            PopupUI().isPresented = true
        }
        
        return PopupUI()
    }
    
    static func hide() {
        
        withAnimation {
//            PopupUI().isPresented = false
        }
    }
    
}
