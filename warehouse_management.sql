create database warehouse;
use warehouse;
create table Products (
       product_id int auto_increment primary key,
       product_name varchar(45) not null,
       category varchar(100) not null,
       quantity_in_stock int not null default 0,
       price decimal(10,2) not null
);
-- Bảng Nhà cung cấp
create table Suppliers(
	   supplier_id int auto_increment primary key,
       supplier_name varchar(45) not null,
       contact_person varchar(255) not null,
       phone_number varchar(20) not null,
       address varchar(255) null
);
-- Bảng Đơn nhập kho
create table Stock_in(
       stock_in_id int auto_increment primary key,
	   supplier_id int not null,
	   product_id int not null,
       quantity int not null,
       import_date date not null,
       total_cost decimal(10,2)
);
-- Bảng Đơn xuất kho 
create table stock_out(
	   stock_out_id int auto_increment primary key,
        product_id int not null,
        quantity int not null,
        export_date date not null,
        total_revenue decimal(10,2) not null
);
alter table Stock_in
add foreign key (supplier_id) references Suppliers(supplier_id),
add foreign key (product_id) references Products(product_id);

alter table stock_out
add foreign key (product_id) references Products(product_id);

INSERT INTO Products (product_name, category, quantity_in_stock, price)  
VALUES  
('Laptop Dell XPS 13', 'Điện tử', 15, 25000000.00),  
('iPhone 15 Pro', 'Điện tử', 10, 30000000.00),  
('Bàn phím cơ Logitech', 'Phụ kiện', 25, 1500000.00),  
('Chuột không dây Razer', 'Phụ kiện', 20, 1200000.00),  
('Tivi Samsung 55 Inch', 'Điện tử', 8, 18000000.00),  
('Ổ cứng SSD 1TB', 'Lưu trữ', 30, 2500000.00),  
('Tai nghe Sony WH-1000XM5', 'Âm thanh', 12, 7000000.00),  
('Loa Bluetooth JBL', 'Âm thanh', 18, 2000000.00),  
('Máy ảnh Canon EOS R6', 'Máy ảnh', 5, 42000000.00),  
('Máy in HP LaserJet', 'Văn phòng', 7, 5000000.00);  

INSERT INTO Suppliers (supplier_name, contact_person, phone_number, address)  
VALUES  
('Công ty Dell Việt Nam', 'Nguyễn Văn A', '0901234567', 'Hà Nội'),  
('Apple Việt Nam', 'Trần Thị B', '0912345678', 'TP.HCM'),  
('Logitech Distributor', 'Lê Văn C', '0923456789', 'Đà Nẵng'),  
('Razer Store', 'Hoàng Duy', '0934567890', 'Hải Phòng'),  
('Samsung Việt Nam', 'Phạm Minh E', '0945678901', 'Bình Dương'),  
('Western Digital', 'Ngô Đức F', '0956789012', 'Cần Thơ'),  
('Sony Electronics', 'Bùi Quang G', '0967890123', 'Huế'),  
('JBL Audio', 'Đặng Ngọc H', '0978901234', 'Hải Dương'),  
('Canon Việt Nam', 'Vũ Thanh I', '0989012345', 'Nghệ An'),  
('HP Store', 'Phan Tấn K', '0990123456', 'Đồng Nai');  

INSERT INTO Stock_In (supplier_id, product_id, quantity, import_date, total_cost)  
VALUES  
(1, 1, 10, '2025-03-01', 2500000.00),  
(2, 2, 5, '2025-03-02', 1500000.00),  
(3, 3, 15, '2025-03-03', 2250000.00),  
(4, 4, 20, '2025-03-04', 2400000.00),  
(5, 5, 6, '2025-03-05', 1080000.00),  
(6, 6, 25, '2025-03-06', 62500000.00),  
(7, 7, 10, '2025-03-07', 70000000.00),  
(8, 8, 12, '2025-03-08', 24000000.00);

