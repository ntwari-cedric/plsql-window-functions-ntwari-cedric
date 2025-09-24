--
-- Database and Table Creation
--

-- Create farmers table
CREATE TABLE farmers (
  farmer_id VARCHAR(26) PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  region VARCHAR(50)
);

-- Create crops table
CREATE TABLE crops (
  crop_id VARCHAR(10) PRIMARY KEY,
  crop_name VARCHAR(100) NOT NULL,
  category VARCHAR(50)
);

-- Create sales table
CREATE TABLE sales (
  sale_id VARCHAR(10) PRIMARY KEY,
  farmer_id VARCHAR(18) REFERENCES farmers (farmer_id),
  crop_id VARCHAR(10) REFERENCES crops (crop_id),
  sale_date DATE NOT NULL,
  amount NUMERIC (12,2) NOT NULL
);

--
-- Data Insertion
--

-- Inserting data into farmers table
INSERT INTO farmers (farmer_id, name, region) VALUES ('f001', 'murekatete', 'rubavu');
INSERT INTO farmers (farmer_id, name, region) VALUES ('f002', 'nyiramakuba', 'musanze');
INSERT INTO farmers (farmer_id, name, region) VALUES ('f003', 'mvuyekure', 'karongi');
INSERT INTO farmers (farmer_id, name, region) VALUES ('f004', 'masunzu', 'musanze');
INSERT INTO farmers (farmer_id, name, region) VALUES ('f005', 'niyigena', 'rubavu');

-- Inserting data into crops table
INSERT INTO crops (crop_id, crop_name, category) VALUES ('001', 'tea', 'Cash Crops');
INSERT INTO crops (crop_id, crop_name, category) VALUES ('002', 'maize', 'Staple Food Crops');
INSERT INTO crops (crop_id, crop_name, category) VALUES ('003', 'potatoes', 'Staple Food Crops');
INSERT INTO crops (crop_id, crop_name, category) VALUES ('004', 'beans', 'Staple Food Crops');

-- Inserting data into sales table
INSERT INTO sales (sale_id, farmer_id, crop_id, sale_date, amount) VALUES ('s100', 'f004', '003', '2025-01-02', 820000.00);
INSERT INTO sales (sale_id, farmer_id, crop_id, sale_date, amount) VALUES ('s101', 'f003', '001', '2025-02-04', 1100000.00);
INSERT INTO sales (sale_id, farmer_id, crop_id, sale_date, amount) VALUES ('s102', 'f003', '001', '2025-02-14', 800000.00);
INSERT INTO sales (sale_id, farmer_id, crop_id, sale_date, amount) VALUES ('s103', 'f005', '002', '2025-03-02', 100000.00);
INSERT INTO sales (sale_id, farmer_id, crop_id, sale_date, amount) VALUES ('s104', 'f002', '003', '2025-03-16', 610000.00);
INSERT INTO sales (sale_id, farmer_id, crop_id, sale_date, amount) VALUES ('s105', 'f001', '004', '2025-03-16', 160000.00);
INSERT INTO sales (sale_id, farmer_id, crop_id, sale_date, amount) VALUES ('s106', 'f004', '003', '2025-04-04', 440500.00);
INSERT INTO sales (sale_id, farmer_id, crop_id, sale_date, amount) VALUES ('s107', 'f005', '004', '2025-08-14', 70000.00);
INSERT INTO sales (sale_id, farmer_id, crop_id, sale_date, amount) VALUES ('s108', 'f001', '004', '2025-07-11', 120000.00);
INSERT INTO sales (sale_id, farmer_id, crop_id, sale_date, amount) VALUES ('s109', 'f002', '003', '2025-09-01', 500000.00);

--
-- Window Functions Implementation
--

-- Ranking: ROW_NUMBER()
SELECT
  farmer_id,
  SUM(amount) AS total_revenue,
  ROW_NUMBER() OVER (ORDER BY SUM(amount) DESC) AS row_num
FROM sales
GROUP BY farmer_id;

-- Ranking: RANK()
SELECT
  farmer_id,
  SUM(amount) AS total_revenue,
  RANK() OVER (ORDER BY SUM(amount) DESC) AS rank_pos
FROM sales
GROUP BY farmer_id;

