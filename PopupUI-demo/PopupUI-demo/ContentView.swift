//
//  ContentView.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/13.
//

import SwiftUI

struct ContentView: View {
    
    @State var from: PopupPosition = .center
    @State var to: PopupPosition = .bottom
    
    var body: some View {
        List {
            
            // Simple
            Section {
                Button("Show") {
                    PopupUI.show(CustomPopupView())
                }
                Button("Hide") {
                    PopupUI.hide()
                }
            } header: {
                Text("Simple")
            }
                
            // Advanced
            Section {
                Button("Show") {
                    PopupUI
                        .show(CustomPopupView())
                        .id("custom view 1")
                        .from(from)
                        .stay(2)
                        .to(to)
                }
                Button("Hide") {
                    PopupUI.hide("custom view 1")
                }
                Picker("    From", selection: $from) {
                    ForEach(PopupPosition.allCases, id: \.self) {
                        Text($0.rawValue.capitalized)
                            .id($0)
                    }
                }
                .frame(height: 20)
                Picker("    To", selection: $to) {
                    ForEach(PopupPosition.allCases, id: \.self) {
                        Text($0.rawValue.capitalized)
                            .id($0)
                    }
                }
                .frame(height: 20)
            } header: {
                Text("Advanced")
            }
            
        }
    }
}

#Preview {
    ContentView()
        .popupUI()
}
