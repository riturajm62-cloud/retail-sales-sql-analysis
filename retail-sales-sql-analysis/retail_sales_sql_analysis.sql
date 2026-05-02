--=========================================================================================
                         
                        -- RETAIL SALES  ANALYSIS SQL PROJECT
--==========================================================================================

-- =========================================================================================
-- OBJECTIVE:
-- Analyze retail sales data to understand:
-- - Sales and profit performance
-- - Regional and category trends
-- - Impact of discounts on profitability
-- - Customer contribution and behavior
-- ==========================================================================================

--=============================================================================================							   
                
                 --SECTION 1: KEY PERFORMANCE INDICATORS (KPIs)
                 
--=============================================================================================

--1. Total Sales
SELECT 
  ROUND(SUM(sales),2) AS total_sales
FROM orders;

--2. Total Profit
SELECT ROUND(SUM(profit),2) AS total_profit
FROM orders;

--3. Total Orders
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM orders;

--4. Total Quantity Sold
SELECT SUM(quantity) AS total_quantity
FROM orders;

--5. Avera+ge Order Value
SELECT ROUND(SUM(sales)/COUNT(DISTINCT order_id),2)
AS avg_order_value
FROM orders;

--6. Profit Margins(%) 
SELECT
ROUND(SUM(profit)*100.0/SUM(sales),2)
AS profit_margin_percentage
FROM orders;

--7. Total Customers
SELECT COUNT(DISTINCT customer_name)AS total_customers
FROM orders;

--8. Sales Per Customer
SELECT
ROUND(SUM(sales)/COUNT(DISTINCT customer_name),2)
AS sales_per_customer
FROM orders;

--===========================================================================================
                           --SECTION 2: GROUP BY ANALYSIS
--===========================================================================================
--1. Sales By Region
SELECT
  region,
  ROUND(SUM(sales),2)AS total_sales
FROM orders
GROUP BY region
ORDER BY total_sales DESC;

--2. Profit By Region
SELECT
  region,
  ROUND(SUM(profit),2) AS total_profit
FROM orders
GROUP BY region
ORDER BY total_profit DESC;

--3. Sales By Category
SELECT
  category,
  ROUND(SUM(sales),2)AS total_sales
FROM orders
GROUP BY category
ORDER BY total_sales DESC;

--4. Profit By Category
SELECT
  category,
  ROUND(SUM(profit),2)AS total_profit
FROM orders
GROUP BY category
ORDER BY total_profit DESC;

--5. Sales By Segment
SELECT
  segment,
  ROUND(SUM(sales),2)AS total_sales
FROM orders
GROUP BY segment
ORDER BY total_sales DESC;

--6. Top 5 Products By Sales
SELECT
  product_name,
  ROUND(SUM(sales),2)AS total_sales
FROM orders
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 5;

--7. Bottom 5 Products By Profit
SELECT
  product_name,
  ROUND(SUM(profit),2)AS total_profit
FROM orders
GROUP BY product_name
ORDER BY total_profit ASC
LIMIT 5;

--8. Loss-Making Products Analysis
SELECT 
  product_name,
  ROUND(SUM(sales),2) AS total_sales,
  ROUND(SUM(profit),2) AS total_profit,
  ROUND(AVG(discount),2) AS avg_discount,
  ROUND(AVG(shipping_cost),2) AS avg_shipping_cost
FROM orders
GROUP BY product_name
HAVING SUM(profit)<0
ORDER BY total_profit ASC;

--9. Discount Impact On Profit(Bucketed)
-- Discount Buckets vs Profit
SELECT 
    CASE 
        WHEN discount < 0.1 THEN 'Low (<10%)'
        WHEN discount < 0.3 THEN 'Medium (10–30%)'
        WHEN discount < 0.5 THEN 'High (30–50%)'
        ELSE 'Very High (>50%)'
    END AS discount_bucket,
    ROUND(SUM(sales), 2)  AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM orders
GROUP BY discount_bucket
ORDER BY discount_bucket;

--10. Shipping Cost Impact
--Shipping Cost Buckets vs Profit
SELECT 
    CASE 
        WHEN shipping_cost < 20 THEN 'Low (<20)'
        WHEN shipping_cost < 50 THEN 'Medium (20–50)'
        WHEN shipping_cost < 100 THEN 'High (50–100)'
        ELSE 'Very High (>100)'
    END AS shipping_bucket,
    ROUND(SUM(sales), 2)  AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM orders
GROUP BY shipping_bucket
ORDER BY shipping_bucket;

--11 Combined Effect (Shipping Cost + Discount)
-- High Discount + High Shipping = ?
SELECT 
    ROUND(AVG(discount), 2)        AS avg_discount,
    ROUND(AVG(shipping_cost), 2)   AS avg_shipping,
    ROUND(SUM(profit), 2)          AS total_profit
FROM orders
WHERE discount > 0.5
   OR shipping_cost > 100;

--12. Correlation Check
SELECT CORR(discount, profit)
FROM orders;

--==========================================================================================
                      --SECTION 3: REGIONAL PERFORMANCE & MANAGEMENT ANALYSIS
--==========================================================================================

--1. Regional Sales & Profit By Manager 

SELECT 
    p.person,
    o.region,
    ROUND(SUM(o.sales), 2) AS total_sales,
    ROUND(SUM(o.profit), 2) AS total_profit
FROM orders o
LEFT JOIN people_data p
ON o.region = p.region
GROUP BY p.person, o.region
ORDER BY total_sales DESC;

--2. Profit Margin Analysis By Region & Manager
SELECT 
    p.person,
    o.region,
    ROUND(SUM(o.sales), 2) AS total_sales,
    ROUND(SUM(o.profit), 2) AS total_profit,
    ROUND(SUM(o.profit) * 100.0 / SUM(o.sales), 2) AS profit_margin
FROM orders o
LEFT JOIN people_data p
ON o.region = p.region
GROUP BY p.person, o.region
ORDER BY profit_margin DESC;

-- ==========================================================================================
                         -- SECTION 4: TIME-BASED SALES ANALYSIS
-- ==========================================================================================

--1. Monthly Sales & Profit Trend
SELECT 
    month_year,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM orders
GROUP BY month_year
ORDER BY month_year;

-- =========================================================================================
                           -- SECTION 5: CUSTOMER ANALYSIS
-- =========================================================================================

-- 1. Top 5 Customers by Sales and Profit Contribution
SELECT 
    customer_name,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM orders
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 5;


------------------------------------------------------------
-- FINAL NOTE:
-- This analysis identifies key drivers of profitability,
-- highlights loss-making areas, and provides insights
-- for better pricing and regional strategy decisions.
------------------------------------------------------------



