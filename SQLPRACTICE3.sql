CASE STUDIES ON BASIC SUB-QUERIES 
/*Find the department with the highest number of employees.*/
CREATE TABLE departments (
    department_id NUMBER PRIMARY KEY,
    department_name VARCHAR2(50) NOT NULL
);
CREATE TABLE employees (
    employee_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    salary NUMBER(10,2),
    department_id NUMBER,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);
INSERT INTO departments (department_id, department_name) VALUES (10, 'IT');
INSERT INTO departments (department_id, department_name) VALUES (20, 'HR');
INSERT INTO departments (department_id, department_name) VALUES (30, 'Finance');
INSERT INTO departments (department_id, department_name) VALUES (40, 'Marketing');
INSERT INTO employees (employee_id, first_name, last_name, salary, department_id) VALUES (1, 'John', 'Doe', 5000, 10);
INSERT INTO employees (employee_id, first_name, last_name, salary, department_id) VALUES (2, 'Alice', 'Smith', 7000, 10);
INSERT INTO employees (employee_id, first_name, last_name, salary, department_id) VALUES (3, 'Bob', 'Johnson', 4500, 20);
INSERT INTO employees (employee_id, first_name, last_name, salary, department_id) VALUES (4, 'David', 'Brown', 5500, 20);
INSERT INTO employees (employee_id, first_name, last_name, salary, department_id) VALUES (5, 'Emma', 'Wilson', 8000, 30);
INSERT INTO employees (employee_id, first_name, last_name, salary, department_id) VALUES (6, 'Olivia', 'Taylor', 6200, 30);
INSERT INTO employees (employee_id, first_name, last_name, salary, department_id) VALUES (7, 'James', 'Anderson', 4000, 40);
INSERT INTO employees (employee_id, first_name, last_name, salary, department_id) VALUES (8, 'Sophia', 'White', 7500, 40);
INSERT INTO employees (employee_id, first_name, last_name, salary, department_id) VALUES (9, 'Michael', 'Lee', 6700, 10);

select * from employees;
select * from departments;

/*Retrieve the details of employees who earn more than the average salary of their department.*/
select * from
employees e1
where salary >(
select avg(salary)as avr from employees e
where e1.department_id= e.department_id
group by department_id
);

/*Find the department with the highest number of employees.*/
select
department_id,counts
from
(select department_id,count(*) as counts from employees group by department_id order by count(*) desc
)where rownum=1;

/*Retrieve the department name along with the total number of employees working in each department.
*/
select d.department_name,sum(salary) as total 
from employees e
join departments d on e.department_id=d.department_id
group by d.department_name;

/*?	Find the department name where the employee 'John' works.*/
select
e.*,d.department_name
from employees e
join departments d on e.department_id=d.department_id
where e.first_name='John';
/*?	Retrieve the details of employees who are not managers. */
CREATE TABLE employees1 (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    job_title VARCHAR(50),
    manager_id INT,
    hire_date DATE,
    dept_id INT
);

CREATE TABLE departments1 (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50),
    manager_id INT
);

-- Insert into departments table
INSERT INTO departments1 (dept_id, dept_name, manager_id) VALUES 
(1, 'HR', 101);
INSERT INTO departments1 (dept_id, dept_name, manager_id) VALUES 
(2, 'Finance', 102);
INSERT INTO departments1 (dept_id, dept_name, manager_id) VALUES 
(3, 'IT', 103);
INSERT INTO departments1 (dept_id, dept_name, manager_id) VALUES 
(4, 'Marketing', 104);

-- Insert into employees table
INSERT INTO employees1 (emp_id, emp_name, job_title, manager_id, hire_date, dept_id) VALUES 
(101, 'Steven King', 'Manager', NULL, TO_DATE('2010-05-15', 'YYYY-MM-DD'), 1);
INSERT INTO employees1 (emp_id, emp_name, job_title, manager_id, hire_date, dept_id) VALUES 
(102, 'John Doe', 'Manager', NULL, TO_DATE('2012-07-23', 'YYYY-MM-DD'), 2);
INSERT INTO employees1 (emp_id, emp_name, job_title, manager_id, hire_date, dept_id) VALUES 
(103, 'Jane Smith', 'Manager', NULL, TO_DATE('2015-09-12', 'YYYY-MM-DD'), 3);
INSERT INTO employees1 (emp_id, emp_name, job_title, manager_id, hire_date, dept_id) VALUES 
(104, 'Michael Brown', 'Manager', NULL, TO_DATE('2018-03-10', 'YYYY-MM-DD'), 4);
INSERT INTO employees1 (emp_id, emp_name, job_title, manager_id, hire_date, dept_id) VALUES 
(105, 'Alice Green', 'Software Engineer', 103, TO_DATE('2016-06-20', 'YYYY-MM-DD'), 3);
INSERT INTO employees1 (emp_id, emp_name, job_title, manager_id, hire_date, dept_id) VALUES 
(106, 'Bob White', 'Accountant', 102, TO_DATE('2011-10-05', 'YYYY-MM-DD'), 2);
INSERT INTO employees1 (emp_id, emp_name, job_title, manager_id, hire_date, dept_id) VALUES 
(107, 'Charlie Black', 'HR Assistant', 101, TO_DATE('2014-02-18', 'YYYY-MM-DD'), 1);
INSERT INTO employees1 (emp_id, emp_name, job_title, manager_id, hire_date, dept_id) VALUES 
(108, 'David Blue', 'Marketing Executive', 104, TO_DATE('2019-11-30', 'YYYY-MM-DD'), 4);

select * from departments1;
select * from employees1;

select *
from employees1
where manager_id is not null and emp_id!= manager_id;

/*?	Find the employees who joined the company before their manager.*/
select e.*, e.hire_date as employees_date,
e1.hire_date as manager_date
from employees1 e
join employees1 e1
on e1.emp_id=e.manager_id
where e.hire_date>e1.hire_date;

/*?	List the employees who do not work in departments managed by 'Steven King'.*/
select * from employees1
where dept_id  not in 
(
select dept_id from employees1
where emp_name='Steven King'
);

