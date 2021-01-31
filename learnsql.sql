CREATE TABLE temp(
id int UNSIGNED PRIMARY key,
num DECIMAL(20,10));
drop database tb_teacher;
CREATE TABLE tb_teacher(
    id int unsigned primary key auto_increment,
    name varchar(20),
    tel char(11) not null unique ,
    married boolean not null default false
);
create table tb_dept(
    deptno int unsigned primary key ,
    dname varchar(20) not null unique ,
    tel char(4) unique
);
insert into tb_dept values (201703208,"usdb","138");
DROP DATABASE tb_emp;
drop database tb_dept;


create table  tb_emp(
    empno int unsigned primary key ,
    ename varchar(20)not null ,
    sex enum("男","女") not null default "男",
    deptno int unsigned not null ,
    hiredate date not null ,
    foreign key tb_emp(deptno) references tb_dept(deptno)

)engine=InnoDB default charset=utf8;

insert into tb_emp values (1,"杨华钟","男",201703208,"1998-12-09");

create table tb_message(
    id int unsigned primary key,
    content varchar(200) not null,
    type enum('note') not null,
    create_time timestamp not null,
    index idx_type(type)
);
drop index idx_type on tb_message;
create index idx_type on tb_message(type);
show index from tb_message;
select * from tb_dept;
select  * from tb_emp;
select  ename from tb_emp where ename ="杨华钟";

create database demo default charset=utf8;

select count(*)total from demo.t_emp;


#数据的查询
use demo;
select  empno,ename,job from t_emp;
# 执行顺序 from --> where-->group by-->select-->order by-->order by-->limit
#取别名   as "income"
select  empno,sal*12 as "income"
from t_emp;
# 数据分页limit  select-->from--->limit  起始量,偏移量
select empno,ename from t_emp limit 5,5;
# 数据分页简写
select empno,ename from t_emp limit 6;
# where 字句中的执行条件的顺序
# 逻辑运算符 and or not xor（异或）
select
    ename,deptno
 from t_emp
where not deptno in(10,20) xor sal>=2000;


select 3&7;
# 3 0011
#& 7 0111
#---------
#   0011
#     3

select  3|7;
select ~10;
select 3^7;
select 10<<1;
select  10>>1;


# 聚合函数(求员工的平均月收入)avg()
select  avg(sal+ifnull(comm,0)) as avg from t_emp;
select avg(sal) from t_emp;
# sum()函数
select sum(sal) from t_emp where deptno in (10,20);
select sum(sal) from t_emp where deptno>=10 and deptno<=20;
# max()函数
select max(comm) from t_emp;
# 查询10到20的部门中，月收入最高的员工
select max(sal+ifnull(comm,0)) as max
from t_emp where deptno in (10,20);
select min(sal+ifnull(comm,0)) as max
from t_emp where deptno in (10,20);
# 查询员工名字最长的是几个字符
select max(length(ename)) as enamelength from t_emp;
#
select min(empno) from t_emp;
select min(hiredate) from t_emp;

# count()函数
select count(*) from t_emp;
# comm不为空的数
select count(comm) from t_emp;

select count(*) from t_emp
where sal>=2000 and deptno in(10,20) and datediff(now(),hiredate)/365 >= 15;

# 查询1985年以后入职的员工，底薪超过公司平均底薪的员工数量
#聚合函数不能出现在where后
# select count(*) from t_emp
# where hiredate>="1985-01-01"
#   group by empno
#分组查询每个部门的平均工资，有每个等等一般都用分组group by用到分组时select语句必须有相应的字段
select deptno,round(avg(sal)) from t_emp
group by deptno;

#查询每个（分组）部门里，每个职位的人员和平均底薪并且进行排序（用部门编号进行排序）
select deptno,job,avg(sal),count(*) from t_emp
group by deptno, job order by deptno;

select deptno,count(*),avg(sal) from t_emp
group by deptno;

#with rollup 对每个部门再次汇总
select deptno,count(*),round(avg(sal)),max(sal),min(sal)
from t_emp group by deptno with rollup;
# group_concat将 group by 产生的同一个分组中的值连接起来，返回一个字符串结果
#查询每个部门(分组)内底薪超过2000元的人数和员工
select deptno, group_concat(ename),count(*)
from t_emp where sal>=2000
group by deptno;

