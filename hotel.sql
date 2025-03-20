create database hotel_management;
use hotel_management;
create table Customers(
	customer_id	int auto_increment primary key,
    full_name varchar(45) not null,
    email	varchar(45) unique not null,
    phone_number varchar(45),	
    address varchar(45)
);
create table Rooms(
    room_id int auto_increment primary key,
    room_number int unique not null,
    room_type varchar(45) not null,
    price_per_night decimal(10,2) not null,
    statuss ENUM('available', 'booked', 'maintenance') not null default 'available'
);
create table Bookings(
    booking_id int auto_increment primary key,
    customer_id int not null,
    room_id int not null,
    check_in_date date,
    check_out_date date,
    total_price decimal(10,2),
    foreign key (customer_id) references Customers(customer_id) on delete cascade,
    foreign key (room_id) references Rooms(room_id) on delete cascade
);
create table Payments(
    payment_id int auto_increment primary key,
    booking_id int not null,
    amount_paid	decimal(10,2),
    payment_date date,
    payment_method varchar(45),
    foreign key (booking_id) references Bookings(booking_id)on delete cascade
);
-- Chèn dữ liệu 
INSERT INTO Customers (full_name, email, phone_number, address) VALUES
('Nguyễn Văn Đông', 'Đông@gmail.com', '0123456789', 'Hà Nội'),
('Trần Thị Hồng', 'Hồng@gmail.com', '0987654321', 'TP HCM'),
('Lê Văn Thơm', 'Thơm@gmail.com', '0345678912', 'Đà Nẵng'),
('Phạm Thị Hải', 'Hải@gmail.com', '0765432109', 'Hải Phòng'),
('Bùi Minh Hà', 'Hà@gmail.com', '0891234567', 'Cần Thơ'),
('Hoàng Anh Lam', 'Lam@gmail.com', '0965124789', 'Quảng Trị'),
('Đặng Hồng Gai', 'Gai@gmail.com', '0945768123', 'Huế'),
('Võ Thanh Hưng', 'Hưng@gmail.com', '0978456123', 'Bình Dương'),
('Ngô Nhật Thanh', 'Thanh@gmail.com', '0901678234', 'Nha Trang'),
('Tạ Quốc Gia', 'Gia@gmail.com', '0934789123', 'Vĩnh Phúc');

INSERT INTO Rooms (room_number, room_type, price_per_night, statuss) VALUES
(101, 'Single', 500000, 'available'),
(102, 'Double', 700000, 'booked'),
(103, 'Suite', 1500000, 'available'),
(104, 'Deluxe', 1200000, 'maintenance'),
(105, 'Single', 500000, 'available'),
(106, 'Double', 700000, 'available'),
(107, 'Suite', 1500000, 'booked'),
(108, 'Deluxe', 1200000, 'available'),
(109, 'Single', 500000, 'booked'),
(110, 'Double', 700000, 'available');

INSERT INTO Bookings (customer_id, room_id, check_in_date, check_out_date, total_price) VALUES
(1, 4, '2025-03-10', '2025-03-12', 1400000),
(2, 5, '2025-03-08', '2025-03-10', 3000000),
(3, 2, '2024-03-15', '2024-03-18', 1500000),
(4, 1, '2024-03-20', '2024-03-22', 1000000),
(5, 3, '2025-03-05', '2025-03-07', 3000000),
(6, 6, '2024-03-18', '2024-03-20', 1000000),
(7, 9, '2025-03-22', '2025-03-25', 2100000),
(8, 8, '2025-03-10', '2025-03-13', 3600000),
(9, 10, '2025-03-12', '2025-03-14', 1400000),
(10, 1, '2025-03-14', '2025-03-16', 3000000);

