//
//  LoginView.swift
//  Alias
//
//  Created by pan on 6/6/20.
//  Copyright © 2020 pan. All rights reserved.
//

import SwiftUI


struct SignInView: View {
    @State var username: String = ""
    @State var password: String = ""
    @State var code: Int = -3
    @State var msg: String = ""
    @State var showAlert: Bool = false
    @Binding var isLoggedIn: Bool
    @EnvironmentObject var room: ChatRoom
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Image("login")
                        .resizable()
                        .scaledToFit()
                }
                .padding(.bottom, 20)
                
                VStack {
                    TextField("账号", text: self.$username)
                        .padding()
                        .background(Color(hex: "#f1f2f6"))
                        .cornerRadius(5)
                    
                    SecureField("密码", text: self.$password)
                        .padding()
                        .background(Color(hex: "#f1f2f6"))
                        .cornerRadius(5)
                }.padding(.bottom, 20)
                
                HStack {
                    NavigationLink(destination: SignUpView()) {
                        Text("注册")
                            .frame(height: 40)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color.white)
                            .background(Color(hex: "#706fd3"))
                            .font(.system(size:18))
                    }
                    .cornerRadius(6, antialiased: true)
                    
                    Spacer(minLength: 20)
                    
                    Button(action: {
                        if self.username.isEmpty || self.password.isEmpty {
                            self.msg = "请完善表单"
                            self.showAlert = true
                            return
                        }
                        
                        self.signIn()
                    }) {
                        Text("登陆")
                            .frame(height: 40)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color.white)
                            .background(Color(hex: "#706fd3"))
                            .font(.system(size:18))
                    }
                    .cornerRadius(6, antialiased: true)
                }
                
                Spacer()
                
            }
            .padding(.horizontal, 20)
            .onAppear {
                if let name = UserDefaults.standard.string(forKey: "username") {
                    self.username = name
                }
                if let pwd = UserDefaults.standard.string(forKey: "password") {
                    self.password = pwd
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("登陆失败"), message: Text(self.msg), dismissButton: .default(Text("确定")))
            }
        }
    }
    
    func signIn() -> Void {
        let url = URL(string: "\(Config.API):5210/login"
            + "?Authorization=FJa6AuH8"
            + "&username=\(username)"
            + "&password=\(password)")!
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { (dat, res, err) in
            if let data = dat {
                if let deRes = try? JSONDecoder().decode(Res.self, from: data) {
                    DispatchQueue.main.async {
                        self.code = deRes.code
                        switch deRes.code {
                            case -1:
                                self.msg = "API 认证错误"
                            case 0:
                                self.msg = "登陆成功"
                            case 2:
                                self.msg = "用户名或密码错误"
                            default:
                                self.msg = "未知错误"
                        }
                        print("code \(deRes.code)")
                        if deRes.code == 0 {
                            self.isLoggedIn = true
                            UserDefaults.standard.set(self.username, forKey: "username")
                            self.room.client.send(string: "{\"type\": \"online\", \"data\": \"\(self.username)\"}")
                            UserDefaults.standard.set(self.password, forKey: "password")
                        } else {
                            self.showAlert = true
                        }
                    }
                } else {
                    print("failed")
                }
            }
        }.resume()
    }
}

