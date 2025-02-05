-- Subqueries--
CREATE TABLE departments (
    department_id NUMBER PRIMARY KEY,
    department_name VARCHAR2(50) NOT NULL
);
CREATE TABLE jobs (
    job_id NUMBER PRIMARY KEY,
    job_title VARCHAR2(50) NOT NULL
);
CREATE TABLE employees (
    employee_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    job_id NUMBER,
    manager_id NUMBER,
    department_id NUMBER,
    hire_date DATE,
    salary NUMBER(10,2),
    FOREIGN KEY (job_id) REFERENCES jobs(job_id),
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);
INSERT INTO departments VALUES (10, 'ACCOUNTING');
INSERT INTO departments VALUES (20, 'HR');
INSERT INTO departments VALUES (30, 'IT');

INSERT INTO jobs VALUES (1, 'Manager');
INSERT INTO jobs VALUES (2, 'Developer');
INSERT INTO jobs VALUES (3, 'Analyst');

INSERT INTO employees VALUES (101, 'John', 'Doe', 1, NULL, 10, TO_DATE('2010-06-15', 'YYYY-MM-DD'), 9000);
INSERT INTO employees VALUES (102, 'Alice', 'Smith', 2, 101, 10, TO_DATE('2012-08-21', 'YYYY-MM-DD'), 6000);
INSERT INTO employees VALUES (103, 'Bob', 'Brown', 3, 101, 10, TO_DATE('2015-01-10', 'YYYY-MM-DD'), 5000);
INSERT INTO employees VALUES (104, 'Emma', 'White', 2, 101, 20, TO_DATE('2017-09-05', 'YYYY-MM-DD'), 7000);
INSERT INTO employees VALUES (105, 'David', 'Black', 3, 102, 30, TO_DATE('2020-02-15', 'YYYY-MM-DD'), 5500);
SELECT * FROM departments;
SELECT * FROM jobs;
SELECT * FROM employees;

/*List the employees who have a salary greater than the average salary of their department.*/

create table dept(

  deptno number(2,0),

  dname  varchar2(14),

  loc    varchar2(13),

  constraint pk_dept primary key (deptno)

);

create table emp(

  empno    number(4,0),

  ename    varchar2(10),

  job      varchar2(9),

  mgr      number(4,0),

  hiredate date,

  sal      number(7,2),

  comm     number(7,2),

  deptno   number(2,0),

  constraint pk_emp primary key (empno),

  constraint fk_deptno foreign key (deptno) references dept (deptno)

);
insert into dept
values(10, 'ACCOUNTING', 'NEW YORK');
insert into dept
values(20, 'RESEARCH', 'DALLAS');
insert into dept
values(30, 'SALES', 'CHICAGO');
insert into dept
values(40, 'OPERATIONS', 'BOSTON');
select * from dept;



insert into emp
values(
7839, 'KING', 'PRESIDENT', null,
to_date('17-11-1981','dd-mm-yyyy'),
5000, null, 10
);
insert into emp
values(
7698, 'BLAKE', 'MANAGER', 7839,
to_date('1-5-1981','dd-mm-yyyy'),
2850, null, 30
);
insert into emp
values(
7782, 'CLARK', 'MANAGER', 7839,
to_date('9-6-1981','dd-mm-yyyy'),
2450, null, 10
);
insert into emp
values(
7566, 'JONES', 'MANAGER', 7839,
to_date('2-4-1981','dd-mm-yyyy'),
2975, null, 20
);
insert into emp
values(
7788, 'SCOTT', 'ANALYST', 7566,
to_date('9-12-1981','dd-mm-yyyy'),
3000, null, 20
);
insert into emp
values(
7902, 'FORD', 'ANALYST', 7566,
to_date('3-12-1981','dd-mm-yyyy'),
3000, null, 20
);
insert into emp
values(
7369, 'SMITH', 'CLERK', 7902,
to_date('17-12-1980','dd-mm-yyyy'),
800, null, 20
);
insert into emp
values(
7499, 'ALLEN', 'SALESMAN', 7698,
to_date('20-2-1981','dd-mm-yyyy'),
1600, 300, 30
);
insert into emp
values(
7521, 'WARD', 'SALESMAN', 7698,
to_date('22-2-1981','dd-mm-yyyy'),
1250, 500, 30
);
insert into emp
values(
7654, 'MARTIN', 'SALESMAN', 7698,
to_date('28-9-1981','dd-mm-yyyy'),
1250, 1400, 30
);
insert into emp
values(
7844, 'TURNER', 'SALESMAN', 7698,
to_date('8-9-1981','dd-mm-yyyy'),
1500, 0, 30
);
insert into emp
values(
7876, 'ADAMS', 'CLERK', 7788,
to_date('12-1-1983', 'dd-mm-yyyy'),
1100, null, 20
);
insert into emp
values(
7900, 'JAMES', 'CLERK', 7698,
to_date('3-12-1981','dd-mm-yyyy'),
950, null, 30
);
insert into emp
values(
7934, 'MILLER', 'CLERK', 7782,
to_date('23-1-1982','dd-mm-yyyy'),
1300, null, 10
);
select *from emp;
SELECT * FROM EMP E1
WHERE SAL>
(
SELECT
AVG(SAL)
FROM EMP E2
WHERE E1.DEPTNO=E2.DEPTNO

);
/*### Question 2:
Find the department with the highest average salary.
*/
SELECT DEPTNO, avg_salary
FROM (
    SELECT DEPTNO, AVG(SAL) AS avg_salary
    FROM EMP
    GROUP BY DEPTNO
    ORDER BY avg_salary DESC
) WHERE ROWNUM = 1;
/*Question 3:
List the employees who are managers and have at least one employee reporting to them.
*/

