# plsql-window-functions-ntwari-cedric
# step 1:  Problem Definition 
  # Business Context 
    A retail company operates across multiple regions in Rwanda, selling products such as 
    coffee, rice, maize, and beans. The management team needs to understand sales performance 
    across regions and quarters in order to identify best-selling products, forecast demand, and 
    improve customer targeting. 
  # Data Challenge 
    The company struggles to track which products perform best in each region and season, 
    measure customer performance, and analyse sales growth trends. Without these insights, it 
    becomes difficult to make informed business decisions. 
  # Expected Outcome 
    By applying SQL window functions, the company expects to: 
    • Rank top products per region and quarter. 
    • Calculate running sales totals to track revenue growth. 
    • Measure month-to-month changes in sales. 
    • Segment customers into performance tiers. 
    • Compute moving averages to predict seasonal demand.

# Step2: Success Criteria 
  To evaluate the success of this project, the following five measurable goals must be achieved 
  using SQL window functions on the farmers, crops, and sales tables: 
  1. Top Crops per Region and Quarter: Use ranking functions (RANK, ROW_NUMBER, 
  DENSE_RANK, PERCENT_RANK) to identify the best-performing crops across different 
  regions and seasonal quarters. 
  2. Cumulative Revenue Growth: Apply aggregate window functions (SUM with OVER) 
  to calculate running totals of sales over time, showing how overall revenue grows. 
  3. Month-to-Month Sales Changes: Use navigation functions (LAG, LEAD) to compare 
  monthly crop sales and highlight increases or decreases in demand. 
  4. Farmer Performance Tiers: Segment farmers into quartiles with distribution 
  functions (NTILE, CUME_DIST) to classify them into top, middle, and lower
  performing groups. 
  5. Seasonal Moving Averages: Use aggregate window functions (AVG with a sliding 
  frame) to compute moving averages of crop sales, helping to forecast seasonal 
  demand trends. 


# Step 3:  Database Schema 
  • farmers: stores farmer information, including a unique farmer ID, name, and region. 
  • crops: stores crop/product information, including a unique crop ID, crop name, and 
  category. 
  • sales: records sales transactions, linking farmers and crops through foreign keys, and 
  storing sale details such as date and amount. 
 
# Relationships 
  • Farmer–Sales Relationship: A single farmer can make multiple sales, but each sale 
  is associated with only one farmer. 
  (farmers 1 → many sales) 
  • Crop–Sales Relationship: A single crop can appear in multiple sales, but each sale 
  involves only one crop. 
  (crops 1 → many sales) 
# Format of table am goner use

### Farmers Table
| Column     | Type         | Description                     |
|------------|-------------|---------------------------------|
| farmer_id  | VARCHAR(20) | Unique identifier for each farmer |
| name       | VARCHAR(100)| Farmer name                      |
| region     | VARCHAR(50) | Region of farmer                 |

### Crops Table
| Column     | Type         | Description                                   |
|------------|-------------|-----------------------------------------------|
| crop_id    | VARCHAR(10) | Unique identifier for each crop                |
| crop_name  | VARCHAR(100)| Name of the crop                              |
| category   | VARCHAR(50) | Category (staple food crops, cash crop, etc.) |

### Sales Table
| Column     | Type         | Description                                   |
|------------|-------------|-----------------------------------------------|
| sale_id    | VARCHAR(10) | Unique transaction ID                         |
| farmer_id  | VARCHAR(10) | References farmers(farmer_id)                 |
| crop_id    | VARCHAR(10) | References crops(crop_id)                     |
| sale_date  | DATE        | Date of sale                                  |
| amount     | NUMERIC(12,2)| Sales value                                  |

##  Database Schema

This project uses those three related tables: **farmers**, **crops**, and **sales**.

