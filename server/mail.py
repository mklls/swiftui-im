'''
@Author: your name
@Date: 2020-06-13 08:45:14
@LastEditTime: 2020-06-19 19:40:46
@LastEditors: Please set LastEditors
@Description: In User Settings Edit
@FilePath: /server/outlook.py
'''
import requests, json
'''
这一部分需要好像需要有Azure订阅才能用
需要在Azure里面创建应用
'''

class Mail:

    def __init__(self):
        self.mail_url = "https://graph.microsoft.com/v1.0/me/sendMail"
        self.mail_headers = {
            "Authorization": "",
            "Content-type": "application/json"
        }
        self.mail_body = {
            "message": {
                "subject": "修改密码",
                "body": {
                    "contentType": "Text",
                    "content": "邮件正文"
                },
                "toRecipients": [{
                    "emailAddress": {
                        "address": ""
                    }}],
            },
            "saveToSentItems": "true"
        }
        self.access_token_url = "https://login.microsoftonline.com/xxxxxxxxxxxx/oauth2/token"
        self.access_token_body = {
            "grant_type": "password",
            "client_id": "xxxxxxxxxxxx",
            "client_secret": "xxxxxxxxxxx",
            "resource": "https://graph.microsoft.com",
            "username": "xxxxxxxx",
            "password": "xxxxxxxx"
        }

        r = requests.post(self.access_token_url, data=self.access_token_body)
        response = json.loads(r.text)
        print("access_token 获取成功")
        self.mail_headers["Authorization"] = "Bearer " + response["access_token"]

    def send(self, to, content, subject="Alias 密码重置"):
        print(f"收件人 {to}")
        self.mail_body["message"]["toRecipients"][0]["emailAddress"]["address"] = to
        self.mail_body["message"]["subject"] = subject
        self.mail_body["message"]["body"]["content"] = \
            "欢迎使用密码重置服务, 您的验证码是 " \
            + content \
            + "\n10分钟内有效, 请尽快修改密码" \
            + "\n\n\n\n\n\n\n\n\n\n\n\n\n" \
            + "不信, 你可以等十分钟试试, 哈哈哈哈哈哈哈哈 😄😄😄😄😄😄"

        r = requests.post(self.mail_url, headers=self.mail_headers, data=json.dumps(self.mail_body))

        return r.status_code == 202


if __name__ == "__main__":
    test = Mail()
    if test.send("pzju@outlook.com", "123456"):
        print("发送成功")