select
e.* from employees e
join employees e1 on e.employee_id=e1.manager_id
where e.employee_id in(
select distinct manager_id 
from 
(
select distinct manager_id ,count(*) from employees e 
where manager_id is not null
group by manager_id
having count(*)>=1 
)
) and e.employee_id in (select distinct manager_id from employees)


/*Find the job title and the number of employees who hold that job title.*/
select * from jobs;
select distinct j.job_title,count(e.job_id)
over (partition by e.job_id) as counts
from employees e
join jobs j on j.job_id=e.job_id;
---solution2---
select distinct j.job_title,count(e.job_id) as counts
from employees e
join jobs j on j.job_id=e.job_id;b
group by job_title;



/*List the employeees who have the same job title as the employee with ID 102.*/
SELECT * FROM EMPLOYEES
WHERE JOB_ID =(SELECT JOB_ID FROM EMPLOYEES WHERE EMPLOYEE_ID=102);
/*List the department(s) with the highest total salary expense.*/

SELECT 
    DEPARTMENT_NAME, 
    TOTAL_SAL 
FROM (
    SELECT 
        D.DEPARTMENT_NAME, 
        SUM(E.SALARY) AS TOTAL_SAL 
    FROM departments D 
    JOIN employees E ON D.DEPARTMENT_ID = E.DEPARTMENT_ID 
    GROUP BY D.DEPARTMENT_NAME 
    ORDER BY SUM(E.SALARY) DESC
) TEMP 
WHERE ROWNUM = 1;

/*Find the employee(s) who have the highest salary in each department.*/

SELECT * FROM EMP;
--ONE WAY--
SELECT
* FROM EMPLOYEES
WHERE (DEPARTMENT_ID,SALARY) IN
(SELECT DEPARTMENT_ID,MAX(SALARY) FROM EMPLOYEES GROUP BY DEPARTMENT_ID);

--SECOND WAY--
SELECT e.employee_id, e.first_name, e.last_name, e.salary, e.department_id
FROM employees e
JOIN (
    SELECT department_id, MAX(salary) AS max_salary
    FROM employees
    GROUP BY department_id
) max_salaries ON e.department_id = max_salaries.department_id
    AND e.salary = max_salaries.max_salary;

/*List the department(s) with more than 5 employees and an average salary greater than $5000.*/
SELECT
D.DEPARTMENT_NAME,
E.* FROM DEPARTMENTS D
JOIN EMPLOYEES E ON D.DEPARTMENT_ID=E.DEPARTMENT_ID
WHERE 
(SELECT COUNT(*) FROM EMPLOYEES E1 WHERE E1.DEPARTMENT_ID=E.DEPARTMENT_ID)>1
AND
(SELECT AVG(SALARY) FROM EMPLOYEES E1 WHERE E1.DEPARTMENT_ID=E.DEPARTMENT_ID)>5000;

/*Find the employee(s) who have been with the company for more than 10 years.*/
SELECT 
* FROM
EMPLOYEES
WHERE (EXTRACT (YEAR FROM SYSDATE)-EXTRACT(YEAR FROM HIRE_DATE))>10;

/*List the job titles where the maximum salary is greater than $7000.*/
SELECT E.*
JOB_ID
FROM EMPLOYEES E
WHERE 
(SELECT MAX(SALARY) FROM EMPLOYEES E1 E1.JOB_ID=E.JOB_ID)>7000;

SELECT MAX(SALARY) FROM EMPLOYEES E1 E1.JOB_ID=E.JOB_ID;

/*List the employees who have the same job as their manager.*/
select * from employees;
SELECT e.*
FROM employees e
JOIN  employees e1 on e.EMPLOYEE_ID=e1.MANAGER_ID
WHERE e.JOB_ID=e1.JOB_ID;

/*Find the department(s) where the total salary expense is greater than the average salary expense of all departments.*/

SELECT department_id, SUM(salary) AS total_salary_expense
FROM employees
GROUP BY department_id
HAVING SUM(salary) > (
    SELECT SUM(average)
    FROM (
        SELECT AVG(salary) AS average
        FROM employees
        GROUP BY department_id
    )
);

/*List the employee(s) who have the highest salary but are not managers.*/

select 
* from 
employees
where salary=
(select max(salary)
from employees 
where employee_id not in(select manager_id from employees where manager_id is not null));


/*Find the department(s) with the lowest average salary.*/

select *
from
(
select department_id,
avg(salary) as avr from employees e
group by department_id 
order by avg(salary) asc
)where ROWNUM =1;


