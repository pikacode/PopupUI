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
            .environmentObject(PopupState.shared)
    }
}

class PopupState: ObservableObject {
    static let shared = PopupState()
    @Published var id = UUID()
    @Published var status: PopupStatus = .hide
    
    static func update() {
        shared.id = UUID()
    }
}

class PopupUI: ObservableObject {
    
    static var popups: [PopupUI] = [] {
        didSet {
            PopupState.update()
        }
    }
    
    var popupView: PopupView!
    
    var id: PopupViewID {
        set { popupView.id = newValue }
        get { popupView.id }
    }
    
    @ObservedObject var state = PopupState()
    
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
        return popup
    }
    
    var uniqueID: String { popupView.uniqueID }
    
    static func hide(_ id: PopupViewID? = nil) {
        let idd = id ?? popups.last?.id ?? PopupView.sharedId
        popups.forEach { popup in
            if popup.id == idd || popup.uniqueID == idd {
                popup.popupView.shouldHide()
                DispatchQueue.main.after(popup.popupView.configuration.to.duration) {
                    popups.removeAll { popup.uniqueID == $0.uniqueID }
                }
            }
        }
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
    
    @discardableResult
    func padding(_ v: CGFloat) -> Self {
        configuration.padding = v
        return self
    }
    
    @discardableResult
    func isSafeArea(_ v: Bool) -> Self {
        configuration.isSafeArea = v
        return self
    }
    
}
