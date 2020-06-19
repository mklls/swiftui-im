#!/usr/bin/python3
'''
@Author: your name
@Date: 2020-06-08 19:27:48
@LastEditTime: 2020-06-19 19:45:31
@LastEditors: Please set LastEditors
@Description: In User Settings Edit
@FilePath: /server/chatserver.py
'''
from socketserver import ThreadingTCPServer, StreamRequestHandler
import sqlite3 as sql
import json
import threading
import hashlib
import base64
import time
import random
from database import Database
from mail import Mail


class MsgHandler(StreamRequestHandler):
    db = Database()

    def handle(self):
        print("new connection from ", self.client_address)
        while True:
            data = self.request.recv(8192)
            if not data:
                self.offline()
                print("client disconnect ", self.request.getpeername())
                break
            self._handle(data)

    # 处理消息
    def _handle(self, raw):
        payload = {}
        switch = {
            "online": self.online,
            "message": self.forward
        }

        # json 解析
        msg = json.loads(raw)
        try:
            # 判断请求类型
            switch[msg["type"]](msg)
        except BaseException as e:
            print('error msg: ', e)

    def forward(self, data):
        print(data)
        to_user = data.pop("to")
        if to_user != "all":
            dat = bytes(json.dumps(data) + "«", encoding="utf8")
            self.server.send(to_user, dat)
        else:
            data["type"] = "all"
            dat = bytes(json.dumps(data) + "«", encoding="utf8")
            self.server.boardcast(self.request, dat)

    def online(self, data):
        username = data["data"]
        (n_id, n_name, _, n_mail) = self.db.query_user(username)
        n_avatar = str(n_id)
        n_user = {"id": n_id, "username": n_name, "icon": n_avatar, "mail": n_mail}
        print(f"online :{n_user}")
        # 返回用户自己的信息
        dat = {"type": "me", "data": n_user}
        res = bytes(json.dumps(dat) + "«", encoding="utf8")
        self.request.sendall(res)
        time.sleep(1)
        self.server.append_client(self.request, n_name)
        print(self.server.clients)
        print("here")
        # 有用户在线，则将所有在线用户的信息返回给新上线的用户
        users = []
        for user in self.server.clients.keys():
            if user == n_name:
                continue
            if user != "all":
                (id, name, _, mail) = self.db.query_user(user)
                avatar = str(id)
            else:
                id = 0
                name = "all"
                avatar = "team"
                mail = ""

            users.append({
                "id": id,
                "username": name,
                "icon": avatar,
                "mail": mail
            })

        dat = {"type": "room", "data": users}

        res = bytes(json.dumps(dat) + "«", encoding="utf8")

        self.server.send(n_name, res)
        # 给所在线用户发送广播，有新用户上线
        dat = {"type": "new", "data": n_user}
        res = bytes(json.dumps(dat) + "«", encoding="utf8")
        self.server.boardcast(self.request, res)

    def offline(self):
        username = self.server.reclients.get(self.request, "null")
        if (username == "null"):
            return
        dat = {"type": "offline", "data": username}
        res = bytes(json.dumps(dat)+"«", encoding="utf8")
        self.server.boardcast(self.request, res)
            


# 处理多个客户端连接 消息转发
class Server(ThreadingTCPServer):

    def __init__(self, server_address, RequestHandlerClass):
        super().__init__(server_address, RequestHandlerClass)
        self.clients = {}
        self.clients["all"] = ""
        self.reclients = {}
        self.lock = threading.Lock()

    def append_client(self, client, user):
        with self.lock:
            self.clients[user] = client
        with self.lock:
            self.reclients[client] = user

    def remove_client(self, client):
        with self.lock:
            self.clients.pop(self.reclients[client])
        with self.lock:
            self.reclients.pop(client)

    def send(self, to, data):
        with self.lock:
            self.clients[to].sendall(data)

    def empty(self):
        if self.clients:
            return False
        else:
            return True

    def boardcast(self, sender, data):
        with self.lock:
            for c in self.clients.values():
                if c is not sender and c != "":
                    c.sendall(data)


if __name__ == "__main__":
    HOST = "127.0.0.1"
    PORT = 5219
    ThreadingTCPServer.allow_reuse_address = True
    s = Server((HOST, PORT), MsgHandler)
    s.serve_forever()
