create database class_student;
use class_student;

create table class(
id int primary key auto_increment,
name varchar(255),
startdate varchar(255),
status bit);

create table student(
id int primary key auto_increment,
name varchar(100),
address varchar(255),
phone varchar (11),
class_id int,
foreign key (class_id) references class(id),
status bit);

create table subjects(
id int primary key auto_increment,
name varchar(255),
credit int,
status bit);

create table mark(
id int primary key auto_increment,
student_id int,
foreign key (student_id) references student(id),
subject_id int,
foreign key (subject_id) references subjects(id),
mark double,
examtime datetime);

select id,name,startdate, case when status = 0 then 'true' else 'false' end as status from class;
insert into class (name,startdate,status) values('HN-JV231103','03-11-2023',0),
('HN-JV231229','29-12-2023',0),
('HN-JV230615','15-06-2023',0);

select id,name,address,phone,class_id, case when status = 0 then 'true' else 'false' end as status from student;
insert into student values(1,'hồ da hùng','hà nội','0987654321',1,0),
(2,'phan văn giang','đà nẵng','0967811255',1,0),
(3,'dương mỹ huyền','hà nội','0385546611',2,0);

insert into student values(4,'hoàng minh hiếu','nghệ an','0987654333',2,0),
(5,'nguyễn vịnh','hà nội','0967811656',3,0),
(6,'nam cao','hà tĩnh','0985547911',1,0),
(7,'nguyễn du','nghệ an','0385546597',3,0);

select *,case when status = 0 then 'true' else 'false' end as trang_thai from subjects;
insert into subjects values(1,'toán',3,0),(2,'văn',3,0),(3,'anh',2,0);

select * from mark;
insert into mark values(1,1,1,7,'2024-5-12'),(2,1,1,7,'2024-3-15');
insert into mark values(3,2,2,8,'2024-5-15'),(4,2,3,9,'2024-03-08'),(5,3,3,10,'2024-02-11');

select * from class order by class.name desc;

select * from student where address = 'hà nội' ;

select s.*,c.name from class c
join student s on s.class_id = c.id
where c.name = 'HN-JV231103';

select * from subjects where credit >2;

select * from student where phone like '09%';

-- Tạo store procedure lấy ra tất cả lớp học có số lượng học sinh lớn hơn 5
delimiter //
create procedure soluong_5()
begin
select c.*, count(s.class_id) as count from student s 
join class c on c.id = s.class_id
group by s.class_id
having count >= 2;
end //
delimiter ;

call soluong_5;

-- Tạo store procedure hiển thị ra danh sách môn học có điểm thi là 10
delimiter //
create procedure mark_10()
begin
select sub.* from mark m
join subjects sub on sub.id = m.subject_id
where m.mark = 10;
end //
delimiter ;
call mark_10;

-- Tạo store procedure hiển thị thông tin các lớp học có học sinh đạt điểm 10
delimiter //
create procedure class_student_10()
begin
select c.* from class c 
join student s on s.class_id = c.id
where s.id = (select m.student_id from mark m where m.mark = 10);
end //
delimiter ;
call class_student_10;

-- Tạo store procedure thêm mới student và trả ra id vừa mới thêm
delimiter //
create procedure add_new_student(name_in varchar(100), address_in varchar(255), phone_in varchar(11),class_id_in int, status_in bit, new_id int)
begin
	insert into student(name,address,phone,class_id,status) value(name_in, address_in, phone_in, class_id_in, status_in);
    select last_insert_id() into new_id;
end //
delimiter ;
call add_new_student('quang','ha noi','0981524681',1,0, @new_id);
select @new_id;

-- Tạo store procedure hiển thị subject chưa được ai thi
insert into subjects (name, credit,status) value ('hóa',4,0);
delimiter //
create procedure subject_not()
begin
select sub.* from subjects sub where id not in( select distinct m.subject_id from mark m);
end //
delimiter ;

call subject_not;
