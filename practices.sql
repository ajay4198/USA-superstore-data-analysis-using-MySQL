use practice;
select*from store;

-- count the row number  
select count(*) as row_count from store; 

-- count the columns number-- 
select count(*) as columns_count 
from  information_schema.columns
where table_name ='store';
-- Give a inforamtion about our database find the table in your data base using this quarie-- 

select * from 
information_schema.tables
where table_name = "store";

-- check the dataset inforamtion 
select * from information_schema.columns
where table_name = 'store';

-- get the columns name only in the data set ?-- 

select column_name
from information_schema.columns
where table_name ='store';

-- check the data type of all the columns 
select column_name,data_type
from information_schema.columns
where table_name = 'store';

-- find null values

-- this query is not working-- 
-- SELECT * FROM store
-- WHERE (select column_name
-- from INFORMATION_SCHEMA.COLUMNS
-- where TABLE_NAME='store')= NULL;

-- dropping the unnecessary column like Row_id-- 
ALTER TABLE store DROP COLUMN Row_ID;
select*from store limit 10;

-- count the united state are there in dataset in column country 
select count(*) as US_country from store
where Country = 'United States';

-- Prodect Level analysis 
-- What are the unique product categories?
select distinct (Category) from store;

-- What is the number of products in each category? 
select Category,count(*) as no_of_each_product 
from store 
group by Category 
order by count(*) desc;

-- Single Category number
select count(*) as Office_supplies 
from store 
where Category='Office Supplies';

-- Find the number of Subcategories products that are divided.
select distinct(Sub_Category) from store;

-- count the number of each sub category product
select Sub_Category,count(*) As sub_category
from store
group by Sub_Category
order by count(*) desc;

-- find the top 10 product in sub category and category

-- Sub category
select Sub_Category,count(*) as top_10_product
from store
group by sub_Category
order by count(*) desc
limit 10;

-- Category top 10 prodcut
select Category,Count(*) as top_10_product
from store 
group by Category 
order by count(*) desc;

-- calculate the cost of each order id with sub category
select sub_category,Order_ID,round((sales-profit),2) as cost
from store;
select sub_category,round((sales-profit),2) as cost
from store;

-- which category has highest profit
select Order_ID,category,round((sales-profit),2) as profit_category
from store
group by category 
order by count(*) desc;

-- Calculate % profit for each Order_ID with respective Product Name.
select order_id,sub_category,round((profit/(sales-profit))*100,2) as percentage
from store
group by order_id,sub_category;

-- Calculate the overall profit of the store.
select round(sum(profit)/(sum(sales))-(sum(profit)),2) as all_over_percentage
from store;

-- Calculate percentage profit and group by them with Product Name and Order_Id.
-- with store_new as(
--  select a.*,b.all_over_percentage
-- from store as a 
-- left join
--  (select((profit/((sales-profit))*100)) as percentage_profit,order_id,sub_category  from 
--  group by  percentage_profit,order_id,sub_category) as b
--  on a.order_id=b.order_id)
--  select*from --

--  second method same
 select sub_category,order_id, ((profit/((sales-profit))*100)) as precentage_profit
 from store
 group by order_id,sub_category,precentage_profit;
 
--  Where can we trim some loses? 
--    In Which products?
--    We can do this by calculating the average sales and profits, and comparing the values to that average.
--    If the sales or profits are below average, then they are not best sellers and 
--    can be analyzed deeper to see if its worth selling thema anymore.

select round(avg(sales),2) as avrage_sales
from store;
-- the avrage sales on product is 229.85 approx 230 --

select round(avg(profit),2) as avrage_profit 
from store;
-- the avrage profit of product is 28.65 approx 29.

-- avrage sub category sales 
select round(avg(sales),2) as avg_sales,sub_category 
from store
group by sub_category
order by avg_sales desc 
limit 9;
-- The sales of these Sub_category products are below the average sales.

-- avg profit per sub category
select round(avg(profit),2) as profit_per_sub_cat,sub_category
from store
group by sub_category 
order by profit_per_sub_cat
limit 10;
-- The profit of these Sub_category products are below the average profit.
-- -- "Minus sign" Respresnts that those products are in losses.

-- CUSTOMER LEVEL ANALYSIS

-- What is the number of unique customer IDs?
select  count(distinct(customer_id)) as unique_id
from store;

-- Find those customers who registered during 2014-2016.
select distinct(customer_name),customer_id,order_id,city,postal_code
from store
where customer_id is not null;

-- Calculate Total Frequency of each order id by each customer Name in descending order
select order_id,customer_name,count(order_id) as total_order_id
from store
group by order_id,customer_name
order by  total_order_id desc;

-- Calculate  cost of each customer name.
select order_id,customer_name,customer_id,city,Quantity,sales,(sales-profit)as cost,profit
from store
group by order_id,customer_name,customer_id,city,Quantity,sales;

