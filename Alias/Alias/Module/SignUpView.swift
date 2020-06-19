//
//  SignUP.swift
//  Alias
//
//  Created by pan on 6/6/20.
//  Copyright © 2020 pan. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    @State var username: String = ""
    @State var password: String = ""
    @State var confirm: String = ""
    @State var mail: String = ""
    @State var msg: String = ""
    @State var showAlert: Bool = false;
    @State var code: Int = -3

    
    var body: some View {
        VStack {
            VStack {
                Image("signup")
                    .resizable()
                    .scaledToFit()
            }
            
            VStack {
                TextField("账号", text: self.$username)
                    .padding()
                    .background(Color.init(hex: "#f1f2f6"))
                    .cornerRadius(5)
                
                SecureField("密码", text: self.$password)
                    .padding()
                    .background(Color.init(hex: "#f1f2f6"))
                    .cornerRadius(5)
                
                SecureField("确认密码", text: self.$confirm)
                    .padding()
                    .background(Color.init(hex: "#f1f2f6"))
                    .cornerRadius(5)
                TextField("邮箱", text: self.$mail)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color.init(hex: "#f1f2f6"))
                    .cornerRadius(5)
            }.padding(.vertical, 20)
            
            HStack {
                Button(action: {
                    if self.username == "all" || self.username == "null" {
                        self.msg = "此名称已被服务器保留, 无法注册"
                        self.showAlert = true
                    }
                    
                    if self.username.isEmpty || self.password.isEmpty || self.confirm.isEmpty || self.mail.isEmpty {
                        self.msg = "请完善表单"
                        self.showAlert = true
                    }
                    
                    if self.password != self.confirm {
                        self.msg = "密码不一致"
                        self.showAlert = true;
                    }
                    
                    if self.showAlert {
                        return
                    }
                    
                    self.signUp()
                }) {
                    Text("注册")
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color.white)
                        .background(Color.init(hex: "#706fd3"))
                        .font(.system(size:18))
                    
                }.cornerRadius(6, antialiased: true)
            }
            
            Spacer()
            
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(self.code == 0 ? "注册成功": "注册失败"), message: Text(msg), dismissButton: .default(Text("确定")))
        }
        .padding(.horizontal)
    }
    
    func signUp() -> Void {
        let url = URL(string: "\(Config.API):5210/signup"
            + "?Authorization=FJa6AuH8"
            + "&username=\(username)"
            + "&password=\(password)"
            + "&mail=\(mail)")!
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
                                self.msg = "账号创建成功"
                            case 3:
                                self.msg = "用户名已存在"
                            default:
                                self.msg = "未知错误"
                        }
                        self.showAlert = true
                    }
                }
            }
        }.resume()
    }
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
