# -*- coding: utf-8 -*-
# @Time : 2021/2/1 0001
# @Author : yang
# @Email : 2635681517@qq.com
# @File : example7.py
import mysql.connector.pooling
config = {
    "host":"localhost",
    "port":3306,
    "user":"root",
    "password":"root",
    "database":"demo"

}
try:
    pool = mysql.connector.pooling.MySQLConnectionPool(**config,pool_size=20)
    con = pool.get_connection()
    con.start_transaction()
    cur = con.cursor()
    # 创建和原来一样的表
    sql = "create table t_emp_new as(select * from t_emp)"
    cur.execute(sql)
    con.commit()
except Exception as e:
    if "con" in dir():
        con.rollback()
    print(e)
    print("插入数据失败")

