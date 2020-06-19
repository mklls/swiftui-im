//
//  HomeView.swift
//  Alias
//
//  Created by pan on 6/7/20.
//  Copyright © 2020 pan. All rights reserved.
//

import SwiftUI
import SwiftSocket


struct HomeView: View {
    @EnvironmentObject var room: ChatRoom
    
    init() {
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().separatorStyle = .none
    }
    
    var body: some View {
        ZStack {
            VStack {
                Color(hex:"#706fd3").frame(height: 300)
            }
            List {
                ForEach(0..<room.friends.count, id: \.self) { index in
                    withAnimation(.easeInOut(duration: 1)) {
                        Cell(chat: self.room.friends[index], index: index)
                    }
                }
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }.padding(.top, 20)
        }
    }
}


struct Cell: View {
    let chat: Chat
    let index: Int
    @EnvironmentObject var room: ChatRoom
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Image(chat.with.icon)
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 48, height: 48)
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack(alignment: .top) {
                        Text(chat.with.username)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.primary)
                        Spacer()

                        Text(chat.messages.count > 0
                            ? Date.convert(now: chat.messages[chat.messages.count-1].createdAt)
                            : Date.convert(now: Date().timeStamp))
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                        
                    }
                    Text(chat.messages.count > 0
                        ? chat.messages[chat.messages.count-1].text : "")
                        .lineLimit(1)
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                    
                }
            }
            .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
            .navigationLink(destination: ChatView(with: index))
            Separator(color: Color(hex:"#DEDEDE")).padding(.leading, 76)
        }
        
    }
}
