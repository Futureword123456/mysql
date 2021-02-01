# -*- coding: utf-8 -*-
# @Time : 2021/2/1 0001
# @Author : yang
# @Email : 2635681517@qq.com
# @File : example6.py


import mysql.connector.pooling

try:
    config = {
        "host": "localhost",
        "port": 3306,
        "user": "root",
        "password": "root",
        "database": "demo"
    }
    pool = mysql.connector.pooling.MySQLConnectionPool(**config, pool_size=10)
    con = pool.get_connection()
    con.start_transaction()
    cur = con.cursor()
    sql = "insert into t_dept(deptno, dname, loc) values (%s,%s,%s)"
    data = [[100, "A部门", "北京"], [110, "B部门", "上海"]]
    cur.executemany(sql, data)
    con.commit()
    print("插入数据库成功")
except Exception as e:
    if "con" in dir():
        con.rollbakc()
    print(e)
    print("插入数据失败")
