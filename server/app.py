#!/usr/bin/python3
'''
@Author: your name
@Date: 2020-06-06 15:43:18
@LastEditTime: 2020-06-13 19:07:00
@LastEditors: Please set LastEditors
@Description: In User Settings Edit
@FilePath: /server/app.py
'''

from flask import Flask, jsonify, request
from database import Database
from mail import Mail
import random


app = Flask(__name__)
db = Database()
CODE = "FJa6AuH8"
captcha = {"example": 423481}

@app.route('/')
# test
def hello_world():
    res = {
        "0": "喜欢看你的笑容",
        "1": "环绕着香甜的风",
        "2": "你戳中了我的审美点准确得好像针灸",
        "3": "我微微的颤抖",
        "4": "那紧张的喉咙",
        "5": "认真讲述了没做的梦",
        "6": "很生动",
        "7": "说实话我可不确定我能够陪你多久",
        "8": "没关系能博红颜一笑是我的温柔",
        "9": "等我们绕过几轮冬夏和春秋",
        "A": "还能不能和你遨游"
    }

    return jsonify(res)

DENIED = -1
PASS = 0
ARGUMENT = 1
MISMATCH = 2
DUPLICATE = 3
FAILED = 4
ACCESS_DENIED = {
            "ack": "failed",
            "message": "access denied",
            "code": DENIED
        }
EXPECTED_ARGUMENT = {
            "ack": "failed",
            "message": "expected argument",
            "code": ARGUMENT
        }
OK = {"ack": "succ", "message": "", "code": PASS}
INTERAL_ERROR = {"ack": "failed", "message": "", "code": FAILED}

@app.route('/login', methods=["GET", "POST"])
def login():
    global CODE
    username = request.args.get("username")
    password = request.args.get("password")
    auth = request.args.get("Authorization")
    if auth != CODE:
        return jsonify(ACCESS_DENIED)
    if not username or not password:
        return jsonify(EXPECTED_ARGUMENT)
    
    if db.login(username, password):
        res = OK
    else:
        res = {
            "ack": "failed",
            "message": "invalid username/password",
            "code": MISMATCH
        }

    return jsonify(res)


@app.route('/signup', methods=["GET", "POST"])
def register():
    username = request.args.get("username")
    password = request.args.get("password")
    mail = request.args.get("mail")
    auth = request.args.get("Authorization")

    if auth != CODE:
        return jsonify(ACCESS_DENIED)
    if not username or not password or not mail:
        return jsonify(EXPECTED_ARGUMENT)
    
    if db.register(username, password, mail):
        res = OK
    else:
        res = {
            "ack": "failed",
            "message": "duplicate username",
            "code": DUPLICATE
        }

    return jsonify(res)

@app.route('/resetpassword', methods=["GET", "POST"])
def change_password():
    auth = request.args.get("Authorization")
    username = request.args.get("username")
    password = request.args.get("password")
    code = request.args.get("captcha")

    if auth != CODE:
        return jsonify(ACCESS_DENIED)
        
    if not username or not password or not code:
        return jsonify(EXPECTED_ARGUMENT)
    
    if int(code) != captcha[username]:
        return jsonify({"ack": "failed", "message": "Invalid Captcha", "code": FAILED})
    
    db.change_password(username, password)
    return jsonify(OK)

@app.route('/captcha', methods=["GET", "POST"])
def request_captcha():
    username = request.args.get("username")
    auth = request.args.get("Authorization")

    if auth != CODE:
        return jsonify(ACCESS_DENIED)
    if not username:
        return jsonify(EXPECTED_ARGUMENT)
    
    code = 0
    for i in range(6):
        if i == 0:
            code = random.randint(1, 9)
        else:
            code = code * 10 + random.randint(0, 9)

    captcha[username] = code
    recipient = db.query_user(username)[3]
    mail = Mail()
    return jsonify(OK) if mail.send(recipient, str(code)) else jsonify(INTERAL_ERROR)
    


if __name__ == '__main__':
    app.run(port=5210)
