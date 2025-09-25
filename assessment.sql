--creation of farmer table
CREATE TABLE farmers (
    farmer_id VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region VARCHAR(50)
);

--creation of crops table
CREATE TABLE crops (
    crop_id VARCHAR(10) PRIMARY KEY,
    crop_name VARCHAR(100) NOT NULL,
    category VARCHAR(50)
);

-- creation of sales table
CREATE TABLE sales (
    sale_id VARCHAR(10) PRIMARY KEY,
    farmer_id VARCHAR(10) REFERENCES farmers(farmer_id),
    crop_id VARCHAR(10) REFERENCES crops(crop_id),
    sale_date DATE NOT NULL,
    amount NUMERIC(12,2) NOT NULL
);

-- inserting data into farmer table
INSERT INTO farmers (farmer_id, name, region) VALUES ('f001', 'murekatete', 'rubavu');
INSERT INTO farmers (farmer_id, name, region) VALUES ('f002', 'nyiramakuba', 'musanze');
INSERT INTO farmers (farmer_id, name, region) VALUES ('f003', 'mvuyekure', 'karongi');
INSERT INTO farmers (farmer_id, name, region) VALUES ('f004', 'masunzu', 'musanze');
INSERT INTO farmers (farmer_id, name, region) VALUES ('f005', 'niyigena', 'rubavu');

--inserting data into crops table
INSERT INTO crops (crop_id, crop_name, category) VALUES ('001', 'tea', 'Cash Crops');
INSERT INTO crops (crop_id, crop_name, category) VALUES ('002', 'maize', 'Staple Food Crops');
INSERT INTO crops (crop_id, crop_name, category) VALUES ('003', 'potatoes', 'Staple Food Crops');
INSERT INTO crops (crop_id, crop_name, category) VALUES ('004', 'beans', 'Staple Food Crops');

--inserting data into sales table
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

--start implementing window function

--rank famers by totay revenue using row_numbers() from high to lower
SELECT
    farmer_id,
    SUM(amount) AS total_revenue,
    ROW_NUMBER() OVER (ORDER BY SUM (amount) DESC) AS row_num
FROM sales
GROUP BY farmer_id;

-- Rank farmers by total revenue using RANK
SELECT
    farmer_id,
    SUM(amount) AS total_revenue,
    RANK() OVER (ORDER BY SUM (amount) DESC) AS rank_pos
FROM sales
GROUP BY farmer_id;

-- Rank farmers by total revenue in DENSE_RANK
SELECT
    farmer_id,
    SUM(amount) AS total_revenue,
    DENSE_RANK() OVER (ORDER BY SUM (amount) DESC) AS dense_rank_pos
FROM sales
GROUP BY farmer_id;

 -- Rank farmers by total revenue in PERCENT_RANK
SELECT
    farmer_id,
    SUM (amount) AS total_revenue,
    PERCENT_RANK() OVER (ORDER BY SUM (amount) DESC) AS percent_rank
FROM sales
GROUP BY farmer_id;

-- Running total of sales ordered by date
SELECT
    sale_id,
    farmer_id,
    sale_date,
    amount,
    SUM(amount) OVER (
        ORDER BY sale_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM sales
ORDER BY sale_date;

-- calculating the minimum and maximum sales
SELECT
    MIN(amount) AS minimumSale,
    MAX(amount) AS maximumSale
FROM sales;

-- calculating moving average 
SELECT
    sale_date,
    amount,
    AVG(amount) OVER (
        ORDER BY sale_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_average_3_month
FROM sales
ORDER BY sale_date;

-- Compare each sale with the previous sale by periods
SELECT
    sale_id,
    farmer_id,
    sale_date,
    amount,
    LAG(amount, 1) OVER (ORDER BY sale_date) AS previous_sale,
    amount - LAG(amount, 1) OVER (ORDER BY sale_date) AS difference
FROM sales
ORDER BY sale_date;

-- Compare each sale with the next sale by period
SELECT
    sale_id,
    farmer_id,
    sale_date,
    amount,
    LEAD(amount, 1) OVER (ORDER BY sale_date) AS next_sale,
    LEAD(amount, 1) OVER (ORDER BY sale_date) - amount AS difference
FROM sales
ORDER BY sale_date;

-- Segment farmers into 4 groups (quartile) by amount
SELECT
    farmer_id,
    SUM(amount) AS total_revenue,
    NTILE(4) OVER (ORDER BY SUM(amount) DESC) AS quartile
FROM sales
GROUP BY farmer_id
ORDER BY total_revenue DESC;

-- Cumulative distribution of farmers by revenue
SELECT
    farmer_id,
    SUM(amount) AS total_revenue,
    CUME_DIST() OVER (ORDER BY SUM(amount) DESC) AS cum_dist
FROM sales
GROUP BY farmer_id
ORDER BY total_revenue DESC;
