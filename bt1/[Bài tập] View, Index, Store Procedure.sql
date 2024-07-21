create database ss03_bt2;
use ss03_bt2;

create table customer(
id int primary key auto_increment,
name varchar(255),
age int);

create table orders(
id int primary key auto_increment,
customer_id int,
foreign key (customer_id) REFERENCES customer(id),
date datetime,
totalprice double);

create table product(
id int primary key auto_increment,
name varchar(255),
price double
);

create table orderdetail(
id int primary key auto_increment,
order_id int,
foreign key (order_id) references orders(id),
product_id int,
foreign key (product_id) references product(id),
quantity int);

select * from customer;
insert into customer(name,age) values('Minh quan',10),
('Hong oanh',20),
('Hong ha',50);

select * from orders;
insert into orders(customer_id,date,totalprice) values(1,'2006-3-21',15000),
(2,'2006-3-23',20000),
(1,'2006-3-16',17000);

select * from product;
insert into product (name,price) values('may giat', 300),
('tu lanh', 500),
('dieu hoa', 700),
('quat', 100),
('bep dien', 200),
('may hut bui', 500);

insert into orderdetail (order_id,product_id,quantity) values (1,1,3),(1,3,7),(1,4,2),(2,1,1),(3,1,8),(2,5,4),(2,3,3);
select * from orderdetail;


select c.*,p.*,od.quantity from customer c 
join orders o on o.customer_id = c.id
join orderdetail od on od.order_id = o.id
join product p on p.id = od.product_id;

select c.name,  p.name  from customer c 
join orders o on o.customer_id = c.id
join orderdetail od on od.order_id = o.id
join product p on p.id = od.product_id;

select * from customer c left join orders o on o.customer_id = c.id where o.customer_id is null;

-- select o.o_id,o.o_date,sum(od.odquantty * p.p_price) from orders o
-- join order_detail od on o.o_id =od.oid
-- join product p on o.p_id = od_pid
-- group by o.o_id;

select c. *  from customer c where c.id not in (select o.customer_id from orders o ); 

 select * from orders;
--  Hiển thị tất cả customer có đơn hàng trên 150000
select c.*,o.totalprice from customer c 
join orders o on o.customer_id = c.id
where o.totalprice >= 15000;

-- Hiển thị sản phẩm chưa được bán cho bất cứ ai
select * from product p where p.id not in(select od.product_id from orderdetail od );

-- Hiển thị tất cả đơn hàng mua trên 2 sản phẩm

SELECT * FROM orders o WHERE o.id IN (
    SELECT od.order_id FROM orderdetail od
    GROUP BY od.order_id
    HAVING COUNT(od.order_id) > 2);

-- Hiển thị đơn hàng có tổng giá tiền lớn nhất

select * from orders o where o.totalprice =  (select max(totalprice) from orders) limit 1;

-- Hiển thị sản phẩm có giá tiền lớn nhất
select * from product p where p.price = (select max(p.price) from product p);

-- Hiển thị người dùng nào mua nhiều sản phẩm “Bep Dien” nhất
SELECT c.name , SUM(od.quantity) AS total_bep_dien_purchased
FROM customer c
JOIN orders o ON c.id = o.customer_id
JOIN orderdetail od ON o.id = od.order_id
JOIN product p ON od.product_id = p.id
WHERE p.name = 'bep dien'
GROUP BY c.id, c.name
LIMIT 1;

-- Tạo view hiển thị tất cả customer
create view customer_view as
select * from customer;
select * from customer_view;

-- Tạo view hiển thị tất cả order có oTotalPrice trên 150000
create view oprice_view as
select * from orders where totalprice > 15000;
select * from oprice_view;
drop view oprice_view;

-- Đánh index cho bảng customer ở cột cName
create index idx_cname on customer(name);

-- Đánh index cho bảng product ở cột pName
create index idx_pname on product(name);
-- Tạo store procedure hiển thị ra đơn hàng có tổng tiền bé nhất
delimiter // 
create procedure min_totalprice()
begin
select * from orders where totalprice =(select min(totalprice) from orders)  limit 1;
end //
call min_totalprice();
drop procedure min_totalprice;	

-- Tạo store procedure hiển thị người dùng nào mua sản phẩm “May Giat” ít nhất
delimiter //
create procedure min_maygiat()
begin
select c.*, sum(od.quantity) as so_luong from customer c 
join orders o on c.id = o.customer_id
join orderdetail od on o.id = od.order_id
join product p on p.id = od.product_id
where p.name = 'may giat'
group by c.id,c.name
order by so_luong desc limit 1;
end //
call min_maygiat();

drop procedure min_maygiat;

