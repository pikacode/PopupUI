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
                                .from(from)     //or .from(.center, .easeIn(duration: 0.3), scale: 0.5, opacity: 0.5)
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
                    
                    HStack(spacing: 6) {
                        Text("Local Popup")
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(.yellow)
                    }
                    .background(.white)
                    .popupUI(scope: .custom(id: "local id"))
                    .onTapGesture {
                        let id = "top pop id"
                        if PopupUI.isShowing(id) {
                            PopupUI.hide(id)
                        } else {
                            PopupUI
                                .show({
                                    Text("something details to show")
                                        .frame(width: 200)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 4)
                                        .background(.blue).cornerRadius(4)
                                })
                                .from(.left)
                                .padding(300)
//                                .insets(right: -500)
                                .background(Color.clear)
                                .dismissWhenTapBackground(true)
                                .scope(.custom(id: "local id"))
                                .id(id)
                        }
                    }
                    
                    
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


#Preview(body: {
    
    VStack {
        
        Text("Local Popup")
            .padding()
            .frame(minWidth: 130, maxHeight: 30, alignment: .center)
            .background(.blue)
            .cornerRadius(10)
            .padding(.vertical, 4)
            .foregroundColor(.white)
            .onTapGesture {
                let id = "top pop id"
                print(PopupUI.isShowing(id))
                if PopupUI.isShowing(id) {
                    PopupUI.hide(id)
                } else {
                    PopupUI
                        .show(BubbleView())
                        .from(.center)
                        .insets(top: 60)
                        .background(Color.clear)
                        .dismissWhenTapBackground(true)
                        .scope(.custom(id: "local id"))
                        .id("top pop id")
                }
            }
            .popupUI(scope: .custom(id: "local id"))
        
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    .popupUI(scope: .global)
    
})


struct BubbleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.47933*width, y: 0))
        path.addCurve(to: CGPoint(x: width, y: height), control1: CGPoint(x: 0.65345*width, y: 0), control2: CGPoint(x: 0.80906*width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.addCurve(to: CGPoint(x: 0.21336*width, y: 0.55294*height), control1: CGPoint(x: 0.06453*width, y: height), control2: CGPoint(x: 0.13745*width, y: 0.7841*height))
        path.addLine(to: CGPoint(x: 0.22328*width, y: 0.52272*height))
        path.addCurve(to: CGPoint(x: 0.22825*width, y: 0.50758*height), control1: CGPoint(x: 0.22493*width, y: 0.51767*height), control2: CGPoint(x: 0.22659*width, y: 0.51263*height))
        path.addLine(to: CGPoint(x: 0.23821*width, y: 0.47728*height))
        path.addCurve(to: CGPoint(x: 0.47933*width, y: 0), control1: CGPoint(x: 0.31803*width, y: 0.23508*height), control2: CGPoint(x: 0.40045*width, y: 0))
        path.closeSubpath()
        return path
    }
}

struct BubbleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            BubbleShape().fill(Color.blue)
                .frame(width: 22, height: 8)
                .padding(.leading, 12)
            Text("some details to show")
                .padding(12)
                .foregroundColor(Color.white)
                .background(.blue)
                .cornerRadius(12, antialiased: true)
        }
    }
}

#Preview {
    BubbleView()
}
