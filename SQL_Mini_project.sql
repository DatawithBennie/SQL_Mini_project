--creating the customers table
CREATE TABLE customers_data( 
     customer_id INTEGER PRIMARY KEY,
	 customer_first_name VARCHAR (30),
	 customer_last_name VARCHAR (30),
	 email VARCHAR (100),
	 address VARCHAR (50),
	 phone VARCHAR (15),
	 age INTEGER,
	 gender VARCHAR (10)
);

--creating the aisles table
CREATE TABLE aisles_data(
  aisle_id INTEGER PRIMARY KEY,
  aisle VARCHAR (30)
);

--creating the cashier table
CREATE TABLE cashier_data(
    cashier_id VARCHAR (10) PRIMARY KEY,
	cashier_name VARCHAR (30),
	store_location VARCHAR (20),
	gender VARCHAR (1),
	salary INTEGER
);

--creating the department table
CREATE TABLE department_data(
     department_id INTEGER PRIMARY KEY,
	 department VARCHAR (20)
);

--creating the product table
CREATE TABLE product_data(
   product_id VARCHAR (5) PRIMARY KEY,
   product_name VARCHAR (100),
   aisle_id INTEGER REFERENCES aisles_data(aisle_id),
   department_id INTEGER REFERENCES department_data( department_id),
   unit_price INTEGER,
   unit_cost NUMERIC (10,2)  
);

--creating the order table
CREATE TABLE order_data (
   order_id VARCHAR (5) PRIMARY KEY,
   customer_id INTEGER REFERENCES customers_data(customer_id),
   order_date DATE,
   order_time TIME,
   product_id VARCHAR (10) REFERENCES product_data(product_id),
   quanity INTEGER,
   cashier_id VARCHAR (10) REFERENCES cashier_data(cashier_id),
   payment_type VARCHAR (15)
   );

SELECT *
FROM cashier_data


ALTER TABLE product_data
ALTER COLUMN product_name TYPE VARCHAR(255);

ALTER TABLE product_data
ALTER COLUMN product_id TYPE VARCHAR (10);

ALTER TABLE order_data
ALTER COLUMN order_id TYPE VARCHAR (10);


1;

SELECT product_name,
   SUM(unit_price * quanity) AS Revenue
   FROM product_data AS p
   INNER JOIN order_data AS o ON p.product_id = o.product_id
   GROUP BY product_name
   ORDER BY Revenue DESC
   LIMIT 5;

2;

SELECT product_name,
   EXTRACT (DOW FROM order_date) +1 AS day_of_the_week,
	TO_CHAR (order_date,'day') AS Day_name
 FROM product_data AS p
 INNER JOIN order_data AS o ON p.product_id = o.product_id
 WHERE product_name ILIKE '%Chocolate%'
 ORDER BY day_name DESC
 LIMIT 1;

3;

SELECT department,
  SUM (unit_price * quanity) AS Revenue,
  SUM ((unit_price - unit_cost)*quanity) AS profit
  FROM product_data AS p 
 INNER JOIN department_data AS d ON p.department_id = d.department_id
 INNER JOIN order_data AS o ON p.product_id =o.product_id
 GROUP BY department
 HAVING SUM  (unit_price * quanity) >15000000;

4 

SELECT department, order_date
FROM product_data AS p 
INNER JOIN order_data AS o ON p.product_id = o.product_id
INNER JOIN department_data AS d ON p.department_id = d.department_id
WHERE department ILIKE '%alcohol%' AND o.order_date = '2019-12-25';

--No they don't buy more alcohol.

5

SELECT
SUM ((unit_price - unit_cost) * quanity) AS Profit,
EXTRACT( YEAR FROM order_date) AS order_year
FROM product_data AS p
INNER JOIN order_data AS o ON p.product_id = o.product_id
GROUP BY EXTRACT( YEAR FROM order_date)
ORDER BY Profit DESC
LIMIT 1;


6 

SELECT payment_type,
EXTRACT( YEAR FROM order_date) AS order_year
FROM order_data
WHERE EXTRACT( YEAR FROM order_date) <2022 AND payment_type = 'ATM';

--NO. Before 2022 the use of ATM(Card payment) was 295,823, from 2022 it is 53,253.


7

SELECT department,
EXTRACT (HOUR FROM order_time) AS order_hour
CASE
  WHEN EXTRACT (HOUR FROM order_time) BETWEEN 6 AND 11 THEN 'Morning'
  WHEN EXTRACT (HOUR FROM order_time) BETWEEN 12 AND 16 THEN 'Afteroon'
   WHEN EXTRACT (HOUR FROM order_time) BETWEEN 17 AND 20 THEN 'Evening'
  ELSE 'Night'
  END AS time_of_day
FROM product_data AS p 
INNER JOIN department_data AS d ON p.department_id= d.department_id
INNER JOIN order_data AS o ON p.product_id = o.product_id 
WHERE department = 'alcohol'
ORDER BY order_hour DESC 
LIMIT 5;


8

SELECT 
   EXTRACT (QUARTER FROM order_date) AS order_quarter,
  SUM (unit_price * quanity) AS Total_Revenue
  FROM product_data AS p
  INNER JOIN order_data AS o ON p.product_id = o.product_id
  WHERE product_name ILIKE '%Bread%' 
  AND EXTRACT (QUARTER FROM order_date) IN (2,3)
  AND EXTRACT (YEAR FROM order_date) = 2016
  GROUP BY EXTRACT (QUARTER FROM order_date);


9

SELECT product_name
FROM
     (SELECT product_name,order_date,
  EXTRACT (YEAR FROM order_date) AS order_year,
    CASE
  WHEN EXTRACT (HOUR FROM order_time) BETWEEN 6 AND 11 THEN 'Morning'
  WHEN EXTRACT (HOUR FROM order_time) BETWEEN 12 AND 16 THEN 'Afteroon'
   WHEN EXTRACT (HOUR FROM order_time) BETWEEN 17 AND 20 THEN 'Evening'
  ELSE 'Night'
  END AS time_of_day
  FROM product_data AS p 
  INNER JOIN order_data AS o ON p.product_id = o.product_id) AS Sales
  WHERE time_of_day = 'Night'
  AND EXTRACT (YEAR FROM order_date) BETWEEN  2020 AND 2022
  GROUP BY product_name
  LIMIT 3;

 10

 SELECT 
     SUM( CASE 
	         WHEN p.product_name ILIKE '%jucice%'
			 THEN p.unit_price *o.quanity
			 ELSE 0 
			 END) AS jucice_Revenue,
			 SUM (unit_price * quanity) AS total_revenue	 
	FROM product_data AS p 
	INNER JOIN order_data AS o ON p.product_id= o.product_id

 --No 
  
  



