-- SQL Retail Sales Analysis--
CREATE DATABASE project_1;

--CREATE TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
     (
		transactions_id	INT PRIMARY KEY,
		sale_date	DATE,
		sale_time	TIME,
		customer_id	INT,
		gender	VARCHAR(15),
		age	INT,
		category VARCHAR(20),
		quantiy	INT,
		price_per_unit FLOAT,	
		cogs	FLOAT,
		total_sale FLOAT
    );


SELECT * FROM retail_sales
LIMIT 10;

SELECT COUNT(*) FROM retail_sales;


--
SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR 
	sale_date IS NULL
	OR 
	sale_time IS NULL
	OR 
	customer_id IS NULL
	OR 
	gender IS NULL
	OR 
	age IS NULL
	OR 
	category IS NULL
	OR 
	quantiy IS NULL
	OR 
	price_per_unit IS NULL
	OR 
	cogs IS NULL
	OR 
	total_sale IS NULL

--
DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR 
	sale_date IS NULL
	OR 
	sale_time IS NULL
	OR 
	customer_id IS NULL
	OR 
	gender IS NULL
	OR 
	age IS NULL
	OR 
	category IS NULL
	OR 
	quantiy IS NULL
	OR 
	price_per_unit IS NULL
	OR 
	cogs IS NULL
	OR 
	total_sale IS NULL


--Data Exploration

--How many sales we have
SELECT COUNT(*) as total_sale FROM retail_sales;

--How may customers we have
SELECT COUNT(DISTINCT customer_id) as total_customers FROM retail_sales;

--What categories we have
SELECT DISTINCT category as Categories FROM retail_sales;

--Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05'

--Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
SELECT * FROM retail_sales
WHERE category = 'Clothing'
	and
	quantiy >=4
	and 
	TO_CHAR (sale_date, 'YYYY-MM') = '2022-11'

--Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category, 
		SUM(total_sale) as net_sale,
		COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category

--Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT ROUND(AVG(age)) as Average_age_for_beauty
FROM retail_sales
WHERE category='Beauty'

--Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT *
FROM retail_sales
WHERE total_sale >=1000

--Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT gender, category,COUNT(transactions_id) as transactions
FROM retail_sales
GROUP BY 
gender, category


--Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT year,
		month,
		avg_total_sale
FROM(
		SELECT 
			EXTRACT(YEAR from sale_date) as year,
			EXTRACT(MONTH from sale_date) as month,
			AVG(total_sale) as avg_total_sale,
			RANK() OVER(PARTITION BY EXTRACT(YEAR from sale_date) ORDER BY AVG(total_sale) DESC) as rank
		FROM retail_sales
		GROUP BY 1,2
	) as t1
WHERE rank = 1


--Write a SQL query to find the top 5 customers based on the highest total sales
SELECT customer_id, SUM(total_sale) as total
FROM retail_sales
group by customer_id
order by total desc
limit 5

--Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
		COUNT(DISTINCT customer_id) as Customer_count,
		category
FROM retail_sales
group by category;

--Write a SQL query to create each shift and 
--number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
as
(SELECT *,
					case
						when EXTRACT(HOUR FROM sale_time) < 12 then 'Morning'
						when EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 then 'Afternoon'
						else 'Evening'
					end as shift
FROM retail_sales)
SELECT shift,
		COUNT(transactions_id) as orders
FROM hourly_sale
GROUP BY shift
