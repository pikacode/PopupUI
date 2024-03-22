//
//  SideSheet.swift
//  PopupUI-demo
//
//  Created by wxc on 2024/03/22.
//

import SwiftUI
import PopupUI

//个人中心侧边栏 顶部 avatar 下面是各种设置 覆盖70%的页面宽度
struct SideSheet: View {
    
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.blue)
                .opacity(0.6)
                .padding(.top, 80)
            
            Text("Mr. Poppy")
                .font(.title3)
                .foregroundColor(.black)
                .padding()
            
            Divider()
            
            
            List {
                Item(imageName: "person.fill", text: "Profile")
                Item(imageName: "bell", text: "Notifications")
                Item(imageName: "lock", text: "Privacy")
                Item(imageName: "questionmark.circle", text: "Help")
                Item(imageName: "gear", text: "Settings")
                Item(imageName: "arrow.down.doc.fill", text: "About")
                
            }
            .listStyle(.plain)
            
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width * 0.7)
        .background(Color.white)
    }
 
    struct Item: View {
        let imageName: String
        let text: String
        
        var body: some View {
            HStack {
                Image(systemName: imageName)
                    .foregroundColor(.blue)
                    .padding(.trailing)
                
                Text(text)
                    .foregroundColor(.black)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 6)
            .listRowSeparator(.hidden)
            .onTapGesture {
                PopupUI
                    .show(JustText(text))
                    .id("SideSheet Item")
                    .stay(1.5)
            }
        }
    }
    
}

#Preview {
    SideSheet()
        .previewStyle()
}
