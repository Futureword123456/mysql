# -*- coding: utf-8 -*-
# @Time : 2021/1/31 0031
# @Author : yang
# @Email : 2635681517@qq.com
# @File : example1.py
import pymysql
# 数据库的链接
conn = pymysql.connect(host='127.0.0.1' # 连接名称，默认127.0.0.1
                       , user='root' # 用户名
                       , passwd='root'  # 密码
                       , port=3306  # 端口，默认为3306
                       , db='demo'  # 数据库名称
                       , charset='utf8'  # 字符编码
                       )
# 创建游标
cur = conn.cursor()
sql = "select ename,empno,hiredate from t_emp"
cur.execute(sql)
# 提取数据
data = cur.fetchall()
for i in data:
    print(i[0], i[1], i[2])
cur.close()
conn.close()




