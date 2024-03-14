//
//  PopupView.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/13.
//

import SwiftUI

typealias PopupViewID = String

struct PopupView: View {
    
    enum Status {
        case prepare
        case show
        case hide
    }
        
    static var sharedId: PopupViewID = "PopupView.id.shared"
    static var sharedBackground: AnyView = AnyView(Color.clear.opacity(0.4))
    
    @State var content: any View
    @EnvironmentObject var state: PopupUI.State
    
    @Binding var status: Status {
        didSet {
            PopupUI.statusChanged()
        }
    }
    
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
