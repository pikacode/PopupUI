//
//  NotificationView.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/22.
//

import SwiftUI
import PopupUI

struct NotificationView: View {

    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "bell")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.blue)
                .padding()
            
            VStack(alignment: .leading) {
                HStack {
                    Text("New message")
                        .font(.title3)
                        .foregroundColor(.black)

                    Spacer()
                    
                    Text("2 min ago")
                        .font(.caption)
                        .foregroundColor(.black.opacity(0.5))
                }
                
                Text("You have a new message from someone.")
                    .font(.subheadline)
                    .lineLimit(1)
                    .foregroundColor(.black.opacity(0.5))
            }
            .padding(.trailing, 8)
            
            Spacer()
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(radius: 2)
        .padding(.horizontal, 18)
    }
    
}

#Preview {
    NotificationView()
        .previewStyle()
}
