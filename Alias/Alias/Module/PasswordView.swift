//
//  ChangePassword.swift
//  Alias
//
//  Created by pan on 6/12/20.
//  Copyright © 2020 pan. All rights reserved.
//

import SwiftUI

struct PasswordView: View {
    @EnvironmentObject var room: ChatRoom
    @State var password: String = ""
    @State var confirm: String = ""
    @State var captcha: String = ""
    @State var showAlert: Bool = false
    @State var msg: String = ""
    
    var body: some View {
        VStack {
            Image("password")
                .resizable()
                .scaledToFit()
            SecureField("密码", text: $password)
                .padding()
                .background(Color(hex: "#f1f2f6"))
                .cornerRadius(5)
            
            SecureField("确认密码", text: $confirm)
                .padding()
                .background(Color(hex: "#f1f2f6"))
                .cornerRadius(5)
            TextField("验证码", text: $captcha)
                .keyboardType(.numberPad)
                .padding()
                .background(Color(hex: "#f1f2f6"))
                .cornerRadius(5)
            
            HStack {
                Button(action: {
                    if self.password.isEmpty || self.confirm.isEmpty || self.captcha.isEmpty {
                        self.msg = "请完善信息"
                        self.showAlert = true
                        return
                    }
                    
                    if self.password != self.confirm {
                        self.msg = "密码不一致"
                        self.showAlert = true
                        return
                    }
                    self.resetPassword()
                }) {
                    Text("确认")
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color.white)
                        .background(Color.init(hex: "#706fd3"))
                        .font(.system(size:18))
                }
                .cornerRadius(6, antialiased: true)
                
                Button(action: {
                    self.requestCaptcha()
                }) {
                    Text("获取验证码")
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color.white)
                        .background(Color.init(hex: "#706fd3"))
                        .font(.system(size:18))
                }
                .cornerRadius(6, antialiased: true)
                
            }
            .padding(.top, 20)
            Spacer()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("提示信息"),
                  message: Text(self.msg),
                  dismissButton: .default(Text("确定")))
        }
        .navigationBarTitle("修改密码", displayMode: .inline)
//        .navigationBarHidden(true)
    }
    
    func resetPassword() -> Void {
        let url = URL(string: "\(Config.API):5210/resetpassword"
            + "?Authorization=FJa6AuH8"
            + "&username=\(self.room.me.username)"
            + "&password=\(self.password)"
            + "&captcha=\(self.captcha)")!
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { (dat, res, err) in
            if let data = dat {
                if let deRes = try? JSONDecoder().decode(Res.self, from: data) {
                    DispatchQueue.main.async {
                        switch deRes.code {
                            case -1:
                                self.msg = "API 认证错误"
                            case 0:
                                self.msg = "密码修改成功"
                            case 4:
                                self.msg = "验证码错误"
                            default:
                                self.msg = "未知错误"
                        }
                        self.showAlert = true
                    }
                } else {
                    print("failed")
                }
            }
        }.resume()
    }
    
    func requestCaptcha() -> Void {
        let url = URL(string: "\(Config.API):5210/captcha"
            + "?Authorization=FJa6AuH8"
            + "&username=\(self.room.me.username)")!
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { (dat, res, err) in
            if let data = dat {
                if let deRes = try? JSONDecoder().decode(Res.self, from: data) {
                    DispatchQueue.main.async {
                        switch deRes.code {
                            case -1:
                                self.msg = "API 认证错误"
                            case 0:
                                self.msg = "发送成功, 请注意查收"
                            case 4:
                                self.msg = "内部服务器错误, 请联系管理员"
                            default:
                                self.msg = "未知错误"
                        }
                        self.showAlert = true
                    }
                } else {
                    print("failed")
                }
            }
        }.resume()
    }
}


struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PasswordView().environmentObject(ChatRoom())
        }
    }
}