INSERT INTO Payments (booking_id, amount_paid, payment_date, payment_method) VALUES
(1, 1400000, '2025-03-10', 'Credit Card'),
(2, 3000000, '2025-03-08', 'Bank Transfer'),
(3, 1500000, '2025-03-15', 'Cash'),
(4, 1000000, '2025-03-20', 'Credit Card'),
(5, 3000000, '2025-03-05', 'Bank Transfer'),
(6, 1000000, '2025-03-18', 'Cash'),
(7, 2100000, '2025-03-22', 'Credit Card'),
(8, 3600000, '2025-03-10', 'Bank Transfer'),
(9, 1400000, '2025-03-12', 'Cash'),
(10, 3000000, '2025-03-14', 'Credit Card');

-- lấy danh sách tất cả khách hàng 
select * from Customers;
-- tìm các phòng có giá trên 500.000 VND mỗi đêm
select * from Rooms
where  price_per_night > 500000;
-- Tìm tất cả các booking có ngày check-in trong tháng 03/2024.
select * from Bookings
where month(check_in_date) =3 and year(check_in_date)=2024;
-- Hiển thị danh sách tất cả các đặt phòng, bao gồm tên khách hàng, số phòng, loại phòng và tổng giá.
select Customers.full_name,
       Rooms.room_number,
       Rooms.room_type,
       Bookings.total_price 
from bookings 
join Customers on Customers.customer_id =Bookings.customer_id
join Rooms on Rooms.room_id=Bookings.room_id;
-- Tìm tất cả các phòng đang được đặt cùng thông tin khách hàng đặt phòng đó.
select Customers.*,
	   Rooms.room_number,
       Rooms.room_type
from bookings
join Rooms on Rooms.room_id=Bookings.room_id
join Customers on Rooms.room_id=Bookings.room_id
where Rooms.statuss = 'booked';
-- Tính tổng số tiền đã thanh toán theo từng phương thức thanh toán.
select payment_method, sum(amount_paid) as total_amount
from Payments
group by payment_method;
-- Tìm khách hàng đã đặt nhiều phòng nhất.
select Customers.full_name, count(Bookings.booking_id) as max
from Bookings
join Customers on Customers.customer_id =Bookings.customer_id
group by Customers.full_name
order by max desc;
-- Tìm phòng có giá cao hơn mức trung bình của tất cả các phòng.
select * from Rooms
where price_per_night>(
select avg(price_per_night) from Rooms
);
-- Tìm khách hàng chưa từng đặt phòng.
select * from Customers 
where not exists(
select customer_id from Bookings
where Bookings.customer_id = Customers.customer_id
);
-- Viết câu lệnh cập nhật trạng thái của các phòng thành available nếu ngày check_out_date đã qua.
Update Rooms
set statuss ='available'
where room_id in(
 select Bookings.room_id from Bookings
 where Bookings.check_out_date < curdate()
);
-- Xóa tất cả các booking đã hoàn thành (check-out trước ngày hiện tại và đã thanh toán đủ).
delete from Bookings
where booking_id in (
select booking_id from (
       select BooKings.booking_id from Bookings
       join Payments on Payments.booking_id = Bookings.booking_id
       where Bookings.check_out_date < curdate() and Payments.amount_paid >=Bookings.total_price 
) as temp
);
-- Thiết kế thêm bảng Staff để quản lý nhân viên khách sạn.
create table staff (
	  staff_id int auto_increment primary key,
      Full_name varchar(45) not null,
      phone_number varchar(45) not null,
      position varchar(45) not null
);
-- Thêm bảng Reviews để khách hàng có thể đánh giá khách sạn.
create table review (
	   review_id int auto_increment primary key,
       customer_id int not null,
	   rating enum('1', '2', '3', '4', '5') not null,
       commentt varchar(225) not null,
       review_date date not null,
	   foreign key (customer_id) references Customers(customer_id) on delete cascade
);
-- Viết query tìm khách hàng đã đặt phòng nhiều nhất trong năm 2025.
select Customers.full_name, count(Bookings.booking_id) as max_booking
from Bookings
join Customers on Customers.customer_id =Bookings.customer_id
where year(Bookings.check_in_date) =2025
group by Customers.full_name
order by max_booking desc

