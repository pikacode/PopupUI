//
//  ToastView.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/22.
//

import SwiftUI
import PopupUI

struct TopToastView: View {

    //浅蓝色背景加文案 撑满屏幕宽
    var body: some View {
        Text("This is a top toast. Long text will be truncated. You can add a button to dismiss it.")
            .frame(maxWidth: .infinity)
            .padding()
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            .background(Color.accentColor.opacity(0.8))
            .foregroundColor(.white)
    }
    
}

#Preview {
    TopToastView()
        .previewStyle()
}