-- Ranking: DENSE_RANK()
SELECT
  farmer_id,
  SUM(amount) AS total_revenue,
  DENSE_RANK() OVER (ORDER BY SUM(amount) DESC) AS dense_rank_pos
FROM sales
GROUP BY farmer_id;

-- Ranking: PERCENT_RANK()
SELECT
  farmer_id,
  SUM(amount) AS total_revenue,
  PERCENT_RANK() OVER (ORDER BY SUM(amount) DESC) AS percent_rank
FROM sales
GROUP BY farmer_id;

-- Aggregate: SUM() OVER() (Running Total)
SELECT
  sale_id,
  farmer_id,
  sale_date,
  amount,
  SUM(amount) OVER (ORDER BY sale_date) AS running_total
FROM sales
ORDER BY sale_date;

-- Navigation: LAG()
SELECT
  sale_id,
  sale_date,
  amount,
  LAG(amount, 1, 0) OVER (ORDER BY sale_date) AS previous_sale_amount,
  amount - LAG(amount, 1, 0) OVER (ORDER BY sale_date) AS difference
FROM sales
ORDER BY sale_date;

-- Navigation: LEAD()
SELECT
  sale_id,
  sale_date,
  amount,
  LEAD(amount, 1, 0) OVER (ORDER BY sale_date) AS next_sale_amount,
  LEAD(amount, 1, 0) OVER (ORDER BY sale_date) - amount AS difference
FROM sales
ORDER BY sale_date;

-- Distribution: NTILE(4)
SELECT
  farmer_id,
  SUM(amount) AS total_revenue,
  NTILE(4) OVER (ORDER BY SUM(amount) DESC) AS quartile
FROM sales
GROUP BY farmer_id
ORDER BY total_revenue DESC;

-- Distribution: CUME_DIST()
SELECT
  farmer_id,
  SUM(amount) AS total_revenue,
  CUME_DIST() OVER (ORDER BY SUM(amount) DESC) AS cume_dist_value
FROM sales
GROUP BY farmer_id
ORDER BY total_revenue DESC;

-- Aggregate: AVG() (Moving Average)
SELECT
  sale_date,
  amount,
  AVG(amount) OVER (
    ORDER BY sale_date
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
  ) AS moving_average_3_month
FROM sales
ORDER BY sale_date;

-- Non-windowed Aggregate: AVG()
SELECT
  farmer_id,
  AVG(amount) AS avg_sale
FROM sales
GROUP BY farmer_id;

-- Non-windowed Aggregate: MIN() & MAX()
SELECT
  MIN(amount) AS MinimumSale,
  MAX(amount) AS MaximumSale
FROM sales;

-- This query selects all data from the 'sales' table for transactions
-- where the amount is greater than 500,000. This is useful for analyzing
-- high-value transactions.
SELECT * FROM sales
WHERE amount > 500000;

-- This query groups sales by 'farmer_id' and uses the HAVING clause
-- to filter for farmers who have sold more than one unique crop.
SELECT farmer_id
FROM sales
GROUP BY farmer_id
HAVING COUNT(DISTINCT crop_id) > 1;

-- This query joins the 'sales' and 'farmers' tables to link sales data to regions.
-- It then groups by 'region' to calculate the total revenue for each area.
SELECT f.region,
       SUM(s.amount) AS total_revenue
FROM sales s
JOIN farmers f
  ON s.farmer_id = f.farmer_id
GROUP BY f.region;

-- This query extracts the month from the 'sale_date' and calculates the
-- total monthly sales specifically for the crop with ID '003'.
SELECT EXTRACT(MONTH FROM sale_date) AS sales_month,
       SUM(amount) AS monthly_sales
FROM sales
WHERE crop_id = '003'
GROUP BY sales_month
ORDER BY sales_month;

-- This query calculates the total sales for each quarter and then uses
-- the NTILE(4) window function to divide the quarters into four quartiles
-- based on their total revenue, from highest to lowest.
SELECT EXTRACT(QUARTER FROM sale_date) AS sales_quarter,
       SUM(amount) AS total_revenue,
       NTILE(4) OVER (ORDER BY SUM(amount) DESC) AS revenue_quartile
FROM sales
GROUP BY sales_quarter
ORDER BY total_revenue DESC;