//
//  CustomPopupView.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/14.
//

import SwiftUI

struct AnyCustomView: View {

    var body: some View {
        VStack {
            Text("Hello, PopupUI!")
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
//                .shadow(radius: 2)
        }
    }
    
}

#Preview {
    AnyCustomView()
}
