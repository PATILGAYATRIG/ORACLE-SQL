/*Group BY,HAVING*/
--CASE STUDY-1--
/*A company wants to rank products based on their sales. They want to list each product's rank in terms of total sales.*/
CREATE TABLE product_sales (
    product_id NUMBER PRIMARY KEY,
    product_name VARCHAR2(50),
    sales_amount NUMBER
);

INSERT INTO product_sales VALUES (1, 'Laptop', 10000);
INSERT INTO product_sales VALUES (2, 'Tablet', 7000);
INSERT INTO product_sales VALUES (3, 'Smartphone', 15000);
INSERT INTO product_sales VALUES (4, 'Monitor', 5000);
select * from product_sales;

select product_id,product_name,sales_amount,
rank() over (order by sales_amount) as Rank
from product_sales;
    
--CASE STUDY-2--
/*The HR department wants to evaluate employee salary trends based on their tenure. They want to calculate the average salary for employees with tenure in each year.*/
CREATE TABLE employee_details (
    employee_id NUMBER PRIMARY KEY,
    hire_date DATE,
    salary NUMBER
);

INSERT INTO employee_details VALUES (1, TO_DATE('2020-01-15', 'YYYY-MM-DD'), 5500);
INSERT INTO employee_details VALUES (2, TO_DATE('2018-06-10', 'YYYY-MM-DD'), 6000);
INSERT INTO employee_details VALUES (3, TO_DATE('2019-11-25', 'YYYY-MM-DD'), 5200);
INSERT INTO employee_details VALUES (4, TO_DATE('2017-03-14', 'YYYY-MM-DD'), 7500);


select * from employee_details;

select 
to_char(SYSDATE, 'YYYY') - to_char(hire_date,'YYYY') as tenure,
avg(salary) as avg_salary
from employee_details
group by to_char(SYSDATE,'YYYY')- to_char(hire_date,'YYYY');

SELECT
    EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM hire_date) AS years_of_tenure,
    AVG(salary) AS average_salary
FROM
    employee_details
GROUP BY
    EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM hire_date);
    
--CASE STUDY-3--
/* A logistics company wants to analyze its order fulfillment time. They want to calculate the average fulfillment time for each month and the difference between each month's average fulfillment time and the previous month's.*/
CREATE TABLE order_fulfillment (
    order_id NUMBER PRIMARY KEY,
    fulfillment_date DATE,
    order_date DATE
);


