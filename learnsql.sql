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
#分组
select deptno,round(avg(sal)) from t_emp
group by deptno;

#查询每个部门里，每个职位的人员和平均底薪
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