after this the next step is create the table and inserting all the the data i next
( all my work i use postgre database)
my ER diagram  ![image alt] (https://raw.githubusercontent.com/ntwari-cedric/plsql-window-functions-ntwari-cedric/e5b1b1142f3b7fd106bbf82aba32f2882b490ca3/ER%20diagram.png).

## table creation
 ### --creation of farmer table
CREATE TABLE farmers (
    farmer_id VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region VARCHAR(50)
);

### --creation of crops table
CREATE TABLE crops (
    crop_id VARCHAR(10) PRIMARY KEY,
    crop_name VARCHAR(100) NOT NULL,
    category VARCHAR(50)
);

### -- creation of sales table
CREATE TABLE sales (
    sale_id VARCHAR(10) PRIMARY KEY,
    farmer_id VARCHAR(10) REFERENCES farmers(farmer_id),
    crop_id VARCHAR(10) REFERENCES crops(crop_id),
    sale_date DATE NOT NULL,
    amount NUMERIC(12,2) NOT NULL
);

after creating table the next step is to inserting the data in it 


## -- inserting data into farmer table
INSERT INTO farmers (farmer_id, name, region) VALUES ('f001', 'murekatete', 'rubavu');
INSERT INTO farmers (farmer_id, name, region) VALUES ('f002', 'nyiramakuba', 'musanze');
INSERT INTO farmers (farmer_id, name, region) VALUES ('f003', 'mvuyekure', 'karongi');
INSERT INTO farmers (farmer_id, name, region) VALUES ('f004', 'masunzu', 'musanze');
INSERT INTO farmers (farmer_id, name, region) VALUES ('f005', 'niyigena', 'rubavu');

## --inserting data into crops table
INSERT INTO crops (crop_id, crop_name, category) VALUES ('001', 'tea', 'Cash Crops');
INSERT INTO crops (crop_id, crop_name, category) VALUES ('002', 'maize', 'Staple Food Crops');
INSERT INTO crops (crop_id, crop_name, category) VALUES ('003', 'potatoes', 'Staple Food Crops');
INSERT INTO crops (crop_id, crop_name, category) VALUES ('004', 'beans', 'Staple Food Crops');

## --inserting data into sales table
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

# i done creating my table and inserting data in it the next step is to apply the window function

# Step 4: Window Functions Implementation 

They are called window functions because they operate over a "window" or a specific set of rows in 
a result set, rather than the entire dataset. 
  ## 4.1 ranking 
ranking is a way to assign a numerical position to each row within a result set based on a 
specified ordering. 
  ## ROW_NUMBER () 
This function assigns a unique sequential number to each row within a partition, 
starting from 1. It is useful when we need to uniquely identify rows even if some 
values are identical. For example, listing farmers in the order of their sales. 
### --rank famers by totay revenue using row_numbers() from high to lower
SELECT
    farmer_id,
    SUM(amount) AS total_revenue,
    ROW_NUMBER() OVER (ORDER BY SUM (amount) DESC) AS row_num
FROM sales
GROUP BY farmer_id;

## Interpretation
This function assigns a unique, sequential number to each row based 
on the total revenue in descending order. The farmer with the highest revenue, f003, 
is ranked first with a value of 1, and the ranking increases for each subsequent 
farmer 
  ## RANK() 
Similar to ROW_NUMBER, but when there are ties (equal values), it assigns the same 
rank and skips the next number. This is useful when ranking crops by revenue where 
multiple crops may have the same sales value. 

## -- Rank farmers by total revenue using RANK
SELECT
    farmer_id,
    SUM(amount) AS total_revenue,
    RANK() OVER (ORDER BY SUM (amount) DESC) AS rank_pos
FROM sales
GROUP BY farmer_id;

## Interpretation: 
This function assigns a rank to each farmer based on their total revenue, with 
no gaps in the ranking if there are ties. In the current dataset, all total revenue values are 
unique, so the RANK() results are the same as ROW_NUMBER(). 

## DENSE_RANK () 
Like RANK, but it does not skip numbers when ties occur. Instead, it assigns the same rank 
for equal values, and the next rank continues without gaps. This is better for compact 
ranking lists. 
## -- Rank farmers by total revenue in DENSE_RANK
SELECT
    farmer_id,
    SUM(amount) AS total_revenue,
    DENSE_RANK() OVER (ORDER BY SUM (amount) DESC) AS dense_rank_pos
FROM sales
GROUP BY farmer_id;

## Interpretation:
This function assigns a rank to each row within a partition, but 
without any gaps in the ranking sequence. Similar to the RANK() function in this 
dataset, there are no ties in the revenue amounts, so the result is a sequential 
ranking from 1 to 5 
## PERCENT_RANK () 
Returns the relative rank of a row as a percentage between 0 and 1. It is helpful to compare 
how far a row is from the lowest or highest ranked row. 

## -- Rank farmers by total revenue in PERCENT_RANK
SELECT
    farmer_id,
    SUM (amount) AS total_revenue,
    PERCENT_RANK() OVER (ORDER BY SUM (amount) DESC) AS percent_rank
FROM sales
GROUP BY farmer_id;

## Interpretation: 
This function calculates the relative rank of each farmer within the group as 
a percentage, ranging from 0 to 1. A percent rank of 0 indicates the top performer (f003) and 
a value of 1 indicates the lowest performer (f005). 

## 4.2. Aggregate 
aggregation is the process of computing a single value from a set of values. 

## Total sales(sum) 
Calculates running or cumulative totals over a partition. This allows us to track total revenue 
over time or per region without collapsing rows like a normal SUM would.

## -- Running total of sales ordered by date
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

## Interpretation: 
This query calculates the cumulative sum of sales over time, showing the 
running total as each new sale occurs. The results demonstrate how the total revenue grows 
progressively with each transaction date. 

## Min () &max () 
These functions find the smallest and largest values within a partition, such as identifying the 
lowest and highest sales made in each month. 

## -- calculating the minimum and maximum sales
SELECT
    MIN(amount) AS minimumSale,
    MAX(amount) AS maximumSale
FROM sales;

## Interpretation:
These functions find the minimum and maximum values from the entire 
sales table. The output provides a single row showing the lowest and highest revenue
generating transactions, giving you a quick overview of the financial range of your sales 
data. 

## Moving Averages 
I implement average but it is not enough am also going to implement the  Moving Averages 
which is the one considered as window function  

## -- calculating moving average 
SELECT
    sale_date,
    amount,
    AVG(amount) OVER (
        ORDER BY sale_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_average_3_month
FROM sales
ORDER BY sale_date;

## Interpretation: 
This query employs the AVG() function as a window function with a defined frame to calculate a 
moving average. The clause OVER (ORDER BY sale_date ROWS BETWEEN 2 PRECEDING AND 
CURRENT ROW) specifies a sliding window that computes the average sales amount for each row by 
including the current row and the two preceding rows, ordered by sale_date. This approach 
produces a smoothed representation of sales trends, facilitating the analysis of temporal patterns 
and supporting more accurate forecasting of seasonal demand.

## 4.3 Navigation 
navigation refers to the process of traversing a database's structure to locate and retrieve 
specific data 
  ## LAG () 
Returns the value from the previous row in the partition. This is useful to compare current 
month sales with the previous month’s sales.

 ## -- Compare each sale with the previous sale by periods
SELECT
    sale_id,
    farmer_id,
    sale_date,
    amount,
    LAG(amount, 1) OVER (ORDER BY sale_date) AS previous_sale,
    amount - LAG(amount, 1) OVER (ORDER BY sale_date) AS difference
FROM sales
ORDER BY sale_date;

## Interpretation: 
This function compares the current sale amount with the sale amount from 
the previous transaction, ordered by date. The 'difference' column highlights the increase or 
decrease in revenue between consecutive sales, helping to identify month-to-month 
changes in crop sales. 
  ## LEAD () 
Returns the value from the next row in the partition. This is used to compare current values 
with future values, for example predicting the next sales trend. 

## -- Compare each sale with the next sale by period
SELECT
    sale_id,
    farmer_id,
    sale_date,
    amount,
    LEAD(amount, 1) OVER (ORDER BY sale_date) AS next_sale,
    LEAD(amount, 1) OVER (ORDER BY sale_date) - amount AS difference
FROM sales
ORDER BY sale_date;

## Interpretation: 
This function compares the current sale amount with the sale amount of the 
next transaction, ordered by date. The 'difference' column shows the future change in 
revenue, which is useful for forward-looking analysis and trend prediction. 
  ## 4.4 Distribution 
distribution refers to the practice of storing and managing data across multiple 
interconnected computers or nodes, rather than in a single, centralized location 
## NTILE (4) 
Divides the ordered result set into n equal parts (tiles) and assigns a group number to each 
row. For example, dividing farmers into 4 performance groups (quartiles). 

   ## -- Segment farmers into 4 groups (quartile) by amount
SELECT
    farmer_id,
    SUM(amount) AS total_revenue,
    NTILE(4) OVER (ORDER BY SUM(amount) DESC) AS quartile
FROM sales
GROUP BY farmer_id
ORDER BY total_revenue DESC;

 ## Interpretation: 
 This function divides the farmers into four performance tiers or quartiles 
based on their total revenue. The output classifies the top two farmers (f003 and f004) into 
quartile 1, the next one (f002) into quartile 2, and so on, which helps in segmenting them 
into top, middle, and lower performing groups. 

## CUME_DIST () 
Calculates the cumulative distribution of a value within a partition. It shows the proportion 
of rows less than or equal to the current row. This is useful for percentile-based analysis, 

  ## -- Cumulative distribution of farmers by revenue
SELECT
    farmer_id,
    SUM(amount) AS total_revenue,
    CUME_DIST() OVER (ORDER BY SUM(amount) DESC) AS cum_dist
FROM sales
GROUP BY farmer_id
ORDER BY total_revenue DESC;

  ## interpretation: 
This function calculates the cumulative distribution of each farmer's total 
revenue, returning a value between 0 and 1. This value represents the percentage of 
farmers with a total revenue less than or equal to the current farmer's revenue. For 
example, the value of 0.6 for f002 means that 60% of the farmers have a revenue less than 
or equal to theirs. 

## step 6: Results Analysis and Interpretation
The analysis is based on the data provided (5 farmers, 4 crops, 10 sales) and the output
of what i  implemented PostgreSQL Window Functions.

## 1. Descriptive Layer: What Happened?

### farmers: 
farmer foo3 is top perfomer becouses he contribute more total revenue than athers around 2100000
in only to sales of tea crops(001.The ranking functions is the one show as farmer f003 is ranked 
  1st by revenue, followed closely by f004

###  Revenue Distribution (Quartiles): 
  The NTILE(4) function shows that the top quartile (Quartile 1) is dominated by 
  two highest-revenue farmers (f003 and f004)

### Sales Trends (Running Total):
running total show high speed of revenue growth in febuary coused by high sales of 
f003 around 1,100,000 in single sale (tea) 

## crops focus:
the tea crops generate more sales in single sales amount while potatoes and beans has more 
frequence but sale lower

## Month-to-Month Fluctuation: 
The LAG() and LEAD() analyses show significant revenue swings. For example, sales jumped 280,000.00 
from s100 to s101, but dropped 200,000.00 by s109. These sharp fluctuations suggest unstable demand
patterns that require further investigation into seasonal factors or customer purchasing behavior

## 2. Diagnostic Layer: Why?

  ### Farmer Performance Skew: 
Farmer f003's dominance is directly tied to the two high-value sales of 'tea' .
This suggests that the value of the crop category (Cash Crops vs. Staple Food Crops) is the primary driver
of top-tier performance, rather than the volume of transactions.

### Regional Concentration:
The top two farmers, f003 Karongi and f004 from Musanze, operate in different regions. 
This suggests that while individual farmer performance is high, high revenue potential is 
not confined to a single region.

### Demand Smoothing: 
The 3-row moving average helps to smooth out the volatility seen in the LAG/LEAD comparison. 
For example, the moving average of sales between March 2 and March 16 (including s103, s104, s105)
would give a much clearer trend of stable sales activity during that period,
isolating the impact of the high-value 'tea' outlier.


### Low Performer Insight:
Farmer f005 (Niyigena), the lowest performer, contributed the minimum revenue and is classified 
in Quartile 4, indicating they are either a new farmer or require specific intervention.

## 3. Prescriptive Layer: What Next? 
High-Value Replication (Prescriptive Action):

### Recommendation:
Study the sales tactics and quality control practices of Farmer f003 and f004 
for the 'Tea' and 'Potatoes' crops.

### Business Action: 
Create a dedicated "Top Farmer Mentorship Program" (Quartile 1) to share their best
practices with farmers in Quartiles 2, 3, and 4 to boost overall crop revenue.

Demand Forecasting (Prescriptive Action):

### Recommendation: 
Utilize the Moving Average results to set inventory and production targets for the next three months.

### Business Action:
Since the moving average is a smoothed trend, use it as the baseline for the next quarter's demand forecast,
especially for staple crops like potatoes and beans, which show consistent sales.


Targeted Intervention (Prescriptive Action):

### Recommendation: 
Implement a targeted support program for farmers in the lowest tier (Quartile 4), specifically f005.


### Business Action: 
Investigate the reasons for low sales (e.g., poor yield, limited market access, crop choice) to move them 
into a higher quartile within the next reporting period.

## References

1. Maniraguha, E. (2025). Database Development with PL/SQL - Lecture 01: Introduction to SQL Command Basics (Recap). AUCA.
2. Maniraguha, E. (2025). Database Development with PL/SQL - Lecture 02: Introduction to GitHubs. AUCA.
3. PostgreSQL.org. (2024). Window Functions Documentation. https://www.postgresql.org/docs/current/tutorial-window.html
4. PostgreSQL.org. (2024). SQL Syntax Window Functions. https://www.postgresql.org/docs/current/sql-expressions.html#SYNTAX-WINDOW-FUNCTIONS
5. PostgreSQL Tutorial. (2023). Window Functions in PostgreSQL - Complete Guide. YouTube. https://www.youtube.com/watch?v=H2LCz-J8pRg
6. FreeCodeCamp. (2024). PostgreSQL Window Functions Tutorial. YouTube. https://www.youtube.com/watch?v=Ww71knvhQ-s  
7. TechTFQ. (2023). Advanced SQL Window Functions Explained. YouTube. https://www.youtube.com/watch?v=Ww71knvhQ-s
8. Amigoscode. (2024). PostgreSQL for Beginners - Window Functions. YouTube. https://www.youtube.com/watch?v=Ww71knvhQ-s
9. Oracle Corporation. (2024). PL/SQL Language Reference. Oracle Documentation.
10. W3Schools. (2024). SQL Window Functions. https://www.w3schools.com/sql/sql_window functions.asp








