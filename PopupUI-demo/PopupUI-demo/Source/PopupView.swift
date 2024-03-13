//
//  PopupView.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/13.
//

import SwiftUI

struct PopupView: View {
        
    static var sharedId = "PopupView.id.shared"
    
    @State var content: any View
    
    var id: String {
        get { configuration.id }
        set { configuration.id = newValue }
    }

    let configuration: PopupConfiguration
    
    init(content: AnyView, configuration: PopupConfiguration) {
        self.content = content
        self.configuration = configuration
    }
    
    var body: some View {
        AnyView(content)
    }
    
}
