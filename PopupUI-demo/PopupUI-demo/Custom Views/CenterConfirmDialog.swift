//
//  CenterConfirmDialog.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/22.
//

import SwiftUI
import PopupUI

struct CenterConfirmDialog: View {

    var body: some View {
        VStack {
            Text("Are you sure?")
                .font(.title)
                .padding()
                .foregroundColor(.black)
            
            Text("You can't undo this action.")
                .font(.subheadline)
                .foregroundColor(.black.opacity(0.5))
            
            HStack {
                Button("Cancel") {
                    PopupUI.hide()
                }
                .buttonStyle(.gray)
                .padding(.trailing)
                
                Button("OK") {
                    PopupUI.hide()
                }
                .buttonStyle()
            }
            .padding()
        }
        .frame(width: 300)
        .background(Color.white)
        .cornerRadius(12)
    }
    
}


#Preview {
    CenterConfirmDialog()
        .previewStyle()
}
