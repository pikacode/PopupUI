//
//  PopupView.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/13.
//

import SwiftUI

struct PopupView: View {
    
    static let shared = PopupView(content: Text(verbatim: ""), configuration: PopupConfiguration.default)
    
    static var sharedId = "PopupView.id.shared"
    
    @State var content: any View
    
    @State var isPresented = false
    
    var id: String { configuration.id }

    let configuration: PopupConfiguration
    
    init(content: any View, isPresented: Bool = false, configuration: PopupConfiguration) {
        self.content = content
        self.isPresented = isPresented
        self.configuration = configuration
    }
    
    var body: some View {
        AnyView(content)
    }
    
}
