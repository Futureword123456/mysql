# -*- coding: utf-8 -*-
# @Time : 2021/2/1 0001
# @Author : yang
# @Email : 2635681517@qq.com
# @File : example4.py

import mysql.connector.pooling

config = {
    "host": "localhost",
    "port": 3306,
    "user": "root",
    "password": "root",
    "database": "demo"
}
# 创建连接池
try:
    pool = mysql.connector.pooling.MySQLConnectionPool(
        **config,
        pool_size=10
    )
    con = pool.get_connection()
    con.start_transaction()
    cur = con.cursor()
    sql = "update t_emp set  sal = sal+%s where deptno=%s"
    cur.execute(sql, (200, 20))
    con.commit()
    print("刷新数据成功...")
except Exception as e:
    if "con" in dir():
        con.rollback()
    print(e)
finally:
    pass
