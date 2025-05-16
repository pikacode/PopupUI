//
//  PopupModifier.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/13.
//

import SwiftUI

struct PopupModifier: ViewModifier {
    
    @EnvironmentObject var status: PopupState
    
    var backgroundDuration: TimeInterval { (configuration.from.duration) / 2 }
    
    let scope: PopupScope
    
    var configuration: PopupConfiguration { popups.last?.configuration ?? PopupConfiguration.default }
    
    @StateObject var keyboardHelper = KeyboardHeightHelper()
    
    var popups: [PopupUI] { PopupUI.popups.filter({ $0.configuration.scope == scope }) }
    
    init(scope: PopupScope = .global) {
        self.scope = scope
    }
    
    func body(content: Content) -> some View {
        content
            .overlay {
                Group {
                    configuration.background
                        .opacity(backgroundOpacity)
                        .animation(backgroundAnimation, value: UUID())
                        .allowsHitTesting(configuration.isBackgroundOpaque)
                        .onTapGesture {
                            if let popup = popups.last(where: { $0.configuration.dismissWhenTapBackground }) {
                                PopupUI.hide(popup.uniqueID)
                            }
                        }
                    
                    ForEach(popups, id: \.uniqueID) {
                        $0.popupView
                    }
                }
                .edgesIgnoringSafeArea(.all)
            }
//            .overlay(content: {
//                GeometryReader(content: { geometry in
//                    EmptyView()
//                        .onAppear(perform: {
//                            PopupScope.sizes[scope.id] = geometry.size
//                        })
//                })
//            })
    }
    
    var backgroundAnimation: Animation? {
        guard let last = popups.last else { return nil }
        switch last.configuration.status {
        case .show:
            return last.configuration.from.animation
        case .hide:
            return last.configuration.to.animation
        default:
            return nil
        }
    }
    
    var backgroundOpacity: CGFloat {
        switch popups.count {
        case 1:
            if let status = popups.last?.configuration.status {
                switch status {
                case .show:
                    return 1
                default:
                    return 0
                }
            } else {
                return 1
            }
        case 2...:
            return 1
        default:
            return 0
        }
    }
    
}
