//
//  PopupView.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/13.
//

import SwiftUI
import Combine

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
    
    private let shoudHideSubject = CurrentValueSubject<Bool, Never>(false)
    
    var id: String {
        get { configuration.id }
        set { configuration.id = newValue }
    }
    
    let internalID = UUID().description

    @State var size: CGSize = .zero
    
    var body: some View {
        
            AnyView(content)
                .scaleEffect(scale)
                .opacity(status == .show ? 1 : 0)
                .animation(status == .show ? configuration.from.animation : configuration.to.animation, value: UUID())
                .offset(offset)
                .onReceive(shoudHideSubject, perform: { o in
                    if shoudHideSubject.value {
                        hide()
                    }
                })
                .background(
                    GeometryReader(content: { proxy in
                        Color.clear
                            .onAppear(perform: {
                                size = proxy.size
                            })
                    })
                )
                .onAppear(perform: {
                    show()
                })
                .onTapGesture {
                    PopupUI.hide(internalID)
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
        if let stayDuration = configuration.stay {
            DispatchQueue.main.after(stayDuration) {
                PopupUI.hide(internalID)
            }
        }
    }
    
    func hide() {
        status = .hide
    }
    
    func shouldHide() {
        shoudHideSubject.send(true)
    }
    
   
    
}

// MARK: - Animation
extension PopupView {
    
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
    
    var screenWith: CGFloat { UIScreen.main.bounds.width }
    var screenHeight: CGFloat { UIScreen.main.bounds.height }
    var width: CGFloat { size.width }
    var height: CGFloat { size.height }
    
    var offset_prepare: CGSize {
        switch configuration.from.position {
        case .center:
            return CGSize.zero
        case .top:
            return CGSize(width: 0, height: -(screenHeight + height) / 2)
        case .bottom:
            return CGSize(width: 0, height: (screenHeight + height) / 2)
        case .left:
            return CGSize(width: -(screenWith + width) / 2, height: 0)
        case .right:
            return CGSize(width: (screenWith + width) / 2, height: 0)
        }
    }
    
    var offset_show: CGSize {
        let insets = configuration.edgeInsets
        switch configuration.from.position {
        case .center:
            return CGSize.zero
        case .top:
            return CGSize(width: 0, height: -(screenHeight - height) / 2 + insets.top)
        case .bottom:
            return CGSize(width: 0, height: (screenHeight - height) / 2 - insets.bottom)
        case .left:
            return CGSize(width: -(screenWith - width) / 2 + insets.left, height: 0)
        case .right:
            return CGSize(width: (screenWith - width) / 2 - insets.right, height: 0)
        }
    }
    
    var offset_hide: CGSize {
        switch configuration.to.position {
        case .center:
            return offset_show
        case .top:
            return CGSize(width: offset_show.width, height: -(screenHeight + height) / 2)
        case .bottom:
            return CGSize(width: offset_show.width, height: (screenHeight + height) / 2)
        case .left:
            return CGSize(width: -(screenWith + width) / 2, height: offset_show.height)
        case .right:
            return CGSize(width: (screenWith + width) / 2, height: offset_show.height)
        }
    }
    
    var offset: CGSize {
        switch status {
        case .prepare:
            return offset_prepare
        case .show:
            return offset_show
        case .hide:
            return offset_hide
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
