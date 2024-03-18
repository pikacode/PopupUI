//
//  ContentView.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/13.
//

import SwiftUI
import PopupUI

struct ContentView: View {
    
    @State var from: PopupPosition = .center
    @State var to: PopupPosition = .center
    
    @State var backgroundColor: Color = .black.opacity(0.5)
    @State var stay: TimeInterval = 2
    @State var padding: CGFloat = 0
    @State var isSafeArea: Bool = false
    
    var body: some View {
        List {
            
            Section {
                
                HStack {
                    Text("Show")
                        .buttonStyle()
                        .onTapGesture {
                            PopupUI
                                .show(AnyCustomView())
                                .from(from)     //also .from(.center, .easeIn(duration: 0.3), scale: 0.5, opacity: 0.5)
                                .stay(stay)
                                .to(to)
                                .background(backgroundColor)
                                .padding(padding * 10)
                                .isSafeArea(isSafeArea)
                                .dismissCallback { id in
                                    print("dismissed ID: \(id)")
                                }
                        }
                    
                    Text("Hide")
                        .buttonStyle()
                        .onTapGesture {
                            PopupUI.hide()
                        }
                }
                .frame(height: 44)
                
                Group {
                    
                    Picker("From", selection: $from) {
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
                    
                    Toggle("Is Safe Area", isOn: $isSafeArea)
                }
                .frame(height: 20)
                
            } header: {
                Text("Display & Parameters")
            }
            
            Section {
                VStack {
                    HStack {
                        Image(systemName: "doc.on.doc")
                            .padding(.vertical, 8)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                UIPasteboard.general.string = code
                                PopupUI
                                    .show(
                                        Text("Copy success!")
                                            .padding()
                                            .foregroundColor(.white)
                                            .background(Color.black.opacity(0.7))
                                            .cornerRadius(8)
                                    )
                                    .stay(2)
                            }
                        Spacer()
                    }
                    
                    Text(code)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(.black.opacity(0.9))
                    .background(.black.opacity(0.05))
                    .cornerRadius(10)
                    .padding(.bottom)
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
                                        .isSafeArea(\(isSafeArea))
                                    
                                    PopupUI
                                        .hide()
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
