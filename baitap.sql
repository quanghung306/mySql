create database school_management;
use school_management;
create table students (
    id_student int auto_increment primary key,
    FullName varchar(45)  null,
	Birthday date  null,
    Gender varchar(45)  null,
    Address varchar(45) null,
    id_class int null 
);
create table teachers (
    id_teacher int auto_increment primary key,
    FullName varchar(45)  null,
    Birthday date  null,
    Gender varchar(45)  null
);
create table subjects (
    id_subject int auto_increment primary key,
    subject_name varchar(45)  null,
    credit  int null,
	id_teacher int not null
);
create table classes(
   id_class int auto_increment primary key,
   class_name varchar(45)  null,
   teacher_name varchar(45)null,
   id_teacher int not null
);
create table grades(
    id_subject int not null primary key,
    id_student int not null ,
    grade float not null,
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
alter table students 
add foreign key (id_class) references classes(id_class) ON DELETE SET NULL;

alter table subjects 
add  foreign key (id_teacher) references teachers(id_teacher) ON DELETE CASCADE;

alter table classes 
add  foreign key (id_teacher) references teachers(id_teacher) ON DELETE CASCADE;
 
 alter table grades 
 add foreign key (id_student) references students(id_student) ON DELETE CASCADE,
 add  foreign key (id_subject) references subjects(id_subject) ON DELETE CASCADE;
 
INSERT INTO teachers (FullName, Birthday, Gender) VALUES
('Nguyễn Văn Đông', '2000-05-12', 'Nam'),
('Trần Thị Hồng', '1999-07-20', 'Nữ'),
('Lê Hoàng Văn', '1988-09-15', 'Nam'),
('Nguyễn Hoàng Long', '1988-12-02', 'Nam'),
('Trần Phương Thanh', '1999-07-20', 'Nữ'),
('Lê Thị Nhai', '2000-10-15', 'Nam');
INSERT INTO subjects (subject_name, credit, id_teacher) VALUES
('Toán', 4, 1),
('Văn', 3, 2),
('Anh', 3, 3),
('sinh', 1, 4),
('sử ', 4, 5),
('Địa', 2, 6);
INSERT INTO classes (class_name,teacher_name, id_teacher) VALUES
('10A1','Nguyễn Văn Đông', 1),
('12A1','Trần Thị Hồng', 2),
('11A2','Lê Hoàng Văn', 3),
('10A1','Nguyễn Hoàng Long', 4),
('09A1','Trần Phương Thanh', 5),
('12A2','Lê Thị Nhai', 6);
INSERT INTO students (FullName, Birthday, Gender, Address, id_class) VALUES
('Nguyễn Quang Hưng', '2002-11-03', 'Nam', 'Quảng trị', 1),
('Trần Thị Diễm', '1999-04-12', 'Nữ', 'Sài gòn', 1),
('Lê Văn Hồng', '2001-09-12', 'Nam', 'Đà Nẵng', 2);
INSERT INTO grades (id_subject, id_student, grade) VALUES
(1, 1, 9.0), 
(2, 2, 7.5), 
(3, 3, 8.5),
(4, 3, 9.0), 
(5, 1, 7.5), 
(6, 2, 8.5); 
--  Lấy danh sách tất cả học sinh.
select * from students;
-- Lấy danh sách giáo viên giảng dạy môn Toán.
select *  from teachers
join subjects on teachers.id_teacher = subjects.id_teacher
where subjects.subject_name = 'Toán';

-- Lấy danh sách học sinh trong lớp 10A1.
select * from students
join classes on students.id_class = classes.id_class
where classes.class_name= '10A1';

-- tìm học sinh có điểm môn toán cao nhất
select students.FullName,grades.grade from students
join grades on students.id_student = grades.id_student
join subjects on grades.id_subject = subjects.id_subject
where subjects.subject_name ='toán'
order by grades.grade desc
limit 1;

-- tìm học sinh có điểm trung bình trên 8.0
select fullname, avg_grade
from(
select students.FullName, avg(grades.grade) as avg_grade
from students
join grades on students.id_student = grades.id_student
group by students.id_student
) as subquery
where avg_grade > 8.0;

-- tìm giáo viên có tuổi lớn nhất
select *, year(CURDATE()) - year(Birthday) as Age 
from teachers 
having Age = (
select MAX(year(CURDATE()) - year(Birthday)
) from teachers
);

-- lấy danh sách học sinh kèm theo lớp học
select students.FullName, classes.class_name from students
join classes on students.id_class=classes.id_class;

-- lấy danh sách điểm số của từng học sinh theo môn học
select students.FuLLName, subjects.subject_name, grades.grade from students
join grades on students.id_student = grades.id_student
join subjects on  subjects.id_subject= grades.id_subject 
order by students.FuLLName;

-- lấy danh sách giáo viên và môn học họ giảng dạy
select teachers.FullName, subjects.subject_name from teachers
join subjects on teachers.id_teacher=subjects.id_teacher;

-- Đếm số lượng học sinh trong từng lớp.
select classes.class_name, count(students.id_student) as count_students
from classes
join students on students.id_class =classes.id_class
group by classes.id_class;

-- tính điểm trung bình của từng học sinh 
select students.FullName, avg(grades.grade) as avg_grade
from students
join grades on students.id_student = grades.id_student
group by students.id_student;

-- tìm lớp có nhiều học sinh nhất 
select classes.class_name, count(students.id_student) as count_students
from classes
join students on students.id_class =classes.id_class
group by classes.id_class
order by count_students desc
limit 1;

-- Cập nhật điểm số của một học sinh.
update grades
set grade =10
where id_student = 1 and id_subject = 1;

-- xóa học sinh có id cụ thể
delete from students where id_student = 1;
