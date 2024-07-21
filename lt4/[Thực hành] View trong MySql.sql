use classicmodels;


-- Tạo View có tên customer_views truy vấn dữ liệu từ bảng customers 
--  lấy các dữ liệu: customerNumber, customerName, phone bằng câu lệnh SELECT:

CREATE VIEW customer_views AS

SELECT customerNumber, customerName, phone

FROM  customers;

select * from customer_views;


-- VD: Cập nhật view customer_views:

CREATE OR REPLACE VIEW customer_views AS

SELECT customerNumber, customerName, contactFirstName, contactLastName, phone

FROM customers

WHERE city = 'Nantes';

DROP VIEW customer_views;