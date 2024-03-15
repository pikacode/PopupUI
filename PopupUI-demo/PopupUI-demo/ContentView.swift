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
    
    @State var backgroundColor: Color = .black.opacity(0.5)
    @State var stay: TimeInterval = 2
    @State var padding: CGFloat = 0
    
    var body: some View {
        List {
            
            Section {
                
                HStack {
                    Text("Show")
                        .buttonStyle()
                        .onTapGesture {
                            PopupUI
                                .show(AnyCustomView())
                                .from(from)
                                .stay(stay)
                                .to(to)
                                .background(backgroundColor)
                                .padding(padding * 10)
                        }
                    
                    Text("Hide")
                        .buttonStyle()
                        .onTapGesture {
                            PopupUI.hide()
                        }
                }
                .frame(height: 44)
                
                Group {
                    
                    Picker("Brom", selection: $from) {
                        ForEach(PopupPosition.allCases, id: \.self) {
                            Text($0.rawValue.capitalized)
                                .id($0)
                        }
                    }
                                        
                    Picker("To", selection: $to) {
                        ForEach(PopupPosition.allCases, id: \.self) {
                            Text($0.rawValue.capitalized)
                                .id($0)
                        }
                    }
                    
                    ColorPicker("Background", selection: $backgroundColor)

                    Stepper("Stay:      \(Int(stay))", value: $stay, in: 0...100)

                    Stepper("Padding:       \(Int(padding * 10))", value: $padding, in: 0...50)
                }
                .frame(height: 20)
                
            } header: {
                Text("Display & Parameters")
            }
            
            Section {
                VStack {
                    HStack {
                        Image(systemName: "doc.on.doc")
                            .foregroundColor(.blue)
                            .onTapGesture {
                                UIPasteboard.general.string = code
                                PopupUI
                                    .show(Text("Copy success!").padding().background(Color.white))
                                    .stay(2)
                            }
                        Spacer()
                    }
                    
                    Text(code)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(.white)
                    .background(.black.opacity(0.7))
                }
            } header: {
                Text("Code Generation")
            }
            
        }
    }
    
    var code: String {
                                    """
                                    PopupUI
                                        .show(AnyCustomView())
                                        .from(.\(from.rawValue))
                                        .stay(\(Int(stay)))
                                        .to(.\(to.rawValue))
                                        .background(.backgroundColor)
                                        .padding(\(Int(padding * 10)))
                                    """
    }

    
}

extension View {
    
    func buttonStyle() -> some View {
        self
            .frame(width: 88)
            .padding(.vertical, 4)
            .foregroundColor(.white)
            .background(.blue)
            .cornerRadius(10)
    }
    
}

#Preview {
    ContentView()
        .popupUI()
}
