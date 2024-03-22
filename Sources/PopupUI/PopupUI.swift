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

public class PopupUI: ObservableObject {
    
    public static var sharedId: PopupViewID = "PopupUI.ID.Shared"
    
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
    public static func show<PopupContent: View>(@ViewBuilder _ view: @escaping () -> PopupContent,
                                                id: PopupViewID = sharedId,
                                                config: (PopupConfiguration) -> () = { _ in }) -> PopupUI {
        return show(view(), id: id, config: config)
    }
    
    @discardableResult
    public static func show<PopupContent: View>(_ view: PopupContent,
                                                id: PopupViewID = sharedId,
                                                config: (PopupConfiguration) -> () = { _ in }) -> PopupUI {
        
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
    
    public static func hide(_ id: PopupViewID? = nil) {
        let idd = id ?? popups.last?.id ?? sharedId
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

// MARK: - Configuration
extension PopupUI {
    
    var configuration: PopupConfiguration {
        set { popupView.configuration = newValue }
        get { popupView.configuration }
    }
    
    @discardableResult
    public func id(_ v: PopupViewID) -> Self {
        configuration.id = v
        return self
    }
    
    @discardableResult
    public func dismissWhenTapBackground(_ v: Bool) -> Self {
        configuration.dismissWhenTapBackground = v
        return self
    }
    
    @discardableResult
    public func background<Background: View>(_ v: Background) -> Self {
        configuration.background = AnyView(v)
        return self
    }
    
    @discardableResult
    public func backgroundClick(_ v: @escaping () -> ()) -> Self {
        configuration.dismissCallback = { _ in v() }
        return self
    }
    
    @discardableResult
    public func avoidKeyboard(_ v: Bool) -> Self {
        configuration.isAvoidKeyboard = v
        return self
    }
    
    @discardableResult
    public func stay(_ v: TimeInterval) -> Self {
        configuration.stay = v
        return self
    }
    
    @discardableResult
    public func from(_ position: PopupPosition, _ animation: Animation = PopupAnimation.default.animation, scale: CGFloat? = nil, opacity: CGFloat? = nil) -> Self {
        configuration.from = PopupAnimation(position, animation)
        configuration.scaleFrom = scale
        configuration.opacityFrom = opacity
        to(position, animation, scale: scale, opacity: opacity)
        return self
    }
    
    @discardableResult
    public func to(_ position: PopupPosition, _ animation: Animation = PopupAnimation.default.animation, scale: CGFloat? = nil, opacity: CGFloat? = nil) -> Self {
        configuration.to = PopupAnimation(position, animation)
        configuration.scaleTo = scale
        configuration.opacityTo = opacity
        return self
    }
    
    @discardableResult
    public func isBackgroundOpaque(_ v: Bool) -> Self {
        configuration.isBackgroundOpaque = v
        return self
    }
    
    @discardableResult
    public func dismissCallback(_ v: @escaping (PopupViewID) -> ()) -> Self {
        configuration.dismissCallback = v
        return self
    }
    
    @discardableResult
    public func padding(_ v: CGFloat) -> Self {
        configuration.padding = v
        return self
    }
    
    @discardableResult
    public func isSafeArea(_ v: Bool) -> Self {
        configuration.isSafeArea = v
        return self
    }
    
    @discardableResult
    public func scaleFrom(_ v: CGFloat) -> Self {
        configuration.scaleFrom = v
        return self
    }
    
    @discardableResult
    public func scaleTo(_ v: CGFloat) -> Self {
        configuration.scaleTo = v
        return self
    }
    
    @discardableResult
    public func opacityFrom(_ v: CGFloat) -> Self {
        configuration.opacityFrom = v
        return self
    }
    
    @discardableResult
    public func opacityTo(_ v: CGFloat) -> Self {
        configuration.opacityTo = v
        return self
    }
    
    @discardableResult
    public func scale(from: CGFloat, to: CGFloat) -> Self {
        configuration.scaleFrom(from)
        configuration.scaleTo(to)
        return self
    }
    
    @discardableResult
    public func opacity(from: CGFloat, to: CGFloat) -> Self {
        configuration.opacityFrom(from)
        configuration.opacityTo(to)
        return self
    }
    
    @discardableResult
    public func config(_ config: PopupConfiguration) -> Self {
        configuration = config
        return self
    }
    
    @discardableResult
    public func style(_ style: PopupStyle) -> Self {
        configuration = style
        return self
    }
    
    @discardableResult
    public func duplicatedIdBehavior(_ v: PopupDuplicatedIdBehavior) -> Self {
        configuration.duplicatedIdBehavior = v
        return self
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
