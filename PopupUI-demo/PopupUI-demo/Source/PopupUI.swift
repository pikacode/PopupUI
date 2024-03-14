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
            .environmentObject(PopupUI.State.shared)
    }
}

class PopupUI: ObservableObject {
    
    class State: ObservableObject {
        static let shared = State()
        @Published var id = UUID()
        @Published var status: PopupStatus = .hide
    }
    
    static var popups: [PopupUI] = [] {
        didSet {
            statusChanged()
        }
    }
    
    static func statusChanged() {
        State.shared.id = UUID()
    }
    
    var popupView: PopupView!
    
    var id: PopupViewID {
        set { popupView.id = newValue }
        get { popupView.id }
    }
    
    @ObservedObject var state = State()
    
    @discardableResult
    static func show<PopupContent: View>(@ViewBuilder _ view: @escaping () -> PopupContent,
                                         id: PopupViewID = PopupView.sharedId,
                                         config: (PopupConfiguration) -> () = PopupConfiguration.sharedBlock) -> PopupUI {
        return show(view(), id: id, config: config)
    }
    
    @discardableResult
    static func show<PopupContent: View>(_ view: PopupContent,
                                         id: PopupViewID = PopupView.sharedId,
                                         config: (PopupConfiguration) -> () = PopupConfiguration.sharedBlock) -> PopupUI {
        
        let configuration = PopupConfiguration.default.copy()
        configuration.id = id
        config(configuration)
        
        let popup = PopupUI()
        let popupView = PopupView(content: AnyView(view), configuration: configuration)
        popup.popupView = popupView

        popups.append(popup)
//        popup.prepare()
        return popup
    }
    
    var internalID: UUID { popupView.internalID }
    
    static func hide(_ id: PopupViewID = PopupView.sharedId) {
        popups.forEach { popup in
            if popup.id == id {
                popup.hide()
                DispatchQueue.main.after(popup.configuration.to.duration) {
                    popups.removeAll { popup.internalID == $0.internalID }
                }
            }
        }
    }
    
    static func hide(_ popup: PopupUI) {
        hide(popup.id)
    }
    
//    init(popupView: PopupView) {
//        self.popupView = popupView
//    }
    
    func prepare() {
        popupView.prepare()
    }
    
    func show() {
        popupView.show()
    }
    
    func hide() {
//        state.status = .hide
        popupView.hide()
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
    func from(_ position: PopupPosition, _ animation: Animation = PopupAnimation.default.animation) -> Self {
        configuration.from = PopupAnimation(position, animation: animation)
        return self
    }
    
    @discardableResult
    func to(_ position: PopupPosition, _ animation: Animation = PopupAnimation.default.animation) -> Self {
        configuration.to = PopupAnimation(position, animation: animation)
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


extension DispatchQueue {
    func after(_ delay: TimeInterval, execute: @escaping () -> Void) {
        asyncAfter(deadline: .now() + delay, execute: execute)
    }

    static func mainSyncSafe(_ block: () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.sync(execute: block)
        }
    }
}

