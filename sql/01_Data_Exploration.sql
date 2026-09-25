
--SELECT TOP 10 *
--FROM olist_customers_dataset;
--Select count(*) as total_customers
--from olist_customers_dataset;
--EXEC sp_help 'olist_customers_dataset';
SELECT TOP 10 *
FROM olist_orders_dataset;
Select count(*) as total_customers
from olist_orders_dataset;
EXEC sp_help 'olist_orders_dataset';
--Select count(*) as total_customers
----count(distinct customer_id) as total_unique_customers, 
--,count(distinct customer_id) as total_unique_Customers
--from olist_orders_dataset;
--Select top 10 
--o.order_id,
--o.customer_id,
--c.customer_state,
--o.order_status,
--o.order_purchase_timestamp, 
--o.order_approved_at, 
--o.order_delivered_carrier_date, 
--o.order_delivered_customer_date, 
--o.order_estimated_delivery_date
--form olist_orders_dataset as o
--inner join olist_customers_dataset as c
--on o.customer_id = c.customer_id
--SELECT TOP 10
--    o.order_id,
--    o.customer_id,
--    c.customer_city,
--    c.customer_state,
--    o.order_status,
--    o.order_purchase_timestamp
--FROM orders o
--INNER JOIN customers c
--    ON o.customer_id = c.customer_id;


USE[DATABASE Olist_Freelance_Project];
GO

--SELECT TABLE_NAME
--FROM INFORMATION_SCHEMA.TABLES
--ORDER BY TABLE_NAME;

--USE Olist_Freelance_Project;
--GO

SELECT TOP 10
    o.order_id,
    o.customer_id,
    c.customer_city,
    c.customer_state,
    o.order_status,
    o.order_purchase_timestamp
FROM olist_orders_dataset AS o
INNER JOIN olist_customers_dataset AS c
    ON o.customer_id = c.customer_id;

    SELECT 
    COUNT(*) AS total_orders,
    COUNT(DISTINCT customer_id) AS unique_customers_with_orders
FROM olist_orders_dataset;

SELECT COUNT(*) AS total_order_items
FROM olist_order_items_dataset;
SELECT TOP 10 *
FROM olist_order_items_dataset;
Select 
      sum(price) as total_revenue,
      sum(freight_value) as total_shipping_cost,
      sum(price + freight_value) as total_revenue_with_shipping
from olist_order_items_dataset;

SELECT
    SUM(price) AS total_product_revenue,
    SUM(freight_value) AS total_freight_value,
    SUM(price + freight_value) AS total_order_value
FROM olist_order_items_dataset;



SELECT
    SUM(price) AS total_product_revenue,
    SUM(freight_value) AS total_freight_value,
    SUM(price + freight_value) AS total_order_value
FROM olist_order_items_dataset;


select 
min(price),
max(price),
avg(price),
min(freight_value),
max(freight_value),
avg(freight_value)
from olist_order_items_dataset;


SELECT TOP 20 
ORDER_ID,
PRODUCT_ID,
PRICE,
FREIGHT_VALUE,
RANK() OVER (ORDER BY FREIGHT_VALUE DESC)
FROM olist_order_items_dataset;


