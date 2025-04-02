# Retail Sales Analysis - SQL Project

## Project Overview
This project focuses on analyzing retail sales data using **PostgreSQL**. The dataset, **Retail Sales Analysis_utf.csv**, contains transactional sales data, including customer demographics, product categories, and sales information. The objective is to clean, explore, and extract meaningful insights using SQL queries.

## Technologies Used
- **Database:** PostgreSQL
- **Query Language:** SQL
- **Dataset:** Retail Sales Analysis_utf.csv

## Database Schema
The dataset is structured into a table named **retail_sales**, with the following fields:

| Column Name      | Data Type  | Description |
|-----------------|------------|-------------|
| transactions_id | INT (PK)   | Unique ID for each transaction |
| sale_date       | DATE       | Date of the transaction |
| sale_time       | TIME       | Time of the transaction |
| customer_id     | INT        | Unique ID for each customer |
| gender         | VARCHAR(15) | Gender of the customer |
| age            | INT        | Age of the customer |
| category       | VARCHAR(20) | Product category |
| quantity       | INT        | Quantity of items sold |
| price_per_unit | FLOAT      | Price per unit of the product |
| cogs           | FLOAT      | Cost of goods sold |
| total_sale     | FLOAT      | Total sale amount |

## Data Cleaning & Preparation
- Removed NULL values to ensure data integrity.
- Checked for missing values using:
  ```sql
  SELECT * FROM retail_sales WHERE
  transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR
  customer_id IS NULL OR gender IS NULL OR age IS NULL OR category IS NULL OR
  quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL OR total_sale IS NULL;
  ```
- Deleted records with NULL values using:
  ```sql
  DELETE FROM retail_sales WHERE
  transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR
  customer_id IS NULL OR gender IS NULL OR age IS NULL OR category IS NULL OR
  quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL OR total_sale IS NULL;
  ```

## Data Exploration
### Key Insights Extracted

1. **Total Sales and Customers**
   ```sql
   SELECT COUNT(*) as total_sale FROM retail_sales;
   SELECT COUNT(DISTINCT customer_id) as total_customers FROM retail_sales;
   ```

2. **Product Categories Available**
   ```sql
   SELECT DISTINCT category FROM retail_sales;
   ```

3. **Sales on a Specific Date**
   ```sql
   SELECT * FROM retail_sales WHERE sale_date = '2022-11-05';
   ```

4. **High-Quantity Clothing Sales in November 2022**
   ```sql
   SELECT * FROM retail_sales WHERE category = 'Clothing' AND quantity >= 4
   AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';
   ```

5. **Total Sales per Category**
   ```sql
   SELECT category, SUM(total_sale) AS net_sale, COUNT(*) AS total_orders FROM retail_sales GROUP BY category;
   ```

6. **Average Age of Customers in 'Beauty' Category**
   ```sql
   SELECT ROUND(AVG(age)) as Average_age_for_beauty FROM retail_sales WHERE category = 'Beauty';
   ```

7. **Transactions with Total Sales Over 1000**
   ```sql
   SELECT * FROM retail_sales WHERE total_sale >= 1000;
   ```

8. **Sales Distribution by Gender & Category**
   ```sql
   SELECT gender, category, COUNT(transactions_id) as transactions FROM retail_sales GROUP BY gender, category;
   ```

9. **Best Selling Month in Each Year**
   ```sql
   SELECT year, month, avg_total_sale FROM (
     SELECT EXTRACT(YEAR from sale_date) as year,
            EXTRACT(MONTH from sale_date) as month,
            AVG(total_sale) as avg_total_sale,
            RANK() OVER(PARTITION BY EXTRACT(YEAR from sale_date) ORDER BY AVG(total_sale) DESC) as rank
     FROM retail_sales GROUP BY 1,2) as t1
   WHERE rank = 1;
   ```

10. **Top 5 Customers by Total Sales**
    ```sql
    SELECT customer_id, SUM(total_sale) as total FROM retail_sales GROUP BY customer_id ORDER BY total DESC LIMIT 5;
    ```

11. **Unique Customers per Category**
    ```sql
    SELECT COUNT(DISTINCT customer_id) as Customer_count, category FROM retail_sales GROUP BY category;
    ```

12. **Sales by Shift (Morning, Afternoon, Evening)**
    ```sql
    WITH hourly_sale AS (
      SELECT *, CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening' END AS shift
      FROM retail_sales)
    SELECT shift, COUNT(transactions_id) as orders FROM hourly_sale GROUP BY shift;
    ```

## Conclusion
This project showcases how SQL can be used to clean, explore, and analyze retail sales data effectively. By leveraging PostgreSQL, we successfully derived insights into customer behavior, product performance, and sales trends.

## How to Run the Project
1. Install **PostgreSQL** if not already installed.
2. Create the database and table using the SQL scripts provided.
3. Import the **Retail Sales Analysis_utf.csv** dataset into the table.
4. Run the SQL queries for analysis.



