//
//  ContentView.swift
//  demo
//
//  Created by wxc on 2024/03/15.
//

import SwiftUI
import PopupUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .onTapGesture {
                    PopupUI.show(Text("asdasdasd"))
                }
        }
        .padding()
        .popupUI()
    }
}

#Preview {
    ContentView()
}
