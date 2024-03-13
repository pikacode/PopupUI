//
//  PopupUI.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/13.
//

import SwiftUI

class PopupUI: ObservableObject {
    
    class Status: ObservableObject {
        static let shared = Status()
        @Published var id = UUID()
    }
    
    static var popups: [PopupUI] = []
    
    var popupView: PopupView
    
    @Published var isPresented = false
    
    @discardableResult
    static func show<PopupContent: View>(@ViewBuilder _ view: @escaping () -> PopupContent,
                                         config: (PopupConfiguration) -> () = PopupConfiguration.sharedBlock) -> PopupUI {
        
        let configuration = PopupConfiguration.default.copy()
        config(configuration)
        
        let popupView = PopupView(content: AnyView(view()), configuration: configuration)
        let popup = PopupUI(popupView: popupView)
        
        popup.show()
        popups.append(popup)
        return popup
    }
    
    static func hide(id: String = PopupView.sharedId) {
        popups.first { $0.popupView.id == id }?.isPresented = false
        popups.removeAll { $0.popupView.id == id }
    }
    
    init(popupView: PopupView) {
        self.popupView = popupView
    }
    
  
    
    func show() {
        isPresented = true
    }
    
    func hide() {
        isPresented = false
    }
    
    
    
}

// MARK: - Configuration
extension PopupUI {
    
    var configuration: PopupConfiguration { popupView.configuration }
    
    @discardableResult
    func id(_ v: String) -> Self {
        configuration.id = v
        return self
    }
    
    @discardableResult
    func position(_ v: PopupConfiguration.Position) -> Self {
        configuration.position = v
        return self
    }
    
    @discardableResult
    func dismissWhenTapOutside(_ v: Bool) -> Self {
        configuration.dismissWhenTapOutside = v
        return self
    }
    
    @discardableResult
    func duration(_ v: TimeInterval) -> Self {
        configuration.duration = v
        return self
    }
    
    @discardableResult
    func animation(_ v: Animation) -> Self {
        configuration.animation = v
        return self
    }
    
}
