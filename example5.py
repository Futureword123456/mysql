# -*- coding: utf-8 -*-
# @Time : 2021/2/1 0001
# @Author : yang
# @Email : 2635681517@qq.com
# @File : example5.py
import mysql.connector.pooling

config = {
    "host": "localhost",
    "port": 3306,
    "user": "root",
    "password": "root",
    "database": "demo"
}
try:
    pool = mysql.connector.pooling.MySQLConnectionPool(**config, pool_size=20)
    con = pool.get_connection()
    # con.start_transaction()
    cur = con.cursor()
    # sql = "delete e,d from t_emp e,t_dept d where e.deptno=d.deptno and d.deptno = 20"
    sql = "truncate table t_emp"
    cur.execute(sql)
    # con.commit()
    print("删除数据成功")
except Exception as e:
    # if "con" in dir():
    #     con.rollback()
    print(e)
