//
//  BottomConfirmDialog.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/22.
//

import SwiftUI
import PopupUI

struct BottomConfirmDialog: View {

    var body: some View {
        VStack {
            
            HStack {
                
                Spacer()
                
                Text("Continue to finish")
                    .font(.title2)
                    .padding()
                    .foregroundColor(.black)
                    .padding(.leading, 33)
                
                Spacer()
                
                Image(systemName: "xmark")
                    .resizable()
                    .opacity(0.3)
                    .frame(width: 15, height: 15)
                    .foregroundColor(.black)
                    .padding(.trailing, 33)
                    .onTapGesture {
                        PopupUI.hide()
                    }
            }
            .padding(.top, 20)
            
 
            
            Text("You will be redirected to the finish page.")
                .font(.subheadline)
                .foregroundColor(.black.opacity(0.5))
          
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.green)
                .padding()
            
            HStack {
                Button("Continue") {
                    PopupUI.hide()
                }
                .frame(maxWidth: .infinity, minHeight: 44)
                .padding(.horizontal, 18)
                .foregroundColor(.white)
                .background(.blue)
                .cornerRadius(10)
                .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
    }
    
}

#Preview {
    BottomConfirmDialog()
        .previewStyle()
}
