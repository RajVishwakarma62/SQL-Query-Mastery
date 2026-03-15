create database SQL_Interview_Practice;
go

use SQL_Interview_Practice;
go

create table departments (
	department_id int primary key,
	department_name varchar(255) NOT NULL,
	manager_id int,
	budget decimal(15,2),
	creation_date date
);


create table employees (
	id int primary key,
	name varchar(100) not null,
	salary decimal(15,2),
	department_id int  references departments (department_id),
	manager_id int references employees(id),
	hire_date date,
	join_date date,
	gender varchar(1),
	job_title varchar(100),
	birth_date date,
	termination_date date
);

alter table departments
add constraint fk_dept_manager foreign key (manager_id) references employees(id);

insert into departments (department_id, department_name, manager_id, budget, creation_date)

values(1, 'Executive', NULL, 5000000.00, '2015-01-01'),
(2, 'IT', NULL, 2500000.00, '2015-06-15');


insert into 
employees(id, name, salary, department_id, manager_id, hire_date, join_date, gender, job_title, birth_date, termination_date)

values (1, 'Alice Smith', 250000.00, 1, NULL, '2015-01-10', '2015-01-10', 'F', 'CEO', '1980-05-14', NULL),
(2, 'Bob Johnson', 120000.00, 2, 1, '2015-06-20', '2015-06-20', 'M', 'IT Manager', '1985-08-22', NULL);

update departments
set manager_id = 1
where department_id = 1

update departments
set manager_id = 2
where department_id = 2