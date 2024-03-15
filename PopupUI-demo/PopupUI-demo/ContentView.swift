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
                    PopupUI.show(AnyCustomView())
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
                        .show(AnyCustomView())
                        .id("custom view 1")
                        .from(from)
//                        .stay(2)
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
                
                
                
                /*
                 config.dismissWhenTapOutside = dismissWhenTapOutside
                 config.from = from
                 config.stay = stay
                 config.to = to
                 config.background = background
                 config.isOpaque = isOpaque
                 config.isAvoidKeyboard = isAvoidKeyboard
                 config.padding = padding
                 config.isSafeArea = isSafeArea
                 config.dismissCallback = dismissCallback
                 
                 */
                
            } header: {
                Text("Advanced")
            }
            
            Section {
                VStack {
                    //a copy button
                    HStack {
                        Spacer()
                        Image(systemName: "doc.on.doc")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                            .onTapGesture {
                                UIPasteboard.general.string = ""
                                PopupUI
                                    .show(Text("Copy success!").background(Color.gray.opacity(0.5)))
                                    .stay(2)
                            }
                    }
                    
                    Text("""
                            PopupUI
                                .show(AnyCustomView())
                                .id("custom view 1")
                                .from(from)
                                .stay(2)
                                .to(to)
                            """)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(.white)
                    .background(.black)
                }
            } header: {
                Text("Code")
            }
            
        }
    }
}

#Preview {
    ContentView()
        .popupUI()
}
