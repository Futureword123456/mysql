# -*- coding: utf-8 -*-
# @Time : 2021/2/1 0001
# @Author : yang
# @Email : 2635681517@qq.com
# @File : example3.py


import pymysql

try:
    con = pymysql.connect(
        host='127.0.0.1',
        user='root',
        passwd='root',
        port=3306,
        db='demo',
        charset='utf8'
    )
    # con.start_transaction()
    cur = con.cursor()
    sql = "insert into t_emp(empno, ename, job, mgr, hiredate, sal, comm, deptno) " \
          "values(%s,%s,%s,%s,%s,%s,%s,%s)"
    cur.execute(sql, (9600, "赵娜", "SEALMAN", None, "1985-12-03", 3000, 500, 10))
    con.commit()
    print("插入数据成功")
except Exception as e:
    if "con" in dir():
        con.rollback()
    print(e)
    print("数据库链接失败")
finally:
    if "con" in dir():
        con.close()



