//
//  AliasView.swift
//  Alias
//
//  Created by pan on 6/7/20.
//  Copyright © 2020 pan. All rights reserved.
//
//



import SwiftUI
import SwiftSocket

struct RootView: View {
    let homeView: HomeView
    let meView: MeView
    @EnvironmentObject var room: ChatRoom
    
    
    init() {
        homeView = HomeView()
        meView = MeView()
    }
    
    var body: some View {
        NavigationView {
            TabView {
                homeView
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                    .tabItem {
                        Image(systemName: "message.fill")
                        Text("聊天室")
                    }
      
                meView
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("我")
                    }

            }
        }
    }
}

private struct Json: Codable {
    var id: String
    var owner: String
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
