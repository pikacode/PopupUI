//
//  PopupView.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/13.
//

import SwiftUI
import Combine

public typealias PopupViewID = String

enum PopupStatus {
    case notAppear
    case prepare
    case show
    case hide
}

struct PopupView: View {
            
    let content: any View
//    @EnvironmentObject var state: PopupUI.State
    
    @State var status: PopupStatus = .notAppear
    
    @StateObject var keyboardHelper = KeyboardHeightHelper()
    
    let configuration: PopupConfiguration
    
    private let shoudHideSubject = CurrentValueSubject<Bool, Never>(false)
    
    var id: String {
        get { configuration.id }
        set { configuration.id = newValue }
    }
    
    let uniqueID = UUID().description

    @State var size: CGSize = UIScreen.main.bounds.size
    
    var body: some View {
        AnyView(content)
            .scaleEffect(scale)
            .opacity(opacity)
            .animation(animation, value: UUID())
            .offset(offset)
            .background(
                GeometryReader(content: { proxy in
                    Color.clear
                        .onAppear(perform: {
                            size = proxy.size
                        })
                })
            )
            .onReceive(shoudHideSubject, perform: { o in
                if shoudHideSubject.value {
                    hide()
                }
            })
            .onAppear(perform: {
                if PopupUI.popups.first(where: { $0.id == id && $0.uniqueID != uniqueID }) != nil {
                    PopupUI.popups.removeAll(where: { $0.uniqueID == uniqueID })
                    return
                }
                prepareToShow()
            })
    }
    
    func prepareToShow() {
        status = .prepare
        DispatchQueue.main.after(0.01) {
            show()
        }
    }
    
    var animation: Animation? {
        switch status {
        case .prepare, .notAppear:
            return nil
        case .show:
            return configuration.from.animation
        case .hide:
            return configuration.to.animation
        }
    }
    
    func show() {
        status = .show
        if let stayDuration = configuration.stay {
            DispatchQueue.main.after(configuration.from.duration + stayDuration) {
                PopupUI.hide(uniqueID)
            }
        }
    }
    
    func hide() {
        status = .hide
        configuration.dismissCallback(id)
    }
    
    func shouldHide() {
        shoudHideSubject.send(true)
    }
    
}

// MARK: - Animation
extension PopupView {
    
    var scale: CGFloat {
        switch status {
        case .prepare, .notAppear:
            if let scale = configuration.scaleFrom {
                return scale
            } else {
                if configuration.from.position == .center {
                    return 0.5
                } else {
                    return 1
                }
            }
        case .show:
            return 1
        case .hide:
            if let scale = configuration.scaleTo {
                return scale
            } else {
                if configuration.to.position == .center {
                    return 0.5
                } else {
                    return 1
                }
            }
        }
    }
    
    var opacity: CGFloat {
        switch status {
        case .prepare:
            if let opacity = configuration.opacityFrom {
                return opacity
            } else {            
                return 0
            }
        case .hide:
            if let opacity = configuration.opacityTo {
                return opacity
            } else {
                return 0
            }
        case .show:
            return 1
        case .notAppear:
            return 0
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
        var insets = configuration.edgeInsets
        
        if configuration.isAvoidKeyboard, configuration.from.position == .bottom, keyboardHelper.keyboardDisplayed {
            insets.bottom += keyboardHelper.keyboardHeight
            insets.bottom += configuration.keyboardPadding
        }
        
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
        case .prepare, .notAppear:
            return offset_prepare
        case .show:
            return offset_show
        case .hide:
            return offset_hide
        }
    }

    
}