select deptno,group_concat(ename),count(*),max(length(ename))
from t_emp group by deptno;
#where 后不能出现聚合函数  having是跟在group by后面的功能和where差不多)
#聚合函数作为判断条件就必须用having()函数
#查询平均工资超过2000元的工资的员工编号
select deptno from t_emp
group by deptno having avg(sal)>=2000;

SELECT
	deptno
FROM
	t_emp
WHERE
	hiredate >= '1982-01-01'
GROUP BY
	deptno
HAVING
	count(*)>= 2 and avg(sal)>=2000;


select
       deptno,count(*)
from
       t_emp
where
      deptno in(10,20)
group by
      1;

#查询每个员工的部门信息
select e.empno,e.ename,d.dname
from t_emp e, t_dept d where e.deptno=d.deptno;

select e.empno,e.ename,d.dname
from t_emp e join t_dept d on e.deptno=d.deptno;

select e.empno,e.ename,d.dname,s.losal,e.job,s.grade
from t_emp e,t_dept d,t_salgrade s
where e.deptno =d.deptno and e.sal>=s.losal and e.sal<=s.hisal;

select e.empno,e.ename,d.dname,s.losal,e.job,s.grade
from t_emp e join t_dept d on e.deptno = d.deptno
join t_salgrade s on e.sal between s.losal and s.hisal;

SELECT ename from t_emp
where deptno= (select deptno from t_emp where ename="SCOTT")
and ename!="SCOTT";
#查询与SCOTT相同部门的员工都有谁
select t2.ename from t_emp t1,t_emp t2
where t1.deptno=t2.deptno and t1.ename="SCOTT"and t2.ename!="SCOTT";

# 查询底薪超过公司平均底薪的员工
select t2.ename,t2.sal
from t_emp t1,t_dept t2
where t1.deptno =t2.deptno
having t2.sal>=avg(t1.sal);

select e.ename,e.sal
from t_emp e, (select avg(sal) avg from t_emp) t
where e.sal>t.avg;

select count(*)as 人数,max(e.sal),min(e.sal),avg(e.sal),
      floor(avg(datediff(now(),e.hiredate)/365))
from t_emp e,t_dept d
where e.deptno=d.deptno and d.dname="RESEARCH";

select * from t_dept where dname = "RESEARCH";
select * from t_dept where dname like "R%";


select floor(45.6);
select ceil(1.1);

select e.job,max(e.sal+ifnull(e.comm,0)),min(e.sal+ifnull(e.comm,0)),avg(e.sal+ifnull(e.comm,0)),max(s.grade),min(s.grade)
       from t_emp e,t_salgrade s where e.sal+ifnull(e.comm,0) between s.losal and s.hisal
group by e.job;

SELECT
	e.job,
	max(
	e.sal + ifnull( e.comm, 0 )),
	min(
	e.sal + ifnull( e.comm, 0 )),
	avg(
	e.sal + ifnull( e.comm, 0 )),
	max( s.grade ),
	min( s.grade )
FROM
	t_emp e,
	t_salgrade s
WHERE
	e.sal + ifnull( e.comm, 0 ) BETWEEN s.losal
	AND s.hisal
GROUP BY
	e.job;

select e.empno,e.ename,e.sal
from t_emp e,(select  deptno,avg(sal) as avg from t_emp group by deptno) t
 where e.deptno=t.deptno and e.sal>=t.avg;

SELECT
	e.empno,
	e.ename,
	e.sal
FROM
	t_emp e,(
	SELECT
		deptno,
		avg( sal ) AS avg
	FROM
		t_emp
	GROUP BY
		deptno
	) t
WHERE
	e.deptno = t.deptno
	AND e.sal >= t.avg;

select  e.empno,e.ename,td.dname
from t_emp e
    left join t_dept td on e.deptno = td.deptno;


select  e.empno,e.ename,td.dname
from t_dept td
    right join  t_emp e on  e.deptno = td.deptno;

(select  d.dname,count(te.deptno) from t_dept d left join t_emp te on d.deptno = te.deptno
group by d.deptno)union(
select  d.dname,count(*) from t_dept d right join t_emp te on d.deptno = te.deptno
group by d.deptno);

insert into t_emp values (7920,"程浩","MARKET",7569,"1980-03-06",2530,100,NULL);
select * from t_emp;

# 子查询
# 查询底薪超过平均底薪的员工信息
select empno,ename,sal
from t_emp
where sal>=(select avg(sal) from t_emp);

