//
//  JustText.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/22.
//

import SwiftUI
import PopupUI

struct JustText: View {
    
    let text: String
    let bg: Color
        
    var body: some View {
        Text(text)
            .font(.title3)
            .padding()
            .foregroundColor(.black)
            .background(bg)
            .cornerRadius(12)
            .shadow(radius: 2)
    }
    
    init(_ text: String = "🎉 Success!", _ bg: Color = .white) {
        self.text = text
        self.bg = bg
    }
    
}

#Preview {
    JustText()
        .previewStyle()
}


