# -*- coding: utf-8 -*-
# @Time : 2021/2/1 0001
# @Author : yang
# @Email : 2635681517@qq.com
# @File : example7.py
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
    con.start_transaction()
    cur = con.cursor()
    # 创建和原来一样的表(有数据)
    # sql = "create table t_emp_new as(select * from t_emp)"
    # 创建和t_emp也一样的表结构（无数据）
    sql = "drop table t_emp_new"
    cur.execute(sql)
    sql = "create table t_emp_new like t_emp"
    cur.execute(sql)

    sql = "select avg(sal)  as avg from t_emp"
    cur.execute(sql)
    data = cur.fetchone()
    # 公司平均底薪
    avg = data[0]
    sql = "select deptno from t_emp group by deptno having avg(sal)>=%s"
    cur.execute(sql, [avg])
    data = cur.fetchall()
    sql = "insert into t_emp_new select * from t_emp where deptno in("
    for index in range(len(data)):
        one = data[index][0]
        if index < len(data) - 1:
            sql += str(one) + ","
        else:
            sql += str(one)
    sql += ")"
    cur.execute(sql)
    sql = "delete from t_emp where deptno in("
    for index in range(len(data)):
        one = data[index][0]
        if index < len(data) - 1:
            sql += str(one) + ","
        else:
            sql += str(one)

    sql += ")"
    cur.execute(sql)

    sql = "select deptno from t_dept where dname=%s"
    cur.execute(sql, ["SALES"])
    deptno = cur.fetchone()[0]
    sql = "update t_emp_new set deptno =%s"
    cur.execute(sql, [deptno])
    con.commit()
    print("成功")
except Exception as e:
    if "con" in dir():
        con.rollback()
    print(e)
    print("失败")
