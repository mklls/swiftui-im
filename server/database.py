'''
@Author: your name
@Date: 2020-06-06 16:42:02
@LastEditTime: 2020-06-19 19:39:38
@LastEditors: Please set LastEditors
@Description: In User Settings Edit
@FilePath: /server/database.py
'''
import sqlite3 as sql

'''
sqlite3

create table user(
    id integer primary key autoincrement
    username text
    password text
    mail text);
'''

class Database:
    def __init__(self):
        self.conn = sql.connect("alias.db", check_same_thread=False)
        self.cursor = self.conn.cursor()

    def query_user(self, username):
        self.cursor.execute("select * from user where username=?", (username,))
        ret = self.cursor.fetchall()
        return ret[0]

    def register(self, username, password, mail):
        self.cursor.execute("select * from user where username = ?", (username,))
        ret = self.cursor.fetchall()

        if len(ret):
            print("\033[1;31mduplicate username\033[0m")
            return False

        self.cursor.execute(
            "insert into user (username, password, mail) values(?, ?, ?)",
            (username, password, mail))

        self.conn.commit()
        print("\033[1;32msuccess\033[0m")
        return True

    def login(self, username, password):
        self.cursor.execute(
            "select * from user where username= ? and password= ?", (username, password))
        # 获取查询结果, 返回值类型为数组
        ret = self.cursor.fetchall()
        # 没有查到相关数据
        if not len(ret):
            print("\033[1;31mInvalid username/password\033[0m")
            return False

        print("welcome, \033[1;32m" + username +"\033[0m")
        return True

    def change_password(self, username, password):
        self.cursor.execute(
            "update user set password = ? where username = ?", (password, username))
        self.conn.commit()