#from子查询
select e.empno,e.ename,e.sal,t.avg
from t_emp e JOIN (SELECT deptno,avg(sal) as avg from t_emp group by  deptno) t
on e.deptno=t.deptno and e.sal>=t.avg;

SELECT
	e.empno,
	e.ename,
	e.sal,
	t.avg
FROM
	t_emp e
	JOIN ( SELECT deptno, avg( sal ) AS avg FROM t_emp GROUP BY deptno ) t ON e.deptno = t.deptno
	AND e.sal >= t.avg;

SELECT ename FROM t_emp WHERE deptno in
(select deptno from t_emp where ename in('FORD','MARTIN')) AND ename NOT IN ('FORD','MARTIN');


SELECT
	ename
FROM
	t_emp
WHERE
	deptno IN (
	SELECT
		deptno
	FROM
		t_emp
	WHERE
	ename IN ( 'FORD', 'MARTIN' ))
	AND ename NOT IN ( 'FORD', 'MARTIN' );

select ename from t_emp where sal>=
                              any (SELECT sal from t_emp where ename in('FORD', 'MARTIN'))
                          AND ename NOT IN ( 'FORD', 'MARTIN' );



select empno, ename, job, mgr, hiredate, sal, comm, deptno from t_emp
where exists(select  grade from t_salgrade where sal between losal and hisal and grade in(3,4));

#insert()函数
insert into t_dept(deptno, dname,loc) values (60,"后勤部","北京"),(70,"保安部","北京");

insert into t_emp(empno, ename, job, mgr, hiredate, sal, comm, deptno)
VALUES (8001,"流浪","长江大学",20,"1988-12-03",2000,50,(select deptno from t_dept where dname="技术部"));
#mysql特殊方言  insert into表名 set 字段=具体值,.....
insert  t_dept set deptno=80,dname="教学部",loc="湖北";
delete  from t_dept where deptno=80;

# ignore关键字
#insert[ignore ] into 表名......;
insert ignore into t_dept(deptno, dname, loc) VALUES (40,"技术部","南京"),(90,"技术部","南京");

# #update语句
# update [ignore ]表名 set 字段1=值1，....
# [where 条件1.....order by..... limit.....]

update t_emp set  empno=empno+1,mgr=mgr+1
order by empno desc ;

update t_emp set sal=sal-100 order by sal+ifnull(comm,0) desc limit 3;

update t_emp e,t_salgrade s set losal=losal+200
where e.deptno=10 and datediff(now(),hiredate)/365 >= 20;

# # update表链接
# update 表1 join 表2 on 条件 set 字段1=值1......
#难点
update t_emp e join t_dept td
set e.deptno=td.deptno,e.job="ANALYST",TD.loc="北京"
where e.ename ="ALLEN" AND td.dname="RESEARCH";
update t_emp e
    join t_dept td
    on e.deptno = td.deptno
set e.job="ALLENS"
              WHERE E.ename="123" AND TD.dname="RESEACH";
update t_emp
    join (select avg(sal) as avg from t_emp) t
    on sal<t.avg set sal=sal+150;

update t_emp,(select avg(sal) as avg from t_emp) t
set sal = sal+150
where sal<t.avg;

update t_emp e left join t_dept td on e.deptno = td.deptno
set  e.deptno=20
where e.deptno is null or (td.dname="SALES" AND e.sal<2000);


update t_emp e,t_dept td
set  e.deptno=20
where e.deptno is null or (td.dname="SALES" AND e.sal<2000) and e.deptno = td.deptno;

#delete
# delete  [ignore ] FROM 表名 [where 条件1.....order by..... limit.....]

delete  from t_emp where deptno=10 and datediff(now(),hiredate)/365>=20;

#删除20部门中工资最高的员工记录
delete from t_emp
where deptno=20
order by sal+ifnull(comm,0) desc
limit 1;

# 删除sales部门和该部门的全部员工记录
delete e,d from t_emp e join t_dept d on e.deptno=d.deptno
where d.dname="SALES";

# 删除每个低于部门平均底薪员工记录
delete e from t_emp e join (select deptno,avg(sal) as sal from t_emp group by deptno) t
on e.deptno=t.deptno AND e.sal<t.sal;

delete e from t_emp e join (select empno from t_emp where ename="KING") t
on e.mgr=t.empno or e.empno=t.empno;
# mysql函数的应用
# 数字函数
select  abs(-100);
select pow(2,3);
select pi();
select sin(radians(30));
select rand(30);
#开平方
select sqrt(9);

