//
//  Chat.swift
//  Alias
//
//  Created by pan on 6/7/20.
//  Copyright © 2020 pan. All rights reserved.
//
import SwiftUI
import SwiftSocket


struct ChatView: View {
    @EnvironmentObject var room: ChatRoom
    let index: Int
    
    @State var msg: String = ""


    init(with index: Int) {
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().separatorStyle = .none
        self.index = index
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                CustomScrollView {
                    VStack(spacing: 0) {
                        ForEach(self.room.friends[self.index].messages) { msg in
                            withAnimation(.easeInOut(duration: 0.5)) {
                                ChatCell(message: msg,
                                         isMe:  msg.creator.id == self.room.me.id)
                            }
                        }
                    }
                }
                
                Send(proxy: proxy, text: self.$msg) {
                    if $0.isEmpty { return }
                    let msg = FakeMsg(text: $0, createdAt: Date().timeStamp,
                                      creator: self.room.me)
                    self.room.friends[self.index].messages.append(
                        Message(text: $0, createdAt: Date().timeStamp,
                                creator: self.room.me))
                    self.room.objectWillChange.send()
                    print(self.room.friends[self.index].messages)
                    do {
                        let dat = try JSONEncoder().encode(msg)
                        let msg = String(decoding: dat, as: UTF8.self)
                        let rawusr = self.room.friends[self.index].with.username
                        let usr = try JSONEncoder().encode(rawusr)
                        let to = String(decoding: usr, as: UTF8.self)
                        let str = "{\"type\":\"message\", \"data\":\(msg), \"to\":\(to)}"
                        self.room.client.send(string: str)
                    } catch let error {
                        print(error)
                    }
                }
            }
            .background(Color(hex: "#f1f2f6"))
        }
        .background(Color.init(hex: "#f1f2f6"))
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitle("\(self.room.friends[self.index].with.username)", displayMode: .inline)
    }
}


private struct Send: View {
    let proxy: GeometryProxy
    @Binding var text: String
    var onSend: (_ msg: String) -> Void
    @ObservedObject private var keyboard = KeyboardResponder()
    
    var body: some View {
        VStack(spacing: 0) {
            Separator(color: Color(hex: "#6c5ce7"))
            
            ZStack {
                Color(hex: "#f5f5f5")
                
                VStack {
                    HStack(spacing: 12) {
                        TextField("", text: $text)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(height: 40)
                            .cornerRadius(4)

                        SendButton(isDisabled: text.isEmpty) {
                            self.onSend(self.text)
                            self.text = ""
                        }
                    }
                    .frame(height: 56)
                    .padding(.horizontal, 12)
                    
                    Spacer()
                }
            }
            .frame(height: proxy.safeAreaInsets.bottom + 56)
        }
        .padding(.bottom, keyboard.currentHeight)
        .edgesIgnoringSafeArea(.bottom)
        .animation(.easeOut(duration: 0.16))
    }

}

private struct SendButton: View {
    let isDisabled: Bool
    let action: () -> ()

    var body: some View {
        Button(action: {
            withAnimation {
                self.action()
                self.clickCount += 1
                UIApplication.shared.endEditing()
            }
        }) {
            Image(systemName: "arrow.up.circle")
                .rotationEffect(.radians(2 * Double.pi * clickCount))
                .animation(.easeInOut)
        }
        .disabled(isDisabled)
    }
    
    @State private var clickCount: Double = 0
}

