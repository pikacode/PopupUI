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
                    .position(.bottom)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
