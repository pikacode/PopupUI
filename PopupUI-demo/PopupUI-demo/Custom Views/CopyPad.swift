//
//  CopyPad.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/22.
//

import SwiftUI
import PopupUI

struct CopyPad: View {
    
    let code: String
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "doc.on.doc")
                    .padding(.vertical, 8)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        UIPasteboard.general.string = code
                        PopupUI
                            .show(JustText("Copy success!"))
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
    }
    
}

extension View {
    
    func buttonStyle(_ bg: Color = .blue) -> some View {
        self
            .frame(width: 88)
            .padding(.vertical, 4)
            .foregroundColor(.white)
            .background(bg)
            .cornerRadius(10)
    }
    
    
    func previewStyle() -> some View {
        ZStack {
            Color.black.opacity(0.5)
            self
        }
        .edgesIgnoringSafeArea(.all)
        .popupUI()
    }
    
}
 
