CREATE DATABASE p1_retail_db;

drop table if exists retail_sales;
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

select * from retail_sales

--data preprocessing
SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

	DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

--data expploration--
select count(*) as total_sale from retail_sales

select count(distinct customer_id) as total_sale from retail_sales

select distinct category from retail_sales

--Bussiness analyis
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

select * from retail_sales
where
category = 'Clothing'
and
To_char(sale_date, 'YYYY-MM')='2022-11'
and
quantity >= 4

select 
category,sum(total_sale) as netsale,
count(*) as total_orders

select Round(avg(age) , 2) as avg_age from retail_sales
where category ='Beauty'

select * from retail_sales
where total_sale > 1000

select category,gender, count (*) as total_trans from retail_sales
group by category,gender order by 1

SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1

select customer_id,sum(total_sale) as total_sales
from retail_sales
group by 1
ORDER BY 2 desc
limit 5

SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category

with hourly_sale
as
(
select
	case
	when extract(hour from sale_time)< 12 then 'Morning'
	when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
	else 'Evening'
	end as shift
from retail_sales
)
select
	shift,
	count(*) as total_orders
from hourly_sale
group by shift