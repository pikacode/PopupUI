//
//  ContentView.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/13.
// 280x608

import SwiftUI
import PopupUI

struct ContentView: View {
    
    @State var from: PopupPosition = .center
    
    @State var backgroundColor: Color = .black.opacity(0.5)
    @State var stay: TimeInterval = 2
    @State var padding: CGFloat = 0
    @State var isSafeArea: Bool = true
    
    var body: some View {
        List {
            
            Section {
                
                HStack {
                    Text("Show")
                        .buttonStyle()
                        .onTapGesture {
                            PopupUI
                                .show(GetCustomView())
                                .from(from)     //also .from(.center, .easeIn(duration: 0.3), scale: 0.5, opacity: 0.5)
                                .stay(stay)
                                .background(backgroundColor)
                                .padding(padding * 10)
                                .isSafeArea(isSafeArea)
                                .dismissWhenTapBackground(true)
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
                    Stepper("Stay:      \(Int(stay))", value: $stay, in: 0...100)
                    
                    ColorPicker("Background", selection: $backgroundColor)

                    Stepper("Padding:       \(Int(padding * 10))", value: $padding, in: 0...50)
                    
                    Toggle("Is Safe Area", isOn: $isSafeArea)
                }
                .frame(height: 20)
                
            } header: {
                Text("Display & Parameters")
            }
            
            Section {
                CopyPad(code: code)
            } header: {
                Text("Code Generation")
            }
            
        }
    }
    
}

extension ContentView {
    
    @ViewBuilder
    func GetCustomView() -> some View {
        switch from {
        case .center:
            if stay > 2 {
                CenterConfirmDialog()
            } else {
                JustText()
            }
            
        case .bottom:
            if padding > 0 || isSafeArea {
                InputView()
            } else {
                BottomConfirmDialog()
            }
            
        case .left, .right:
            SideSheet()
            
        case .top:
            if padding > 0 || isSafeArea {
                NotificationView()
            } else {
                TopToastView()
            }
        }
    }
    
}

extension ContentView {
    var code: String {
                                    """
                                    PopupUI
                                        .show(AnyCustomView())
                                        .from(.\(from.rawValue))
                                        .stay(\(Int(stay)))
                                        .background(.backgroundColor)
                                        .padding(\(Int(padding * 10)))
                                        .isSafeArea(\(isSafeArea))
                                    
                                    PopupUI
                                        .hide()
                                    """
    }
}

#Preview {
    ContentView()
        .popupUI()
}
