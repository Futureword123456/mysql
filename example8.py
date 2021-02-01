# -*- coding: utf-8 -*-
# @Time : 2021/2/1 0001
# @Author : yang
# @Email : 2635681517@qq.com
# @File : example8.py

import mysql.connector.pooling

config = {
    "host": "localhost",
    "port": 3306,
    "user": "root",
    "password": "root",
    "database": "demo"

}
try:
    pool = mysql.connector.pooling.MySQLConnectionPool(**config, pool_size=10)
    con = pool.get_connection()
    con.start_transaction()
    sql = "INSERT INTO	t_dept (SELECT max(deptno)+10,%s,%s FROM t_dept)"
    cur = con.cursor()
    cur.execute(sql, ("A部门", "北京"))

    sql = "INSERT INTO	t_dept (SELECT max(deptno)+20,%s,%s FROM t_dept)"
    cur = con.cursor()
    cur.execute(sql, ("B部门", "上海"))

    con.commit()
    print("成功")
except Exception as e:
    if "con" in dir():
        con.rollback()
    print(e)
    print("失败")
