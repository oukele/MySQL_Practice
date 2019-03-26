create table student(
	sno varchar(3) primary key ,
	sname varchar(8),
	ssex varchar(2),
	sbirthday datetime,
	class varchar(5)
)default charset=utf8;

insert into student values
('108','曾华','男','1977-09-01','95033'),
('105','匡明','男','1975-10-02','95031'),
('107','王丽','女','1976-01-23','95033'),
('101','李军','男','1976-02-20','95033'),
('109','王芳','女','1975-02-10','95031'),
('103','陆君','男','1974-06-03','95031');

create table course(
	cno varchar(5) primary key ,
	cname varchar(10),
	tno varchar(3)
)default charset=utf8;

insert into course values
('3-105','计算机导论','825'),
('3-245','操作系统','804'),
('6-166','数字电路','856'),
('9-888','高等数学','831');

create table score(
	sno varchar(3),
	cno varchar(5),
	degree decimal(4,1)
)default charset=utf8;

insert into score values
('103','3-245',86),
('105','3-245',75),
('109','3-245',68),
('103','3-105',92),
('105','3-105',88),
('109','3-105',76),
('101','3-105',64),
('107','3-105',91),
('108','3-105',78),
('101','6-166',85),
('107','6-166',79),
('108','6-166',81);

create table teacher(
	tno varchar(3) primary key ,
	tname varchar(8),
	tsex varchar(2),
	tbirthday datetime,
	prof varchar(6),
	depart varchar(10)
)default charset=utf8;

insert into teacher values
('804','李诚','男','1958-12-02','副教授','计算机系'),
('856','张旭','男','1969-03-12','讲师','电子工程系'),
('825','王萍','女','1972-05-05','助教','计算机系'),
('831','刘冰','女','1977-08-14','助教','电子工程系');

#1、 查询Student表中的所有记录的Sname、Ssex和Class列。

select sname,ssex,class from student;

#2、 查询教师所有的单位即不重复的Depart列。

select distinct depart from teacher;

#3、查询Student表的所有记录。

select * from student;

#4、查询Score表中成绩在60到80之间的所有记录。

select * from score where degree >60 and degree <=80;

#5、查询Score表中成绩为85，86或88的记录。

select * from score where degree =85 or degree =86 or degree =88;
select * from score where degree in (85,86,88);

#6、查询Student表中“95031”班或性别为“女”的同学记录。

select * from student where class ='95031' or ssex ='女';
select * from student where class in ('95031') or ssex in ('女');

#7、以Class降序查询Student表的所有记录。

select * from student order by class desc;

#8、以Cno升序、Degree降序查询Score表的所有记录。

select * from score order by cno asc, degree desc;

#9、查询“95031”班的学生人数。

select count(*) from student where class ='95031';

#10、 查询Score表中的最高分的学生学号和课程号。（子查询或者排序）
#查询语句查询出一个或者一列结果，可以作为其他查询语句的参数来使用，就是子查询，就是查询的嵌套。

#排序
select * from score order by degree desc limit 0,1; 
#子查询
select * from score where degree =(select max(degree) from score);


#11、查询每门课的平均成绩，要按照课程分组group by，然后求没门课平均avg

select  cno,avg(degree) as 平均成绩 from score group by cno ;

#12、查询Score表中至少有5名学生选修的并以3开头的课程的人数。
#Like模糊查询 3%以3开头 having只能跟在group by 后面

select cno from score where cno like '3%' group by cno having count(*) >= 5;


#13、查询分数大于70，小于90的Sno列。

select sno from score where degree >=70 and degree < 90 ;

#14、查询所有学生的Sname、Cno和Degree列。

select sname,cno,degree from student s 
	inner join score sc 
	on s.sno = sc.sno; 
	
#15、查询所有学生的Sno、Cname和Degree列。
select sno,(select cname from course where course.cno = score.cno),degree from score;

#16、查询所有学生的Sname、Cname和Degree列。
select 
	(select sname from student where student.sno = score.sno ) as 学生姓名,
	(select cname from course where course.cno = score.cno ) as 课程 ,
	degree as 成绩
from score;

#17、 查询“95033”班学生的平均分。

select class ,avg(score.degree) from score 
	inner join student 
	on score.sno = student.sno
	where student.class = '95033'; 

#18、假设使用如下命令建立了一个grade表：
create table grade(
	low int(3),upp int(3),rank char(1)
)default charset=utf8;
insert into grade values(90,100,'A');
insert into grade values(80,89,'B');
insert into grade values(70,79,'C');
insert into grade values(60,69,'D');
insert into grade values(0,59,'E');

#现查询所有同学的Sno、Cno和rank列。

select sno,cno,rank from 
	score join grade where 
	score.degree >= low && score.degree <=upp ;

#19、查询选修“3-105”课程的成绩高于“109”号同学成绩的所有同学的记录。

select * from score where degree 
in ( 
	select degree from score where cno='3-105' 
		and degree >(select degree from score where cno='109' and cno='3-105') 
);


#20、查询score中选学多门课程的同学中分数为非最高分成绩的记录。

select * from score where degree 
	not in ( select max(degree) from score group by sno )
	and sno in( select sno from score group by sno having count(sno) >1 );

#21、查询成绩高于学号为“109”、课程号为“3-105”的成m绩的所有记录。

select * from score where degree > ( select degree from score where sno='109' and cno ='3-105' );

#22、查询和学号为108的同学同年出生的所有学生的Sno、Sname和Sbirthday列。

select * from student where 
	year(sbirthday) = ( select year(sbirthday) from student where sno =108 );

#23、查询“张旭“教师任的学生成绩。

select * from score where cno 
	in ( select cno from course where tno = (select tno from teacher where tname ='张旭'  ) );


#24、查询选修某课程的同学人数多于5人的教师姓名。

select * from teacher 
	where tno in (
	select tno from score where cno in ( select cno from score group by cno having count(cno) >5 ) 
);


#25、查询95033班和95031班全体学生的记录。

select * from student where class ='95033' or class ='95031';


#26、 查询存在有85分以上成绩的课程Cno.

select * from course where cno in ( select cno from score where degree >85 );

#27、查询出“计算机系“教师所教课程的成绩表。

select * from score 
	where cno in (
	select cno from course where tno in( select tno from teacher where depart ='计算机系') 
);

#28、查询“计算机系”与“电子工程系“不同职称的教师的Tname和Prof。

select * from teacher 
	where prof not in(
	select prof from teacher where depart ='计算机系' and prof in(select prof from teacher where depart='电子工程系') 
);

#29、查询选修编号为“3-105“课程且成绩至少高于选修编号为“3-245”的同学

select * from score where cno ='3-105' and degree > any(select degree from score where cno ='3-245');


#30、查询选修编号为“3-105”且成绩高于选修编号为“3-245”课程的同学的Cno、Sno和Degree. ?

select * from score where cno ='3-105' and degree > all(select degree from score where cno ='3-245');

#31、 查询所有教师和同学的name、sex和birthday.

select tname,tsex,tbirthday from teacher 
union
select sname,ssex,sbirthday from student;

#32、查询所有“女”教师和“女”同学的name、sex和birthday.

select tname,tsex,tbirthday from teacher where tsex ='女'
union
select sname,ssex,sbirthday from student where ssex ='女';

#33、 查询成绩比该课程平均成绩低的同学的成绩表。

select * from score a where degree < ( select avg(degree) from score b where a.cno = b.cno );



