# -*- coding: utf-8 -*-
# @Time : 2021/1/31 0031
# @Author : yang
# @Email : 2635681517@qq.com
# @File : example2.py


import pymysql

config = {
    "host": "localhost",
    "port": 3306,
    "user": "root",
    "password": "root",
    "database": "vega"
}
con = pymysql.connect(**config)
username = "1 or 1=1"
password = "1 or 1=1"
# sql可以防止sql注入,不向sql语句传入具体的数据，先编译在传值用函数参数形式就可以解决
sql = "select count(*) from t_user where username = %s " \
      " AND AES_DECRYPT(UNHEX(password),'helloworld')=%s"

sql1 = "select count(*) from t_user where username =" + username + \
       " AND AES_DECRYPT(UNHEX(password),'helloworld')=" + password
cur = con.cursor()
cur.execute(sql, (username, password))
# cur.execute(sql1)
print(cur.fetchone()[0])
con.close()
cur.close()