INSERT INTO order_fulfillment VALUES (1, TO_DATE('2024-01-10', 'YYYY-MM-DD'), TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO order_fulfillment VALUES (2, TO_DATE('2024-02-05', 'YYYY-MM-DD'), TO_DATE('2024-02-01', 'YYYY-MM-DD'));
INSERT INTO order_fulfillment VALUES (3, TO_DATE('2024-03-08', 'YYYY-MM-DD'), TO_DATE('2024-03-01', 'YYYY-MM-DD'));
INSERT INTO order_fulfillment VALUES (4, TO_DATE('2024-04-07', 'YYYY-MM-DD'), TO_DATE('2024-04-01', 'YYYY-MM-DD'));

select * from order_fulfillment;
select  EXTRACT(YEAR FROM fulfillment_date) AS year,Extract(MONTH from fulfillment_date)as month,avg(fulfillment_date -order_date) AS avg_full,
LAG(avg(fulfillment_date -order_date),1,0) over (order by Extract(MONTH from fulfillment_date),EXTRACT(YEAR FROM fulfillment_date))as pre_avg_ful
from order_fulfillment
group by Extract(MONTH from fulfillment_date), EXTRACT(YEAR FROM fulfillment_date) ;

--CASE STUDY-4--
/*The finance department wants to analyze monthly revenue trends. They need to calculate the cumulative revenue for each month and compare it with the previous month's revenue.
*/
CREATE TABLE monthly_revenue (
    month_date DATE,
    revenue NUMBER
);

INSERT INTO monthly_revenue VALUES (TO_DATE('2024-01-01', 'YYYY-MM-DD'), 10000);
INSERT INTO monthly_revenue VALUES (TO_DATE('2024-02-01', 'YYYY-MM-DD'), 15000);
INSERT INTO monthly_revenue VALUES (TO_DATE('2024-03-01', 'YYYY-MM-DD'), 12000);
INSERT INTO monthly_revenue VALUES (TO_DATE('2024-04-01', 'YYYY-MM-DD'), 18000);

select * from monthly_revenue;
SELECT
    month_date,
    revenue,
    SUM(revenue) OVER (ORDER BY month_date) AS cumulative_revenue,
    LAG(revenue, 1, 0) OVER (ORDER BY month_date) AS previous_month_revenue
FROM
    monthly_revenue;

--CASE STUDY-5--
/*
You work for a retail company that wants to analyze its sales data. The company is interested in finding the total sales and average sales amount per product category. Additionally, they want to see only those categories where the average sales amount exceeds $500.

*/

CREATE TABLE sales (
    sale_id NUMBER PRIMARY KEY,
    category VARCHAR2(50),
    sale_amount NUMBER
);


INSERT INTO sales VALUES (1, 'Electronics', 750);
INSERT INTO sales VALUES (2, 'Electronics', 300);
INSERT INTO sales VALUES (3, 'Furniture', 1200);
INSERT INTO sales VALUES (4, 'Furniture', 800);
INSERT INTO sales VALUES (5, 'Clothing', 450);

SELECT
    category,
    SUM(sale_amount) AS total_sales,
    AVG(sale_amount) AS average_sales
FROM
    sales
GROUP BY
    category
HAVING
    AVG(sale_amount) > 500;

--CASE STUDY-6-
/* A company wants to evaluate employee performance based on sales. The goal is to find the top 3 sales made by each employee using window functions.*/
CREATE TABLE employee_sales (
    employee_id NUMBER,
    sale_id NUMBER,
    sale_amount NUMBER
);


INSERT INTO employee_sales VALUES (101, 1, 1000);
INSERT INTO employee_sales VALUES (101, 2, 1500);
INSERT INTO employee_sales VALUES (101, 3, 700);
INSERT INTO employee_sales VALUES (102, 4, 2000);
INSERT INTO employee_sales VALUES (102, 5, 2500);
INSERT INTO employee_sales VALUES (102, 6, 800);


SELECT
    employee_id,
    sale_id,
    sale_amount
FROM (
    SELECT
        employee_id,
        sale_id,
        sale_amount,
        ROW_NUMBER() OVER (PARTITION BY employee_id ORDER BY sale_amount DESC) AS rank
    FROM
        employee_sales
)
WHERE
    rank <= 3;

--CASE STUDY-7--
/*The HR department wants to analyze salary data to find the average salary in each department. They also want to list departments where the average salary is higher than $5000.
*/

CREATE TABLE employees (
    employee_id NUMBER PRIMARY KEY,
    department_id NUMBER,
    salary NUMBER
);


INSERT INTO employees VALUES (1, 10, 5500);
INSERT INTO employees VALUES (2, 20, 4500);
INSERT INTO employees VALUES (3, 10, 6000);
INSERT INTO employees VALUES (4, 20, 4800);
INSERT INTO employees VALUES (5, 30, 7000);

SELECT
    department_id,
    AVG(salary) AS average_salary
FROM
    employees
GROUP BY
    department_id
HAVING
    AVG(salary) > 5000;

--CASE STUDY-8--
/*You work for an e-commerce company that wants to analyze its order data. The company wants to know the total number of orders and total revenue for each customer. They also want to see customers who have made more than 2 orders.
*/
CREATE TABLE orders (
    order_id NUMBER PRIMARY KEY,
    customer_id NUMBER,
    order_amount NUMBER
);


INSERT INTO orders VALUES (1, 1001, 200);
INSERT INTO orders VALUES (2, 1002, 150);
INSERT INTO orders VALUES (3, 1001, 350);
INSERT INTO orders VALUES (4, 1003, 400);
INSERT INTO orders VALUES (5, 1002, 300);
INSERT INTO orders VALUES (6, 1001, 250);


SELECT
    customer_id,
    COUNT(order_id) AS total_orders,
    SUM(order_amount) AS total_revenue
FROM
    orders
GROUP BY
    customer_id
HAVING
    COUNT(order_id) > 2;
