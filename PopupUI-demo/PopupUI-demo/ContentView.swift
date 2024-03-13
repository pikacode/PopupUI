//
//  ContentView.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/13.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button("Show Popup") {
                PopupUI
                    .show {
                        Text("Hello, PopupUI!")
                    }
                    .from(.bottom, .easeIn, 0.25)
                    .stay(2)
                    .to(.left, .easeOut, 0.25)
            }
            Button("Hide Popup") {
                PopupUI.hide()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
