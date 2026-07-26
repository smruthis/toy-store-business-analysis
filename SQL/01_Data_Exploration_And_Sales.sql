#Database Understanding & Data Validation
#use database
use toy_store

#What tables are available in the database?
SHOW tables;

#Verify row counts
SELECT 'products' AS table_name, COUNT(*) AS total_rows
FROM products

UNION ALL

SELECT 'orders', COUNT(*)
FROM orders

UNION ALL

SELECT 'order_items', COUNT(*)
FROM order_items

UNION ALL

SELECT 'order_item_refunds', COUNT(*)
FROM order_item_refunds

UNION ALL

SELECT 'website_sessions', COUNT(*)
FROM website_sessions

UNION ALL

SELECT 'website_pageviews', COUNT(*)
FROM website_pageviews;

#What is the date range of our data?
SELECT MIN(created_at) AS start_date, MAX(created_at) AS end_date FROM orders;

#View the first 10 rows of each table
SELECT * FROM products LIMIT 10;
SELECT * FROM orders LIMIT 10;
SELECT * FROM order_items LIMIT 10;
SELECT * FROM order_item_refunds LIMIT 10;
SELECT * FROM website_pageviews LIMIT 10;
SELECT * FROM website_sessions LIMIT 10;


#Count distinct users
SELECT COUNT(DISTINCT user_id) AS unique_customers
FROM website_sessions;

#total website sessions were recorded?
SELECT COUNT(*) AS total_sessions
FROM website_sessions;

#Basic KPI
SELECT COUNT(*) AS total_orders
FROM orders;

#Sales Analytics
#How much revenue has the company generated?
SELECT ROUND(SUM(price_usd),2) AS Total_Revenue FROM orders;

#How many products were sold?
SELECT SUM(items_purchased) AS Total_Items_Sold
FROM orders;

#Average Order Value (AOV)
SELECT ROUND(AVG(price_usd),2) AS Average_Order_Value FROM orders;

#Monthly Revenue
SELECT YEAR(created_at) AS Year, MONTH(created_at) AS Month,
ROUND(SUM(price_usd),2) AS Revenue
FROM orders
GROUP BY YEAR(created_at), MONTH(created_at)
ORDER BY Year, Month;

#Monthly Orders
SELECT YEAR(created_at) AS Year, MONTH(created_at) AS Month, COUNT(order_id) AS Orders
FROM orders
GROUP BY YEAR(created_at), MONTH(created_at)
ORDER BY Year, Month;

#Average Items Per Order
SELECT ROUND(AVG(items_purchased),2) AS Avg_Items_Per_Order
FROM orders;

#Highest Revenue Month
SELECT YEAR(created_at) AS Year, MONTH(created_at) AS Month,
ROUND(SUM(price_usd),2) AS Revenue
FROM orders
GROUP BY YEAR(created_at), MONTH(created_at)
ORDER BY Revenue DESC
LIMIT 1;


#What is the website conversion rate?
SELECT ROUND((SELECT COUNT(*) FROM orders) * 100.0 /(SELECT COUNT(*) FROM website_sessions),2)
 AS conversion_rate_percentage;

