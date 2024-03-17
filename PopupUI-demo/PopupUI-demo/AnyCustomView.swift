//
//  CustomPopupView.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/14.
//

import SwiftUI
import PopupUI

struct AnyCustomView: View {
    
    @State var text: String = ""

    var body: some View {
        VStack {
            Text("Hello, PopupUI!")
                .padding()
            
//            Image(systemName: "star.fill")
//                .font(.system(size: 30))
//                .foregroundColor(.yellow.opacity(0.7))
            
            TextField("keyboard avoiding", text: $text)
                .foregroundColor(.black.opacity(0.5))
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(.black.opacity(0.1))
                .cornerRadius(8)
                .padding(.horizontal, 40)
            
            Button(
                action: {
                    PopupUI.hide()
                },
                label: {
                    Text("Hide")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                        .padding(.vertical)
                }
            )
        }
        .frame(width: UIScreen.main.bounds.width - 80)
        .background(.black.opacity(0.05))
        .background(.white)
        .cornerRadius(20)
    }
    
}

#Preview {
    AnyCustomView()
}
