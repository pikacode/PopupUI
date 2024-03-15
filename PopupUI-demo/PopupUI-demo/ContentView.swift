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
            
            Section {
                
                HStack {
                    Text("Show")
                        .onTapGesture {
                            PopupUI
                                .show(AnyCustomView())
                                .from(from)
                                .stay(2)
                                .to(to)
                        }
                        .buttonStyle()
                    
                    Text("Hide")
                        .onTapGesture {
                            PopupUI.hide()
                        }
                        .buttonStyle()
                }
                .frame(height: 44)
                
                Group {
                    
                    Picker("from", selection: $from) {
                        ForEach(PopupPosition.allCases, id: \.self) {
                            Text($0.rawValue)
                                .id($0)
                        }
                    }
                                        
                    Picker("to", selection: $to) {
                        ForEach(PopupPosition.allCases, id: \.self) {
                            Text($0.rawValue)
                                .id($0)
                        }
                    }
                    
                    ColorPicker("background", selection: .constant(.black))

                    Stepper("stay", value: .constant(20), in: 0...100)
                    
                    Stepper("padding", value: .constant(20), in: 0...100)
                    
//                    Toggle("isSafeArea", isOn: .constant(true))
//                    
//                    Toggle("isOpaque", isOn: .constant(true))
//                    
//                    Toggle("isAvoidKeyboard", isOn: .constant(true))
//                 
//                    Toggle("dismissWhenTapOutside", isOn: .constant(true))
//                    
//                    TextField("dismissCallback", text: .constant("dismissCallback print text"))
//                        .frame(height: 30)
//                        .padding(.horizontal)
//                        .background(.gray.opacity(0.2))
//                        .cornerRadius(4)
                }
                .frame(height: 20)
                
            } header: {
                Text("Display & Parameters")
            }
            
            Section {
                VStack {
                    //a copy button
                    HStack {
                        
                        Image(systemName: "doc.on.doc")
//                            .font(.system(size: 15))
                            .foregroundColor(.blue)
                            .onTapGesture {
                                UIPasteboard.general.string = ""
                                PopupUI
                                    .show(Text("Copy success!").padding().background(Color.gray.opacity(0.5)))
                                    .stay(2)
                            }
                        Spacer()
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

extension View {
    
    func buttonStyle() -> some View{
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
