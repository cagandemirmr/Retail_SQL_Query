--Checking Dataset


select * from retail_sales


--  Total number of records

select count(*) Number_of_Counts from retail_sales



-- Number of Custtomers
select count(distinct customer_id) Customer_Count from retail_sales

-- Category Count
select distinct category,count(distinct category) Category_count 
from retail_sales group by category

--Null value check


SELECT * FROM retail_sales
WHERE
sale_date is null or sale_time is null or customer_id is null
or gender is null or age is null or category is null
or quantiy is null or price_per_unit is null or cogs is null
or total_sale is null


SELECT distinct category,gender FROM retail_sales --When i check values i can see that age group can be filled with average or median
WHERE
age is null and quantiy is not null 

/* Beauty	Male
Clothing	Male
Electronics	Female
Electronics	Male  */


select min(age) min_Age, MAX(age) max_age,avg(age) avg_age , category,gender --Checking average age values by gender and category
from retail_sales group by category,gender

/* 18	64	40	Beauty	Female
   18	64	40	Beauty	Male
   18	64	40	Electronics	Female
   19	64	42	Electronics	Male
   18	64	40	Clothing	Male
   18	64	43	Clothing	Female */



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

----------------------------------------
--Average Results;
/* 18	64	40	Beauty	Male
   18	64	40	Electronics	Female
   19	64	42	Electronics	Male
   18	64	40	Clothing	Male */


--Median Results;
/* Beauty	Male 39
Clothing	Male 40
Electronics	Female 40
Electronics	Male  40 */


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


--It can be filled by more information but i dont have any thats why i prefer to delete null rows these columns.

delete from retail_sales
WHERE
sale_date is null or sale_time is null or customer_id is null
or gender is null or age is null or category is null
or quantiy is null or price_per_unit is null or cogs is null
or total_sale is null


--DATA EXPLORATION

select min(sale_date) min_saledate,max(sale_date) max_saledate,min(sale_time) sale_time,max(sale_time) max_saletime,
min(quantiy) min_quantity,max(quantiy) max_quantiy,min(cogs) min_cogs,max(cogs) max_cogs,avg(cogs) avg_cogs,min(total_sale) min_total,max(total_sale) max_total,avg(total_sale)
avg_total_sale from retail_sales --Observe numerical variables

----------------------------
select distinct category from retail_sales --Observe categorical values

select distinct gender from retail_sales  

--Write a SQL query to retrieve all columns for sales made on '2022-11-05'

select * from retail_sales where sale_date='2022-11-05'


--Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

select * from retail_sales where 
DATEPART(MONTH,sale_date)=11 and DATEPART(YEAR,sale_date)=2022 and quantiy=4 and category='Clothing'

--Write a SQL query to calculate the total sales (total_sale) for each category

select category,sum(total_sale) Revenue,
count(total_sale) Amount
from retail_sales group by  category

--Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select avg(age) AVG_AGE
from retail_sales where category='Beauty'


--Write a SQL query to find all transactions where the total_sale is greater than 1000.:

select *
from retail_sales where total_sale > 1000

--Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

select gender,category,count(transactions_id) count_transaction
from retail_sales group by gender,category order by category

--Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

WITH MonthlySales AS (
    SELECT 
        AVG(total_sale) AS AVG_sale, 
        DATEPART(MONTH, sale_date) AS month_, 
        DATEPART(YEAR, sale_date) AS year_
    FROM retail_sales
    GROUP BY DATEPART(YEAR, sale_date), DATEPART(MONTH, sale_date)
),
RankedSales AS (
    SELECT 
        AVG_sale, 
        month_, 
        year_,
        RANK() OVER (PARTITION BY year_ ORDER BY AVG_sale DESC) AS rank_
    FROM MonthlySales
)
SELECT 
    AVG_sale, 
    month_, 
    year_
FROM RankedSales
WHERE rank_ = 1;

--**Write a SQL query to find the top 5 customers based on the highest total sales **:

select top 5 customer_id,sum(total_sale) from retail_sales group by customer_id order by sum(total_sale) desc

--Write a SQL query to find the number of unique customers who purchased items from each category.:

select  category,COUNT(distinct customer_id) from retail_sales group by category

--Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)




select case when datepart(HOUR,sale_time) < 12 then 'Morning'
            when datepart(HOUR,sale_time) between 12 and 17 then 'Afternoon'
			when datepart(HOUR,sale_time) >17 then 'Evening'
			end
from retail_sales




Alter table retail_sales  --Created new column
add Shifts varchar(10);

Update retail_sales       --Update it
set Shifts= case when datepart(HOUR,sale_time) < 12 then 'Morning'
            when datepart(HOUR,sale_time) between 12 and 17 then 'Afternoon'
			when datepart(HOUR,sale_time) >17 then 'Evening'
			end;


select * from retail_sales

