# Retail Sales Data Analysis

This project involves analyzing the retail sales dataset using SQL queries for data exploration, data cleaning, and deriving insights.


### 1. Dataset Overview

- Fetches all the records to get a general look at the dataset.
- Counts the total number of records in the dataset.

  
```sql

select * from retail_sales

```

### 2. Customer and Category Insights

| **Metric**               | **Description**                               |
|--------------------------|-----------------------------------------------|
| Number of Customers       | Counts the number of unique customers.        |
| Number of Categories      | Displays distinct categories and their count. |

```sql

--  Total number of records

select count(*) Number_of_Counts from retail_sales



-- Number of Customers
select count(distinct customer_id) Customer_Count from retail_sales

-- Category Count
select distinct category,count(distinct category) Category_count 
from retail_sales group by category

```


### 3. Null Value Checks

Checks for any missing values in the dataset in fields like:
- `sale_date`
- `sale_time`
- `customer_id`
- `gender`
- `age`
- `category`
- `quantity`
- `price_per_unit`
- `cogs`
- `total_sale`

```sql

SELECT * FROM retail_sales
WHERE
sale_date is null or sale_time is null or customer_id is null
or gender is null or age is null or category is null
or quantiy is null or price_per_unit is null or cogs is null
or total_sale is null

```

### 4. Handling Missing Age Data

- Analyzes missing `age` values grouped by `category` and `gender`.
- Computes the average and median age values to fill missing age entries.

| **Category**     | **Gender**   | **Min Age** | **Max Age** | **Avg Age** | **Median** |
|------------------|--------------|-------------|-------------|-------------|-------------|
| Beauty           | Female       | 18          | 64          | 40          | 39          |
| Electronics      | Female       | 18          | 64          | 40          | 40          |
| Clothing         | Male         | 18          | 64          | 40          | 40          |
| Electronics      | Male         | 19          | 64          | 42          | 40          |

```sql

SELECT distinct category,gender FROM retail_sales --When i check values i can see that age group can be filled with average or median
WHERE
age is null and quantiy is not null

```

Missing categories and gender of rows are;

| **Category**   | **Gender** |
|----------------|------------|
| Beauty         | Male       |
| Clothing       | Male       |
| Electronics    | Female     |
| Electronics    | Male       |


### 5. Filling Missing Age Values

- Updates the missing age values using calculated median values for each category and gender. Because median metric is less sensitive then average.

```sql
--Checking average age values by gender and category
select min(age) min_Age, MAX(age) max_age,avg(age) avg_age , category,gender 
from retail_sales group by category,gender

 --Calculate Median Values

select count(age) count_age,count(age)/2 middle_value from retail_sales where category='Beauty' and gender='male'
--281	140


WITH CTE AS
(
    SELECT 
        age,
        ROW_NUMBER() OVER (ORDER BY age) AS RowAsc
        
    FROM retail_sales where category='Beauty' and gender='Male'
)
SELECT age AS Median
FROM CTE
WHERE RowAsc = 140
--39

----------------------------------------

select count(age) count_age,count(age)/2+1 middle_value from retail_sales where category='Clothing' and gender='male'--Repeat same process for other columns.
--351	176

WITH CTE AS
(
    SELECT 
        age,
        ROW_NUMBER() OVER (ORDER BY age) AS RowAsc
        
    FROM retail_sales where category='Clothing' and gender='Male'
)
SELECT age AS Median
FROM CTE
WHERE RowAsc = 176
--40

----------------------------------------

select count(age) count_age,count(age)/2+1 middle_value from retail_sales where category='Electronics' and gender='Female'
--335	168

WITH CTE AS
(
    SELECT 
        age,
        ROW_NUMBER() OVER (ORDER BY age) AS RowAsc
        
    FROM retail_sales where category='Electronics' and gender='Female'
)
SELECT age AS Median
FROM CTE
WHERE RowAsc = 168
--40


----------------------------------------

select count(age) count_age,count(age)/2+1 middle_value from retail_sales where category='Electronics' and gender='Male'
--172


WITH CTE AS
(
    SELECT 
        age,
        ROW_NUMBER() OVER (ORDER BY age) AS RowAsc
        
    FROM retail_sales where category='Electronics' and gender='Female'
)
SELECT age AS Median
FROM CTE
WHERE RowAsc = 172
--40

SELECT * FROM retail_sales
WHERE
age is null and quantiy is not null and category='Beauty' and gender='Male'

Update retail_sales   --Filling missing values with median values.
set age=39 
WHERE
age is null and quantiy is not null and category='Beauty' and gender='Male'

--------------
SELECT * FROM retail_sales
WHERE
age is null and quantiy is not null and category='Electronics' and gender='Female'

Update retail_sales
set age=40
WHERE
age is null and quantiy is not null and category='Electronics' and gender='Female'

--------------

SELECT * FROM retail_sales
WHERE
age is null and quantiy is not null and category='Clothing' and gender='Male'


Update retail_sales
set age=40
WHERE
age is null and quantiy is not null and category='Clothing' and gender='Male'

--------------
SELECT * FROM retail_sales
WHERE
age is null and quantiy is not null and category='Electronics' and gender='Male'

Update retail_sales
set age=40
WHERE
age is null and quantiy is not null and category='Electronics' and gender='Male'


```

### 6. Deleting Rows with Null Values

- Deletes records where crucial fields like `sale_date`, `customer_id`, or `total_sale` are missing.

```sql

delete from retail_sales
WHERE
sale_date is null or sale_time is null or customer_id is null
or gender is null or age is null or category is null
or quantiy is null or price_per_unit is null or cogs is null
or total_sale is null

```

### 7. Data Exploration

- Observes numerical variables such as:
  - Sale date range
  - Quantity sold
  - Cost of goods sold (`COGS`)
  - Total sales

- Explores categorical values like:
  - Distinct categories in the dataset.
  - Distinct genders associated with purchases.

| **Variable**      | **Description**                                       |
|-------------------|-------------------------------------------------------|
| Sale Date Range   | Observes the earliest and latest sale dates.           |
| Quantity Range    | Checks the minimum and maximum quantities sold.        |
| Total Sales Range | Looks at the range of total sales values.              |

### 8. Specific Queries

- Retrieves all transactions for sales made on a specific date.
- Finds sales where the quantity is above 4 in a specific category (Clothing) and month (November 2022).
- Calculates total sales per category.

### 9. Customer Insights

- Finds the average age of customers who purchased from the Beauty category.
- Retrieves transactions where the total sale amount is greater than 1000.
- Analyzes the number of transactions made by gender and category.

### 10. Monthly Sales Trends

- Calculates the average sale for each month and identifies the best-selling month in each year.

### 11. Top Customers

- Finds the top 5 customers based on the highest total sales.

### 12. Shift-based Sales Analysis

| **Shift**     | **Time Period**                 |
|---------------|---------------------------------|
| Morning       | Before 12 PM                    |
| Afternoon     | Between 12 PM and 5 PM          |
| Evening       | After 5 PM                      |

- Categorizes transactions into different shifts and counts the number of sales during each shift.
