create database library_management;
use library_management;

create table members (
       member_id int auto_increment primary key,
       full_name varchar(100) not null,
       email varchar(100) unique not null,
       phone_number varchar(20) not null,
       address varchar(255) null,
       join_date date default (current_date)
);

create table books (
       book_id int auto_increment primary key,
       title varchar(255) not null,
       author varchar(100) not null,
       genre varchar(50) not null,
       published_year year not null,
       status enum('available', 'borrowed', 'reserved') not null default 'available'
);

create table borrowings (
      borrow_id int auto_increment primary key,
      member_id int not null,
      book_id int not null,
      borrow_date date default (current_date),
      due_date date not null,
      return_date date null
);

create table payments (
       payment_id int auto_increment primary key,
       borrow_id int not null,
       amount_paid decimal(10,2) not null,
       payment_date date default (current_date),
       payment_method varchar(50) not null
);
alter table borrowings
add foreign key (member_id) references members(member_id) on delete cascade,
add foreign key (book_id) references books(book_id) on delete cascade;

alter table payments
add foreign key (borrow_id) references borrowings(borrow_id) on delete cascade;

insert into Members (full_name, email, phone_number, address, join_date) values
('Nguyễn Văn A', 'nguyenvana@gmail.com', '0987654321', 'Hà Nội', '2023-01-15'),
('Trần Thị B', 'tranthib@gmail.com', '0978123456', 'Hồ Chí Minh', '2023-05-10'),
('Lê Quốc C', 'lequocc@gmail.com', '0902345678', 'Đà Nẵng', '2022-11-20'),
('Hoàng Minh D', 'hoangminhd@gmail.com', '0912233445', 'Hải Phòng', '2024-02-01'),
('Phạm Thanh E', 'phamthanye@gmail.com', '0967123456', 'Cần Thơ', '2024-03-05');

insert into books (title, author, genre, published_year, status) values
('lập trình c++', 'bjarne stroustrup', 'programming', 1995, 'available'),
('doraemon', 'fujiko f. fujio', 'comics', 1980, 'borrowed'),
('harry potter và hòn đá phù thủy', 'j.k. rowling', 'fantasy', 1997, 'available'),
('sapiens: lược sử loài người', 'yuval noah harari', 'history', 2011, 'reserved'),
('thiên tài bên trái, kẻ điên bên phải', 'ngô thừa ân', 'psychology', 2015, 'available'),
('sherlock holmes: dấu vết bốn người', 'arthur conan doyle', 'detective', 1901, 'borrowed');

insert into borrowings (member_id, book_id, borrow_date, due_date, return_date) values
(1, 2, '2024-03-01', '2024-03-15', '2024-03-10'),
(2, 4, '2024-02-20', '2024-03-05', null),
(3, 6, '2024-03-05', '2024-03-20', '2024-03-18'),
(3, 3, '2024-03-10', '2024-03-25', null),
(5, 5, '2024-03-12', '2024-03-27', '2024-03-26'),
(1, 6, '2024-03-20', '2024-03-27', '2024-03-27'),
(3, 2, '2024-03-19', '2024-03-27', '2024-03-23'),
(2, 3, '2024-03-23', '2024-03-27', '2024-03-30');

insert into payments (borrow_id, amount_paid, payment_date, payment_method) values
(4, 50000, '2024-03-19', 'cash'),
(3, 75000, '2024-03-20', 'credit card'),
(1, 60000, '2024-03-16', 'mobile banking'),
(1, 50000, '2024-03-10', 'cash'),
(3, 75000, '2024-03-18', 'credit card'),
(5, 60000, '2024-03-26', 'mobile banking');

-- lấy danh sách tất cả thanh viên trong thư viện
select * from members;

-- tìm các danh sách thuộc thể loại 'comics'
select * from books
where genre = 'comics';

-- tìm tất cả các lần mượn sách có ngày mượn trong tháng 03/2024
select * from borrowings
where month(borrow_date) =03 and year(borrow_date)=2024;

-- Hiện thị danh sách tất cả các lần mượn sách bao gồm tên thành viên, tên sách, ngày mượn, ngày trả hạn cuối 
select members.full_name,
       books.title,
       borrowings.borrow_date,
       borrowings.due_date
from borrowings 
join members on members.member_id = borrowings.member_id
join books on books.book_id = borrowings.book_id;

-- tìm tất cả các sách đang được mượn cùng thông tin thành viên đang mượn 
select members.full_name,
       books.title
from borrowings
join members on members.member_id = borrowings.member_id
join books on books.book_id = borrowings.book_id
where borrowings.return_date is null;

-- tính tổng số tiền phạt đã tanh toán theo từng phương thức thanh toán
select payment_method, sum(amount_paid) as sum_paid from payments
group by payment_method;

-- Tìm thành viên đã mượn nhiều sách nhất.
select members.full_name, count(borrowings.member_id) as count_borrow
from borrowings
join members on members.member_id = borrowings.member_id
group by members.full_name
order by count_borrow desc
limit 1;
-- Tìm các thành viên đã mượn nhiều sách nhất.
select full_name, count_borrow
from (
select members.full_name, count(borrowings.member_id) as count_borrow from borrowings
join members on members.member_id = borrowings.member_id
group by members.full_name
) as subquery
where count_borrow = (select max(count_borrow) from (
        select COUNT(borrowings.member_id) AS count_borrow
        from borrowings
        group by borrowings.member_id
    ) as max_subquery);
    
-- Tìm sách được xuất bản trước năm trung bình của tất cả các sách trong thư viện.
select * from books
where published_year < (
select avg(published_year) from books
);

-- tìm thành viên chưa từng mượn sách
select * from members
where not exists (
select borrowings.member_id from borrowings
where members.member_id=borrowings.member_id
);
--  Cập nhật trạng thái sách thành "available" nếu đã được trả
update books
set status = "available"
where book_id in (
select book_id from borrowings 
where return_date is not null 
) and book_id > 0;
-- Xóa bản ghi mượn sách đã hoàn thành (trả sách trước ngày hiện tại)
delete from borrowings
where return_date is not null and return_date < current_date() and borrow_id>0
