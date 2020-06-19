//
//  MeView.swift
//  Alias
//
//  Created by pan on 6/7/20.
//  Copyright © 2020 pan. All rights reserved.
//

import SwiftUI


struct MeView : View {
    @EnvironmentObject var room: ChatRoom
    @State var enableNotification: Bool = UserDefaults.standard.bool(forKey: "enableNotification")
    
    var body: some View {
        Form {
            Section {
                Header(user:
                    User(id: room.me.id,
                          username: room.me.username,
                          icon: room.me.icon,
                          mail: room.me.mail))
                    .cornerRadius(4)
                    .padding(.vertical, 20)
            }
            
            Section {
                HStack {
                    NavigationLink(destination: PasswordView()) {
                        Text("修改密码")
                            .font(.system(size: 16))
                    }
                    
                    Spacer()
                }
                
                HStack {
                    Toggle("", isOn: $enableNotification)
                        .toggleStyle(ColoredToggleStyle(label: "开启通知提示音",
                                                        onColor: Color(hex: "#6C63FF")) {
                            self.enableNotification = $0
                            self.room.enableNotification = self.enableNotification
                            UserDefaults.standard.set(self.enableNotification,
                                                      forKey: "enableNotification")
                        })
                }
            }
            
            Section {
                Image("me")
                    .resizable()
                    .scaledToFit()
            }
            
        }
    }
}



private struct Header: View {
    let user: User
    
    var body: some View {
        VStack() {
            HStack(spacing: 20) {
                Image(user.icon)
                    .resizable()
                    .cornerRadius(8)
                    .frame(width: 62, height: 62)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(user.username)
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(Color.white)
                    
                    HStack {
                        Text(user.mail)
                            .foregroundColor(Color.white)
                        Spacer()
                        Text("id：\(user.id)")
                            .foregroundColor(Color.white)
                    }
                }
            }
        }
        .padding(EdgeInsets(top: 20, leading: 24, bottom: 20, trailing: 16))
        .background(Color(hex:"#6C63FF"))
    }
}

