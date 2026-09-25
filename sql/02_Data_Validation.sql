---------------------------------------------------------------------------------
SELECT 
    COUNT(*) AS TotalOrders,
    COUNT(DISTINCT CUSTOMER_ID) AS UniqueCustomerIDs,
    COUNT(DISTINCT CUSTOMER_UNIQUE_ID) AS UniqueCustomers
FROM [dbo].[olist_orders_dataset];


SELECT 
    CUSTOMER_ID,
    COUNT(*) AS OrderCount
FROM [dbo].[olist_orders_dataset]
GROUP BY CUSTOMER_ID
ORDER BY OrderCount DESC;



SELECT 
    CUSTOMER_UNIQUE_ID,
    COUNT(*) AS OrderCount
FROM [dbo].[olist_orders_dataset]
GROUP BY CUSTOMER_UNIQUE_ID
HAVING COUNT(*) > 1
ORDER BY OrderCount DESC;

-------------------------------------------------

--Which customers have placed more than one order?



SELECT 
    CUSTOMER_UNIQUE_ID,
    COUNT(*) AS OrderCount
    FROM [dbo].[olist_customers_dataset] AS C
    INNER JOIN [dbo].[olist_orders_dataset] AS O
    ON C.CUSTOMER_ID = O.CUSTOMER_ID
    GROUP BY CUSTOMER_UNIQUE_ID
    HAVING COUNT(*) > 1
    ORDER BY OrderCount DESC;




    ---------------------------------------------------



    --What percentage of unique customers are repeat customers (customers who placed more than one order)?


    ;WITH CTE AS (
    SELECT COUNT(DISTINCT CUSTOMER_UNIQUE_ID) AS TotalUniqueCustomers
    FROM [dbo].[olist_customers_dataset]
           )
           SELECT 
           COUNT(DISTINCT
           CASE WHEN OrderCount > 1 THEN CUSTOMER_UNIQUE_ID END) AS RepeatCustomers
           FROM (
               SELECT 
    CUSTOMER_UNIQUE_ID,
    COUNT(*) AS OrderCount
    FROM [dbo].[olist_customers_dataset] AS C
    INNER JOIN [dbo].[olist_orders_dataset] AS O
    ON C.CUSTOMER_ID = O.CUSTOMER_ID
    GROUP BY CUSTOMER_UNIQUE_ID
    HAVING COUNT(*) > 1
    ORDER BY OrderCount DESC
           ) AS Subquery

-----------------------------------------------------------------------



select top 1* from [dbo].[olist_orders_dataset] as o
select top 1* from [dbo].[olist_customers_dataset] as c
select top 1* from [dbo].[olist_order_items_dataset] as oi


   --What percentage of unique customers are repeat customers, where a repeat customer is someone who placed more than one order?



--;WITH CTE AS (
--SELECT CUSTOMER_UNIQUE_ID, COUNT(CUSTOMER_UNIQUE_ID) AS TotalUniqueCustomers
--    FROM [dbo].[olist_customers_dataset]
--    ORDER BY CUSTOMER_UNIQUE_ID
    
--)
--SELECT 
--COUNT(DISTINCT(TotalUniqueCustomers)) AS RepeatCustomers
--FROM CTE INNER JOIN olist_orders_dataset 
--ON CTE.CUSTOMER_ID = olist_orders_dataset.CUSTOMER_ID
--WHERE COUNT(olist_orders_dataset.ORDER_ID) > 1

--SELECT C.CUSTOMER_UNIQUE_ID, COUNT(O.ORDER_ID) AS OrderCount
--FROM [dbo].[olist_orders_dataset] AS O INNER JOIN 
--[dbo].[olist_customers_dataset] AS C
--ON C.CUSTOMER_ID = olist_orders_dataset.CUSTOMER_ID

;with cte as (
select c.customer_unique_id as unique_customers, count(o.order_id) as order_count
from [dbo].[olist_customers_dataset] as c
inner join [dbo].[olist_orders_dataset] as o
on c.customer_id = o.customer_id
group by c.customer_unique_id
)
select count(distinct(unique_customers)) as total_customers,
count(distinct case when order_count > 1 then unique_customers end) as repeat_customer_count,
count(distinct case when order_count > 1 then unique_customers end)/ count(distinct(unique_customers))*100 as repeat_customer_percentage
from cte 


------------------------------------------------------------------------------------------

select * from [dbo].[olist_products_dataset] as p



SELECT TOP 5 *
FROM [dbo].[olist_products_dataset];


SELECT COUNT(*) AS total_products
FROM [dbo].[olist_products_dataset];


SELECT COUNT(DISTINCT product_id) AS unique_products
FROM [dbo].[olist_products_dataset];


SELECT 
    COUNT(*) AS total_rows,
    COUNT(product_category_name) AS products_with_category,
    COUNT(product_weight_g) AS products_with_weight
FROM [dbo].[olist_products_dataset];


--Next task — Delivery Validation #1
--How many delivered orders have NULL order_delivered_customer_date or NULL order_estimated_delivery_date?


SELECT COUNT(*) AS NULL_DELIVERY_DATES FROM olist_orders_dataset
WHERE
ORDER_STATUS = 'DELIVERED' AND 
order_delivered_customer_date IS NULL OR order_estimated_delivery_date IS NULL;



---------------------------------------------------
------------------------------------------------
--\Next — Delivery Validation #2

--Check whether there are any delivered orders where the actual delivery date is earlier than the purchase date.

SELECT COUNT(*)  FROM 
olist_orders_dataset
WHERE ORDER_STATUS = 'DELIVERED'
AND 
order_delivered_customer_date < order_purchase_timestamp