-- Display No of Customers in each region in descending order.
select customer_name,region, count(*) as no_of_customers
from store
group by customer_name,region
order by no_of_customers desc;

-- Find Top 10 customers who order frequently.
select customer_name,count(*) as top_10_customers
from store
group by customer_name
order by top_10_customers desc
limit 10;

-- Display the records for customers who live in state California and Have postal code 90032.
select customer_name,states from store
where states='california' and postal_code=90032
group by customer_name,states;

-- Find Top 20 Customers who benefitted the store.
select customer_name,profit,city,states
from store
group by customer_name,profit,city,states
order by profit desc
limit 20;

-- Which state(s) is the superstore most succesful in? Least?
select round(sum(sales),2) as states_superstore,states
from store
group by states
order by states_superstore desc
limit 10;

-- ORDER LEVEL ANALYSIS

-- number of unique orders
select count(distinct(order_id))as unique_order_id
from store;

-- Find Sum Total Sales of Superstore

select round(sum(sales),2)as total_sales
from store;

-- Calculate the time taken for an order to ship and converting the no. of days in int format.
select customer_id,order_id,customer_name,city,states,(ship_date-order_date) as delivery_duration 
from store
group by delivery_duration 
order by delivery_duration desc
limit 10;

-- Extract the year  for respective order ID and Customer ID with quantity
select order_id,customer_id,quantity,extract(year from order_date)as years_order
from store
group by order_id,customer_id,quantity
order by years_order desc

-- What is the Sales impact? 
-- select extract(year from order_date),sales,round(profit/((sales-profit)*100)),2) as sales_impact
-- from store
-- group by sales, sales_impact
-- order by sales_impact desc

-- Breakdown by Top vs Worst Sellers
-- Find Top 10 Categories with the addition of best sub-category within the category
select Category,sub_category,round(SUM(sales),2)as prod_sales
FROM store
GROUP BY Category,Sub_Category;
-- ORDER BY prod_sales DESC;

-- not done
-- --Find Top 10 Sub-Categories. :
SELECT round(SUM(sales),2) AS prod_sales,Sub_Category
FROM store
GROUP BY Sub_Category
ORDER BY prod_sales DESC


-- Find Worst 10 Categories.
SELECT round(SUM(sales),2) AS prod_sales,Category,Sub_Category
FROM store
GROUP BY Category,Sub_Category
ORDER BY prod_sales;

-- Find Worst 10 Sub-Categories. :
SELECT round(SUM(sales),2) AS prod_sales, sub_Category
FROM store
GROUP BY Sub_Category
ORDER BY prod_sales


/* Show the Basic Order information. */
select count(Order_ID)as Purchases,
round(sum(Sales),2) as Total_Sales,
round(sum(((profit/((sales-profit))*100)))/ count(*),2) as avg_percentage_profit,
min(Order_date) as first_purchase_date,
max(Order_date) as Latest_purchase_date,
count(distinct(Product_Name)) as Products_Purchased,
count(distinct(City)) as Location_count
from store

/* RETURN LEVEL ANALYSIS */
/* Find the number of returned orders. */
select Returned_items, count(Returned_items)as Returned_Items_Count
from store
group by Returned_items
Having Returned_items='Returned'

-- --Find Top 10 Returned Categories.:
SELECT Returned_items, Count(Returned_items) as no_of_returned ,Category, Sub_Category
FROM store
GROUP BY Returned_items,Category,Sub_Category
Having Returned_items='Returned'
ORDER BY count(Returned_items) DESC
limit 10;

-- Find Top 10  Returned Sub-Categories.:
SELECT Returned_items, Count(Returned_items),Sub_Category
FROM store
GROUP BY Returned_items, Sub_Category
Having Returned_items='Returned'
ORDER BY Count(Returned_items) DESC


-- --Find Top 10 Customers Returned Frequently.:
SELECT Returned_items, Count(Returned_items) As Returned_Items_Count, Customer_Name, Customer_ID,Customer_duration, States,City
FROM store
GROUP BY Returned_items,Customer_Name, Customer_ID,customer_duration,states,city
Having Returned_items='Returned'
ORDER BY Count(Returned_items) DESC
limit 10;

-- Find Top 20 cities and states having higher return.
SELECT Returned_items, Count(Returned_items)as Returned_Items_Count,States,City
FROM store
GROUP BY Returned_items,states,city
Having Returned_items='Returned'
ORDER BY Count(Returned_items) DESC
limit 20;


-- --Check whether new customers are returning higher or not.
SELECT Returned_items, Count(Returned_items)as Returned_Items_Count,Customer_duration
FROM store
GROUP BY Returned_items,Customer_duration
Having Returned_items='Returned'
ORDER BY Count(Returned_items) DESC
limit 20;

-- --Find Top  Reasons for returning.
SELECT Returned_items, Count(Returned_items)as Returned_Items_Count,return_reason
FROM store
GROUP BY Returned_items,return_reason
Having Returned_items='Returned'
ORDER BY Count(Returned_items) DESC