use classicmodels;

SELECT * FROM customers; 

-- để tìm thông tin của khách hàng có tên là Land Of Toys Inc.
SELECT * FROM customers WHERE customerName = 'Land of Toys Inc.'; 

-- EXPLAIN Query;
EXPLAIN SELECT * FROM customers WHERE customerName = 'Land of Toys Inc.'; 

ALTER TABLE customers ADD INDEX idx_customerName(customerName);

EXPLAIN SELECT * FROM customers WHERE customerName = 'Land of Toys Inc.'; 

-- thêm chỉ mục cho bảng customers 
ALTER TABLE customers ADD INDEX idx_full_name(contactFirstName, contactLastName);

-- Sau đó chạy lại lệnh dưới và quan sát kết quả so sánh với lúc chưa tạo index
EXPLAIN SELECT * FROM customers WHERE contactFirstName = 'Jean' or contactFirstName = 'King';

-- Để xoá chỉ mục trong bảng,
ALTER TABLE customers DROP INDEX idx_full_name;

-- Mysql Stored Procedure đầu tiên

DELIMITER //

CREATE PROCEDURE findAllCustomers()

BEGIN

  SELECT * FROM customers;

END //

delimiter ;

-- Cách gọi procedure
call findAllCustomers();

-- Sửa procedure

DELIMITER //
DROP PROCEDURE IF EXISTS `findAllCustomers`//

CREATE PROCEDURE findAllCustomers()

BEGIN

SELECT * FROM customers where customerNumber = 175;

END //