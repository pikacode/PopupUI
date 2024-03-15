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
                                         config: (PopupConfiguration) -> () = PopupConfiguration.sharedBlock) -> PopupView {
        return show(view(), id: id, config: config)
    }
    
    @discardableResult
    static func show<PopupContent: View>(_ view: PopupContent,
                                         id: PopupViewID = PopupView.sharedId,
                                         config: (PopupConfiguration) -> () = PopupConfiguration.sharedBlock) -> PopupView {
        
        let configuration = PopupConfiguration.default.copy()
        configuration.id = id
        config(configuration)
        
        let popup = PopupUI()
        let popupView = PopupView(content: AnyView(view), configuration: configuration)
        popup.popupView = popupView

        popups.append(popup)
        return popupView
    }
    
    var internalID: UUID { popupView.internalID }
    
    static func hide(_ id: PopupViewID = PopupView.sharedId) {
        popups.forEach { popup in
            if popup.id == id {
                popup.popupView.shouldHide()
                DispatchQueue.main.after(popup.popupView.configuration.to.duration) {
                    popups.removeAll { popup.internalID == $0.internalID }
                }
            }
        }
    }
    
    func hide() {
        PopupUI.hide(id)
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