INSERT INTO Stock_Out (product_id, quantity, export_date, total_revenue)  
VALUES  
(1, 5, '2025-03-11', 12500000.00),  
(2, 3, '2025-03-12', 90000000.00),  
(3, 7, '2025-03-13', 10500000.00),  
(4, 10, '2025-03-14', 12000000.00),  
(5, 2, '2025-03-15', 36000000.00),  
(6, 8, '2025-03-16', 20000000.00),  
(7, 6, '2025-03-17', 42000000.00),  
(8, 5, '2025-03-18', 10000000.00);
-- lấy danh sách tất cả sản phẩm trong khi cùng với số lượng tồn kho và giá bán
select product_name, quantity_in_stock, price from Products;

--  tìm tất cả sản phẩm thuộc danh mục "Điện tử"
select * from Products
where category = "Điện tử";

-- Lấy thông tin của nhà cung cấp có tên là "Sony Electronics"
select * from Suppliers
where supplier_name = "Sony Electronics";

-- danh sách các sản phẩm có sản lượng tồn kho dưới 10
select * from Products
where quantity_in_stock < 10;

-- tìm các đơn nhập kho có tổng chi phí lớn hơn 1 triệu
select * from Stock_in WHERE total_cost > 1000000;

-- Hiện thị danh sách tất cả đơn nhập kho,bao gồm tên sản phẩm, số lượng nhập, tổng chi phí và tên nhà cung câp
select Products.product_name,
       Stock_in.quantity,
       Stock_in.total_cost,
       Suppliers.supplier_name 
from Stock_in
join Products on Products.product_id = Stock_in.product_id
join Suppliers on Suppliers.supplier_id = Stock_in.supplier_id;

-- tìm các sản phẩm chưa từng được nhập kho
select * from Products
where not exists (select product_id from Stock_in 
where Products.product_id = Stock_in.product_id
 );
 
 -- Liệt kê các đơn xuất kho theo tên sản phẩm và tổng số lượng đã xuất kho của từng sản phẩm.
select Products.product_name,sum(stock_out.quantity) as total_product  from stock_out
join Products on Products.product_id = Stock_out.product_id
group by Products.product_name;
 
-- tính tổng số lượng sản phẩm hiện có trong kho
select sum(quantity_in_stock) as all_product_in_stock from Products;
-- tính tổng doanh thu từ các đơn xuất kho
select sum(total_revenue ) as total from Stock_Out;

-- Tính số lượng sản phẩm trung bình của mỗi danh mục sản phẩm.
select category, avg(quantity_in_stock) as avg_quantity   from Products
group by category;

-- tìm nhà cung cấp đã cung cấp số lượng sản phẩm nhiều nhất'
select Suppliers.supplier_name, sum(Stock_in.quantity) as product from Stock_in
join Suppliers on Suppliers. supplier_id = Stock_in. supplier_id
group by Suppliers.supplier_name
order by product desc;

--  Tìm sản phẩm có doanh thu cao nhất từ đơn xuất kho.
select Products.product_name, sum(stock_out.total_revenue) as total  from stock_out
join Products on Products.product_id = Stock_out.product_id
group by Products.product_name
order by total desc;

-- Tìm danh mục sản phẩm có nhiều sản phẩm nhất.
select category, COUNT(*) as product_count  
from Products  
group by category  
order by  product_count desc;

--  danh sách các sản phẩm chưa từng được xuất kho
select product_name from products
left join Stock_out on Stock_Out.product_id =products.product_id
where Stock_out.product_id is null;

-- Tìm các nhà cung cấp không có đơn nhập kho nào trong tháng này.
select Suppliers.supplier_name from Suppliers
where not exists (
      select supplier_id from Stock_in
      where Stock_in.supplier_id =Suppliers.supplier_id
      and year(import_date) = year(curdate())
      and month(import_date) = month(curdate())
);

-- tìm đơn nhập kho có giá trị cao nhất trong năm 2025
select * from stock_in
where year(import_date) = 2025
order by total_cost desc;
-- Hiển thị 5 sản phẩm có số lượng nhập kho nhiều nhất từ trước đến nay.

select Products.product_name, sum(Stock_in.quantity) as product from Stock_in
join Products on Products. product_id  = Stock_in. product_id 
group by Products.product_name
order by product desc
limit 5;
