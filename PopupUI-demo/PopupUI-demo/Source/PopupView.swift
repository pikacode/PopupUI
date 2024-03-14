//
//  PopupView.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/13.
//

import SwiftUI

typealias PopupViewID = String

enum PopupStatus {
    case prepare
    case show
    case hide
}

struct PopupView: View {
        
    static var sharedId: PopupViewID = "PopupView.id.shared"
    static var sharedBackground: AnyView = AnyView(Color.clear.opacity(0.4))
    
    let content: any View
//    @EnvironmentObject var state: PopupUI.State
    
    @State var status: PopupStatus = .prepare
    
    let configuration: PopupConfiguration
    
    var id: String {
        get { configuration.id }
        set { configuration.id = newValue }
    }
    
    let internalID = UUID()

    
    var body: some View {
        AnyView(content)
            .scaleEffect(scale)
            .opacity(status == .show ? 1 : 0)
            .animation(status == .show ? configuration.from.animation : configuration.to.animation, value: UUID())
            .onAppear(perform: {
                show()
            })
            .onTapGesture {
                hide()
            }
    }
    
    func prepare() {
        status = .prepare
        DispatchQueue.main.after(0.01) {
            show()
        }
    }
    
    func show() {
        status = .show
    }
    
    func hide() {
        status = .hide
    }
    
    var scale: CGFloat {
        switch status {
        case .prepare:
            if configuration.from.position == .center {
                return 0.5
            } else {
                return 0.9
            }
        case .show:
            return 1
        case .hide:
            if configuration.to.position == .center {
                return 0.5
            } else {
                return 0.9
            }
        }
    }
    
}


// MARK: - Configuration
extension PopupView {
    
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