#字符函数
#日期函数
SELECT CURDATE();
SELECT CURRENT_DATE();
SELECT CURRENT_TIME();
SELECT CURRENT_TIMESTAMP();
#日期的格式化j
SELECT DATE_FORMAT('2022-01-24','%W');

select count(*) from t_emp
where date_format(hiredate,'%Y')=1981
and date_format(hiredate,'%m')<=6;


select date_add(now(),interval 10 day);


select date_add(now(),interval -10 minute );


select date_add(date_add(now(),interval 6 month),interval 3 day);

#字符函数
select lower('YANG');

SELECT concat(sal,'$') from t_emp;


SELECT REPLACE('abc','a','x');
SELECT rpad(substr("李晓娜",1,1),length('李晓娜')/3,'*');

select trim("                 Hello World  ");

#条件函数
#ifnull(表达式,值)
# if(表达式,值1,值2)（类似三元运算符）
select e.ename,e.empno,d.dname,
       if(d.dname="SALES","礼品A","礼品B")
       from t_emp e,t_dept d
where e.deptno=d.deptno;

#case
#when表达式then值1,
#......
#else 值N
#end
SELECT
	e.empno,
	e.ename,
CASE

		WHEN d.dname = "SALES" THEN
		"P1"
		WHEN d.dname = "ACCOUNTINC" THEN
		"P2"
		WHEN d.dname = "RESEARCH" THEN
		"P3"
	END AS PLACE
FROM
	t_emp e,
	t_dept d
WHERE
	e.deptno = d.deptno;

#MYSQL的事务机制
#开启事务
#start transaction sql语句
start transaction ;
truncate table t_emp;
truncate table t_dept;
delete from t_emp;
delete from t_dept;
select * from t_dept;
select * from t_emp;
#提交事务
commit;
#回滚
rollback;
set session transaction isolation level repeatable read ;#(默认隔离级别)
start transaction ;
select ename,empno from
t_emp;

commit;
#到出数据文件
#cmd进入mysql-mysql -uroot -p
#mysqldump -uroot -p [no-data] 数据库名->路径
#导入sql文件
#use demo
#source 路径 backup.sql
select * from t_emp;
create database demo;
drop database demo;




#新闻管理系统数据库设计源码
CREATE TABLE t_type(
id int UNSIGNED PRIMARY key auto_increment,
type VARCHAR(20) not NULL UNIQUE
)default charset=utf8;
INSERT INTO t_type(type) VALUES("要闻"),("体育"),("科技"),("娱乐"),("历史"),("文化"),("时政");

CREATE TABLE t_role(
id int UNSIGNED PRIMARY key auto_increment,
role VARCHAR(20) not NULL UNIQUE
)default charset=utf8;
INSERT INTO t_role(role) VALUES("管理员"),("新闻编辑");
#AES_ENCRYPT(原始数据,密钥字符串)
#加密
SELECT HEX(AES_ENCRYPT("你好世界","ABC123456"));

# aes解密
# AES_DECRYPT("加密结果","密钥字符串")
SELECT AES_DECRYPT(UNHEX("E85A104B6142A7375E53C0545CAD48EE"),"ABC123456");
CREATE TABLE t_user(
id int UNSIGNED PRIMARY key auto_increment,
username VARCHAR(20) not null UNIQUE,
password VARCHAR(500) not null,
email VARCHAR(100) not null,
role_id int UNSIGNED not null,
index (username)
);

INSERT INTO t_user(username,password,email,role_id) VALUES("yang",HEX(AES_ENCRYPT("123456","HelloWorld")),"2635681517@qq.com",2);

CREATE TABLE t_news(
id int UNSIGNED PRIMARY key auto_increment,
title VARCHAR(40) not NULL,
editer_id int UNSIGNED not null,
type_id int UNSIGNED not null,
content_id char(12) not NULL,
is_top TINYINT UNSIGNED not NULL,
create_time TIMESTAMP not NULL DEFAULT CURRENT_TIMESTAMP,
update_time TIMESTAMP not null  DEFAULT CURRENT_TIMESTAMP,
state enum("草稿","待审批","已审批","隐藏") not null,
INDEX(editer_id),
INDEX(type_id),
INDEX(state),
INDEX(create_time),
INDEX(is_top)
)




