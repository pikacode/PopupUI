//
//  PopupUI.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/13.
//

import SwiftUI

extension View {
    public func popupUI() -> some View {
        self.modifier(PopupModifier())
            .environmentObject(PopupUI.Status.shared)
    }
}

class PopupUI: ObservableObject {
    
    class Status: ObservableObject {
        static let shared = Status()
        @Published var id = UUID()
    }
    
    static var popups: [PopupUI] = [] {
        didSet {
            changeStatus()
        }
    }
    
    static func changeStatus() {
        Status.shared.id = UUID()
    }
    
    var popupView: PopupView
    
    var id: PopupViewID {
        set { popupView.id = newValue }
        get { popupView.id }
    }
    
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
    func id(_ v: PopupViewID) -> Self {
        configuration.id = v
        return self
    }
    
    @discardableResult
    func dismissWhenTapOutside(_ v: Bool) -> Self {
        configuration.dismissWhenTapOutside = v
        return self
    }
    
    @discardableResult
    func background<Background: View>(_ v: Background) -> Self {
        configuration.background = AnyView(v)
        return self
    }
    
    @discardableResult
    func backgroundClick(_ v: @escaping () -> ()) -> Self {
        configuration.dismissCallback = { _ in v() }
        return self
    }
    
    @discardableResult
    func avoidKeyboard(_ v: Bool) -> Self {
        configuration.isAvoidKeyboard = v
        return self
    }
    
    @discardableResult
    func stay(_ v: TimeInterval) -> Self {
        configuration.stay = v
        return self
    }
    
    @discardableResult
    func from(_ position: PopupPosition, _ animation: Animation = .default, _ duration: TimeInterval = 0.25) -> Self {
        configuration.from = PopupAnimation(position, animation: animation, duration: duration)
        return self
    }
    
    @discardableResult
    func to(_ position: PopupPosition, _ animation: Animation = .default, _ duration: TimeInterval = 0.25) -> Self {
        configuration.to = PopupAnimation(position, animation: animation, duration: duration)
        return self
    }
    
    @discardableResult
    func isOpaque(_ v: Bool) -> Self {
        configuration.isOpaque = v
        return self
    }
    
    @discardableResult
    func dismissCallback(_ v: @escaping (PopupViewID) -> ()) -> Self {
        configuration.dismissCallback = v
        return self
    }
    
}
