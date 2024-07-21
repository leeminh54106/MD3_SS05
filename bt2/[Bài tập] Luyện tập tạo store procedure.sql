create database ERD;
use ERD;

create table accounts(
id int primary key auto_increment,
name varchar(100),
pass varchar(255),
address varchar(255),
status bit);

create table bill(
id int primary key auto_increment,
type bit,
acc_id int,
foreign key (acc_id) references accounts(id),
created datetime,
auth_date datetime);

create table product(
id int primary key auto_increment,
name varchar(255),
created date,
price double,
stock int,
status bit);

create table bill_detail(
id int primary key auto_increment,
bill_id int,
foreign key (bill_id) references bill(id),
product_id int,
foreign key (product_id) references product(id),
quantity int,
price double);

select *, case when status = 0 then 'true' else 'false' end as status from accounts;
insert into accounts values(1,'hùng','123456','hà nội',0),
(2,'cường','654321','hà nội',0),(3,'bách','135790','hưng yên',0);

select * from bill;
insert into bill values(1,0,1,'2022-02-11','2022-03-12'),(2,0,1,'2023-10-5','2023-10-10'),(3,1,2,'2024-05-15','2024-05-20'),(4,1,3,'2022-02-01','2022-02-10');

select *, case when status = 0 then 'true' else 'false' end as trang_thai from product;
insert into product values(1,'quần dài','2022-03-12',1200,5,0),(2,'áo dài','2023-03-15',1500,8,0),
(3,'mũ cối','1999-03-08',1600,10,0);

select * from bill_detail;
insert into bill_detail values(1,1,1,3,1200),(2,1,2,4,1500),(3,2,1,1,1200),(4,3,2,4,1500),(5,4,3,7,1600);

select * from accounts a order by name desc;
select * from bill where created between '2023-02-11' and '2023-05-15';

select bd.* from bill_detail bd where bd.bill_id = 1 ;

select * from product order by name desc;

select * from product where stock >= 10;

select * from product where status = 0;

-- Tạo store procedure hiển thị tất cả thông tin account mà đã tạo ra 5 đơn hàng trở lên
delimiter //
create procedure account_number()
begin
select a.*,count(b.acc_id)as count from accounts a 
join bill b on b.acc_id = a.id
group by a.id
having count >= 2;
end //
delimiter ;
call account_number();

-- Tạo store procedure hiển thị tất cả sản phẩm chưa được bán
insert into product value(4,'nón sơn','2024-5-15',30000,23,1);
delimiter //
create procedure showproductnotsale()
begin
select p.* from product p where p.id not in(select bd.product_id from bill_detail bd);
end //
delimiter ;
call showproductnotsale();
-- Tạo store procedure hiển thị top 2 sản phẩm được bán nhiều nhất
delimiter //
create procedure soluong()
begin
select p.*, sum(bd.quantity) as soluong from product p
join bill_detail bd on bd.product_id = p.id
group by p.id
order by soluong desc limit 2;
end //
delimiter ;
call soluong ;
-- Tạo store procedure thêm tài khoản
delimiter //
create procedure add_account(in_name varchar(100),in_pass varchar(255), in_address varchar (255), in_status bit)
begin
	insert into accounts (name,pass,address,status) value(in_name,in_pass,in_address,in_status);
    end //
delimiter ;
call add_account('pinh','123456789','vĩnh tuy',1);
select * from accounts;
-- drop procedure add_account;

-- Tạo store procedure truyền vào bill_id và sẽ hiển thị tất cả bill_detail của bill_id đó
delimiter //
create procedure show_detail(bill_num_in int)
begin
select * from bill_detail bd where bd.bill_id = bill_num_in;
end //
delimiter ;
call show_detail(1);

-- Tạo ra store procedure thêm mới bill và trả về bill_id vừa mới tạo
delimiter //
create procedure inputbill(type_in bit,acc_id_in int,created_in datetime,auth_date datetime,out new_bill_id int)
begin
	insert into bill(type,acc_id,created,auth_date) value (type_in,acc_id_in,created_in,auth_date);
    select last_insert_id() into new_bill_id;
    end //
    delimiter ;
    call inputbill(1, 1, '2024-07-19', '2024-07-20', @new_bill_id);
    select @new_bill_id as newbill;
    
-- Tạo store procedure hiển thị tất cả sản phẩm đã được bán trên 5 sản phẩm
delimiter //
create procedure soluongtren5()
begin
select p.*, sum(bd.quantity) as soluong from product p
join bill_detail bd on bd.product_id = p.id
group by p.id
having soluong > 5;
end //

call soluongtren5;





