-- SQL Retail Sales Analysis Project- p1
DROP TABLE IF EXISTS retail_sales;

create table if not exists retail_sales(
	transactions_id	int primary key,
	sale_date date,
	sale_time time,
	customer_id	int,
	gender varchar(15),
	age	int,
	category varchar(15),	
	quantity	int,
	price_per_unit float,	
	cogs float,
	total_sale float
);

SELECT * FROM retail_sales;

select count(*) from retail_sales;

-- Data Cleaning
select * from retail_sales
where 
	transactions_id is null or
	sale_date is null or
	sale_time is null or
	customer_id is null or
	gender is null or
	age is null or
	category is null or
	quantity is null or 
	price_per_unit is null or 
	cogs is null or 
	total_sale is null;

delete from retail_sales 
where
	transactions_id is null or
	sale_date is null or
	sale_time is null or
	customer_id is null or
	gender is null or
	category is null or
	quantity is null or 
	price_per_unit is null or 
	cogs is null or 
	total_sale is null;

-- Data Exploration
-- How many sales we have?
select count(*) as total_sales from retail_sales;

--How many unique customers we have?
select count(distinct customer_id) from retail_sales;

-- How many unique categories we have?
select distinct category from retail_sales;

-- Data Analysis and Business k=Key Problems and Answers
-- Q1 Write the sql query to retrieve all columns for sales made on date=2022-11-05
select * from 
retail_sales 
where sale_date='2022-11-05';

-- Q2 Write the sql query to retrieve all transactions where category is Clothing and the quantity solde is more than 3
-- in november-2022
select * 
from retail_sales
where category='Clothing' and 
quantity>=4 and 
to_char(sale_date,'YYYY-MM')='2022-11';

-- Q3  Write the sql query to calculate total_sales for each category
select category, sum(total_sale) as net_sale, count(*) as total_orders
from retail_sales 
group by category;

-- Q4  Write the sql query to calculate average age of customers who
-- purchased the items from the 'Beauty' Category
select round(avg(age),2) as avg_age
from retail_sales
where category='Beauty';

-- Q5 Write the sql query to retrieve all transactions from table 
-- where the total_sale > 1000
select * 
from retail_sales 
where total_sale>1000;

-- Q6 Write the sql query to retrieve total number of transactions made by 
-- each gender in each category
select category, gender, count(transactions_id)
from retail_sales
group by category , gender
order by 1;

-- Q7 Write a sql query to calculate the average sale for each month . Find out the best selling month of each year.
--year(sale_date) from MySql
select year, month, avg_sale from(
	select 
		extract(year from sale_date) as year,
		extract(month from sale_date) as month, 
		avg(total_sale) as avg_sale,
		rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc)
	from retail_sales
	group by 1,2
) as t1
where rank=1

-- Q8 Write a sql query to find the top 5 customers based on the highest_total sales;
select customer_id, sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5;

-- Q9 Write a sql query to find the number of unique customers who purchased items from each category
select category, count(distinct customer_id) as unique_customers
from retail_sales
group by category;

-- Q10 Write a sql query to create each shift and number of orders (example morning <=12, afternoon between 12 and 17 and evening >17)

with hourly_shift as (
	select *, 
		case 
			when extract(hour from sale_time)<'12' then 'Morning'
			when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
			else 'Evening'
		end as Shift
	from retail_sales
)
select shift, count(*) as total_orders
from hourly_shift 
group by shift;

-- End of project