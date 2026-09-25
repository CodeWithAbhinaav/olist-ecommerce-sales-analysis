--"Which cities generate the most sales?"

    SELECT TOP 1 * FROM [dbo].[olist_customers_dataset]
    SELECT TOP 1 * FROM [dbo].[olist_order_items_dataset]
    SELECT TOP 1 * FROM [dbo].[olist_orders_dataset]




    SELECT C.CUSTOMER_CITY, SUM(OI.PRICE) AS TOTAL_SALES
    FROM [dbo].[olist_customers_dataset] AS C INNER JOIN [dbo].[olist_orders_dataset] AS O
    ON C.CUSTOMER_ID = O.CUSTOMER_ID
    INNER JOIN [dbo].[olist_order_items_dataset] AS OI
    ON O.ORDER_ID = OI.ORDER_ID
    GROUP BY C.CUSTOMER_CITY
    ORDER BY SUM(OI.PRICE) DESC



    --"Don't just show me total sales by city. Show me the top 10 cities by sales."



     SELECT TOP 10 C.CUSTOMER_CITY, SUM(OI.PRICE) AS TOTAL_SALES
    FROM [dbo].[olist_customers_dataset] AS C INNER JOIN [dbo].[olist_orders_dataset] AS O
    ON C.CUSTOMER_ID = O.CUSTOMER_ID
    INNER JOIN [dbo].[olist_order_items_dataset] AS OI
    ON O.ORDER_ID = OI.ORDER_ID
    GROUP BY C.CUSTOMER_CITY
    ORDER BY SUM(OI.PRICE) DESC


    --"Okay, I know which cities have the highest sales. But which cities have the most customers?"

    SELECT TOP 10 C.CUSTOMER_CITY, COUNT(DISTINCT C.CUSTOMER_ID) AS TOTAL_CUSTOMERS
    FROM [dbo].[olist_customers_dataset] AS C INNER JOIN [dbo].[olist_orders_dataset] AS O
    ON C.CUSTOMER_ID = O.CUSTOMER_ID
    GROUP BY C.customer_city
    ORDER BY TOTAL_CUSTOMERS DESC;





    --"Which cities have both a large customer base AND high sales?"


    SELECT C.CUSTOMER_CITY, COUNT(DISTINCT C.CUSTOMER_ID) AS TOTAL_CUSTOMERS, SUM(OI.PRICE) AS TOTAL_SALES
    FROM [dbo].[olist_customers_dataset] AS C INNER JOIN [dbo].[olist_orders_dataset] AS O
    ON C.CUSTOMER_ID = O.CUSTOMER_ID
    INNER JOIN [dbo].[olist_order_items_dataset] AS OI
    ON O.ORDER_ID = OI.ORDER_ID
    GROUP BY C.CUSTOMER_CITY
    ORDER BY TOTAL_CUSTOMERS, TOTAL_SALES DESC;





    --"Which cities generate the most sales per customer?"


    SELECT C.CUSTOMER_CITY, (SUM(OI.PRICE) / COUNT(DISTINCT C.CUSTOMER_ID)) AS SALE_PER_CUSTOMER
    FROM  [dbo].[olist_customers_dataset] AS C INNER JOIN [dbo].[olist_orders_dataset] AS O
    ON C.CUSTOMER_ID = O.CUSTOMER_ID
    INNER JOIN [dbo].[olist_order_items_dataset] AS OI
    ON O.ORDER_ID = OI.ORDER_ID
    GROUP BY C.customer_city
    ORDER BY SALE_PER_CUSTOMER DESC;


    --"Which individual customers have generated the most sales?"



    SELECT TOP 10 C.CUSTOMER_ID, SUM(OI.PRICE) AS TOTAL_CUSTOMER_SALES
    FROM  [dbo].[olist_customers_dataset] AS C INNER JOIN [dbo].[olist_orders_dataset] AS O
    ON C.CUSTOMER_ID = O.CUSTOMER_ID
    INNER JOIN [dbo].[olist_order_items_dataset] AS OI
    ON O.ORDER_ID = OI.ORDER_ID
    GROUP BY C.customer_id
    ORDER BY TOTAL_CUSTOMER_SALES DESC;



    --"How many customers are responsible for a large portion of our total sales?"








    --"How many orders has each customer placed?



    SELECT C.CUSTOMER_ID, COUNT(DISTINCT O.ORDER_ID) AS TOTAL_ORDERS
    FROM  [dbo].[olist_customers_dataset] AS C INNER JOIN [dbo].[olist_orders_dataset] AS O
    ON C.CUSTOMER_ID = O.CUSTOMER_ID
    INNER JOIN [dbo].[olist_order_items_dataset] AS OI
    ON O.ORDER_ID = OI.ORDER_ID
    GROUP BY C.customer_id
    ORDER BY TOTAL_ORDERS 

    SELECT COUNT(DISTINCT CUSTOMER_ID) FROM  [dbo].[olist_customers_dataset]



--"What is the average sales value per order for each customer?"


SELECT SUM(OI.PRICE) / COUNT(DISTINCT O.ORDER_ID) AS AVG_SALES_PER_ORDER, C.CUSTOMER_ID
FROM [dbo].[olist_customers_dataset] AS C INNER JOIN [dbo].[olist_orders_dataset] AS O
ON C.CUSTOMER_ID = O.CUSTOMER_ID
INNER JOIN [dbo].[olist_order_items_dataset] AS OI
ON O.ORDER_ID = OI.ORDER_ID
GROUP BY C.CUSTOMER_ID
ORDER BY AVG_SALES_PER_ORDER DESC;


--"Which 10 customers are the most frequent buyers?"



SELECT  C.CUSTOMER_ID, COUNT(DISTINCT O.ORDER_ID) AS TOTAL_ORDERS 
FROM [dbo].[olist_customers_dataset] AS C INNER JOIN [dbo].[olist_orders_dataset] AS O
ON C.CUSTOMER_ID = O.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID
ORDER BY TOTAL_ORDERS DESC,C.customer_id


SELECT C.CUSTOMER_ID, COUNT(O.ORDER_ID) FROM  [dbo].[olist_customers_dataset] AS C INNER JOIN [dbo].[olist_orders_dataset] AS O
ON C.CUSTOMER_ID = O.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID
ORDER BY COUNT(O.ORDER_ID) DESC;





SELECT CUSTOMER_ID  
FROM  [dbo].[olist_orders_dataset]
GROUP BY CUSTOMER_ID
HAVING COUNT(ORDER_ID) > 1



--How many customers have 1 order, 2 orders, 3 orders, etc.?


    ;WITH CustomerOrderCounts AS (
    SELECT CUSTOMER_ID,
           COUNT(ORDER_ID) AS OrderCount
    FROM [dbo].[olist_orders_dataset]
    GROUP BY CUSTOMER_ID
)
SELECT OrderCount,
       COUNT(CUSTOMER_ID) AS CustomerCount
FROM CustomerOrderCounts
GROUP BY OrderCount
ORDER BY OrderCount;


----------------------------------------------------------------------------------------------------

--Which customers have placed more than one order?



SELECT CUSTOMER_ID, COUNT(ORDER_ID) AS OrderCount
FROM [dbo].[olist_orders_dataset]  
GROUP BY CUSTOMER_ID
HAVING COUNT(ORDER_ID) > 1;
SELECT * FROM [dbo].[olist_orders_dataset]  
WHERE CUSTOMER_ID IN (
    SELECT CUSTOMER_ID
    FROM [dbo].[olist_orders_dataset]
    GROUP BY CUSTOMER_ID
    HAVING COUNT(ORDER_ID) > 1
);

SELECT DISTINCT(CUSTOMER_ID) FROM [dbo].[olist_orders_dataset]  
WHERE CUSTOMER_ID IN (
    SELECT CUSTOMER_ID
    FROM [dbo].[olist_orders_dataset]
    GROUP BY CUSTOMER_ID
    HAVING COUNT(ORDER_ID) > 1
);




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

--How many customers are there in each state?


select 
c.customer_state, count(distinct c.customer_unique_id) as total_customers
from [dbo].[olist_customers_dataset] as c
group by c.customer_state
order by total_customers desc



--Which 10 cities have the highest number of unique customers?


select top 10 c.customer_city , count(distinct c.customer_unique_id) as total_customers
from [dbo].[olist_customers_dataset] as c
group by c.customer_city
order by total_customers desc




--Which customers are repeat customers, and how many orders has each placed?


select distinct c.customer_unique_id, count(o.order_id) as order_count
from [dbo].[olist_customers_dataset] as c inner join [dbo].[olist_orders_dataset] as o
on c.customer_id = o.customer_id
group by c.customer_unique_id
having count(o.order_id) > 1



--What percentage of total customers are repeat customers, and what percentage are one-time customers?



--;with cte as (
--select
--c.customer_unique_id as unique_customers, count(o.order_id) as order_count
--from [dbo].[olist_customers_dataset] as c inner join [dbo].[olist_orders_dataset] as o
--on  c.customer_id = o.customer_id
--group by c.customer_unique_id
--), cte2 as (
--select
--case 
--when order_count > 1 then 'Repeat Customers' else 'One-Time Customers' end as customer_type
--from cte
--),
--cte3 as (
--select customer_type, count(*) as total_customers_type
--from cte2
--group by customer_type
--)
--select customer_type, total_customers_type
--from cte3


----------------------------------------------------
--;with cte as (
--select count(customer_unique_id)as total_customers,
--c.customer_unique_id as unique_customers, count(o.order_id) as order_count
--from [dbo].[olist_customers_dataset] as c inner join [dbo].[olist_orders_dataset] as o
--on  c.customer_id = o.customer_id
--group by c.customer_unique_id
--), cte2 as (
--select
--total_customers,
--case 
--when order_count > 1 then 'Repeat Customers' else 'One-Time Customers' end as customer_type
--from cte
--),
--cte3 as (
--select customer_type, count(*) as total_customers_type, total_customers, (count(*) * 100.0 / total_customers) as percentage_of_total_customers
--from cte2
--group by customer_type
--)
--select customer_type, total_customers_type, total_customers, percentage_of_total_customers
--from cte3

--------------------------------------------------------


;with cte as (
select
c.customer_unique_id as unique_customers, count(o.order_id) as order_count
from [dbo].[olist_customers_dataset] as c inner join [dbo].[olist_orders_dataset] as o
on  c.customer_id = o.customer_id
group by c.customer_unique_id
), cte2 as (
select
case 
when order_count > 1 then 'Repeat Customers' else 'One-Time Customers' end as customer_type
from cte
),
cte3 as (
select
customer_type,
count(*) as total_customers_type,
sum(
count(*))over () as total_customers
from cte2
group by customer_type
)
select customer_type, total_customers_type, total_customers, (total_customers_type * 100.0 / total_customers) as percentage_of_total_customers
from cte3




---------------------------------------------------------------------------



--What is the average number of orders placed per unique customer?



Select AVG(OrderCount) as AverageOrdersPerCustomer
from (
    select c.customer_unique_id, count(o.order_id) as OrderCount
    from [dbo].[olist_customers_dataset] as c inner join [dbo].[olist_orders_dataset] as o
    on  c.customer_id = o.customer_id
    group by c.customer_unique_id
) as CustomerOrderCounts;


---------------------------------------------

;with cte as (
select c.customer_unique_id,
    count(o.order_id) as order_count
    from [dbo].[olist_customers_dataset] as c inner join [dbo].[olist_orders_dataset] as o
    on  c.customer_id = o.customer_id
    group by c.customer_unique_id
),
cte2 as (
select count(customer_unique_id) as total_customers, sum(order_count) as total_orders from cte
)
select CAST(total_orders AS DECIMAL(10,2)) / total_customers as average_orders_per_customer from cte2

--------------------------------------------------------------------------------------



--Which states have the highest concentration of customers?


;with cte as (
select c.customer_state, count(distinct c.customer_unique_id) as total_customers
from [dbo].[olist_customers_dataset] as c
group by c.customer_state
),
cte2 as (
select sum(total_customers) as total_customers_all_states from cte
)
select cte.customer_state, cte.total_customers, CAST(cte.total_customers AS DECIMAL(10,2)) / cte2.total_customers_all_states * 100 as percentage_of_total_customers
from cte cross join cte2






--------------------------------------------



--;with cte as (
--select c.customer_state, count(distinct c.customer_unique_id) as total_customers
--from [dbo].[olist_customers_dataset] as c
--group by c.customer_state
--),
--cte2 as (
--select
--sum(total_customers) over() as total_customers_all_statess,
--sum(total_customers) as total_customers_all_states from cte
--)
--select cte.customer_state, cte.total_customers, CAST(cte.total_customers AS DECIMAL(10,2)) / cte2.total_customers_all_states * 100 as percentage_of_total_customers
--from cte cross join cte2

-----------------------------------------------------------------------------------------------------------------------------------------




--How many customers placed 1 order, 2 orders, 3 orders, etc., and what percentage of customers does each group represent?


;with cte as (
select c.customer_unique_id, count(o.order_id) as order_count

from [dbo].[olist_customers_dataset] as c inner join [dbo].[olist_orders_dataset] as o
on  c.customer_id = o.customer_id
group by c.customer_unique_id
),
cte2 as (select order_count, count(customer_unique_id) as total_customers_in_group
from cte group by order_count
)
select order_count, total_customers_in_group, sum(total_customers_in_group) over() as total_customers_all_groups, CAST(total_customers_in_group AS DECIMAL(10,2)) / sum(total_customers_in_group) over() * 100 as percentage_of_total_customers
from cte2






--Who are the top 10 customers by total spending?



select top 10 c.customer_unique_id, sum(oi.price) as total_spending, count(distinct o.order_id) as total_orders
from [dbo].[olist_customers_dataset] as c inner join [dbo].[olist_orders_dataset] as o
on c.customer_id = o.customer_id
inner join [dbo].[olist_order_items_dataset] as oi
on o.order_id = oi.order_id
group by c.customer_unique_id
order by total_spending desc





--What is the Average Order Value (AOV) for each customer, and which 10 customers have the highest AOV?




select c.customer_unique_id, sum(oi.price)/ count(distinct o.order_id) as average_order_value, sum(oi.price) as total_spending, count(distinct o.order_id) as total_orders
from [dbo].[olist_customers_dataset] as c inner join [dbo].[olist_orders_dataset] as o
on c.customer_id = o.customer_id
inner join [dbo].[olist_order_items_dataset] as oi
on o.order_id = oi.order_id
group by c.customer_unique_id
order by average_order_value desc





--Do repeat customers generate more total revenue than one-time customers?




;with cte as (
select c.customer_unique_id, count(o.order_id) as total_orders, sum(oi.price) as total_revenue
from [dbo].[olist_customers_dataset] as c inner join [dbo].[olist_orders_dataset] as o
on c.customer_id = o.customer_id
inner join [dbo].[olist_order_items_dataset] as oi
on o.order_id = oi.order_id
group by c.customer_unique_id
),
cte2 as (
select total_orders, total_revenue,
case
when total_orders > 1 then 'Repeat Customers' else 'One-Time Customers' end as customer_type
from cte
),
cte3 as (
select customer_type, sum(total_revenue) as total_revenue_by_customer_type, count(*) as total_customers_by_customer_type
from cte2
group by customer_type
)
select customer_type, total_revenue_by_customer_type, total_customers_by_customer_type,
cast(total_revenue_by_customer_type as decimal(10,2)) / sum(total_revenue_by_customer_type) over() * 100 as percentage_of_total_revenue
from cte3



--What is the average revenue generated per customer for one-time vs repeat customers?



;with cte as (
select c.customer_unique_id, count(o.order_id) as total_orders, sum(oi.price) as total_revenue
from [dbo].[olist_customers_dataset] as c inner join [dbo].[olist_orders_dataset] as o
on c.customer_id = o.customer_id
inner join [dbo].[olist_order_items_dataset] as oi
on o.order_id = oi.order_id
group by c.customer_unique_id
),
cte2 as (
select total_orders, total_revenue,
case
when total_orders > 1 then 'Repeat Customers' else 'One-Time Customers' end as customer_type
from cte
),
cte3 as (
select customer_type, sum(total_revenue) as total_revenue_by_customer_type, count(*) as total_customers_by_customer_type
from cte2
group by customer_type
)
select customer_type,total_revenue_by_customer_type, total_customers_by_customer_type,
total_revenue_by_customer_type / total_customers_by_customer_type as average_revenue_per_customer
from cte3


---------------------------------------------------------------------------


--Customer Revenue vs Order Frequency
--Do customers who place more orders also generate more revenue on average?




--;with cte as (

--select c.customer_unique_id, count(o.order_id) as total_orders, sum(oi.price) as total_revenue, sum(oi.price) / count(o.order_id) as average_revenue_per_order
--from [dbo].[olist_customers_dataset] as c inner join [dbo].[olist_orders_dataset] as o
--on c.customer_id = o.customer_id
--inner join [dbo].[olist_order_items_dataset] as oi
--on o.order_id = oi.order_id
--group by c.customer_unique_id
--),
--CTE2 as (
--select
--count(*) over () as number_of_customers,
--sum(total_revenue) over () as total_revenue,
--avg(average_revenue_per_order) over () as average_revenue_per_order
--from cte
--group by total_orders
--)
--select *
--from CTE2

;with cte as (
select c.customer_unique_id, count(o.order_id) as total_orders, sum(oi.price) as total_revenue
from [dbo].[olist_customers_dataset] as c inner join [dbo].[olist_orders_dataset] as o
on c.customer_id = o.customer_id
inner join [dbo].[olist_order_items_dataset] as oi
on o.order_id = oi.order_id
group by c.customer_unique_id
),
cte2 as (
select total_orders, sum(total_revenue) as total_revenue_by_order_count, count(*) as total_customers_by_order_count
from cte
group by total_orders
),
cte3 as (
select total_orders, total_revenue_by_order_count, total_customers_by_order_count, total_revenue_by_order_count / total_customers_by_order_count as average_revenue_per_customer
from cte2
)
select total_orders, total_revenue_by_order_count, total_customers_by_order_count, average_revenue_per_customer
from cte3


----------------------------------------------------------------------------------------





--How much more revenue does a repeat customer generate compared with a one-time customer?



;with cte as (
select c.customer_unique_id, count(o.order_id) as total_orders, sum(oi.price) as total_revenue
from [dbo].[olist_customers_dataset] as c inner join [dbo].[olist_orders_dataset] as o
on c.customer_id = o.customer_id
inner join [dbo].[olist_order_items_dataset] as oi
on o.order_id = oi.order_id
group by c.customer_unique_id
), 
cte2 as (
select total_orders, sum(total_revenue) as total_revenue_by_order_count, count(*) as total_customers_by_order_count
from cte
group by total_orders
),
cte3 as (
select case
when total_orders > 1 then 'Repeat Customers' else 'One-Time Customers' end as customer_type, total_revenue_by_order_count, total_customers_by_order_count
from cte2
),
cte4 as (
select customer_type, sum(total_revenue_by_order_count) as total_revenue_by_customer_type, sum(total_customers_by_order_count) as total_customers_by_customer_type
from cte3
group by customer_type
)
select customer_type, total_revenue_by_customer_type, total_customers_by_customer_type, CAST(total_revenue_by_customer_type AS DECIMAL(12,2))
    / total_customers_by_customer_type
    AS average_revenue_per_customer
from cte4


----------------------------------------------------------------------------
;with cte as (
select c.customer_unique_id, count(o.order_id) as total_orders, sum(oi.price) as total_revenue
from [dbo].[olist_customers_dataset] as c inner join [dbo].[olist_orders_dataset] as o
on c.customer_id = o.customer_id
inner join [dbo].[olist_order_items_dataset] as oi
on o.order_id = oi.order_id
group by c.customer_unique_id
), 
cte2 as (
select total_orders, sum(total_revenue) as total_revenue_by_order_count, count(*) as total_customers_by_order_count
from cte
group by total_orders
),
cte3 as (
select case
when total_orders > 1 then 'Repeat Customers' else 'One-Time Customers' end as customer_type, total_revenue_by_order_count, total_customers_by_order_count
from cte2
),
cte4 as (
select customer_type, sum(total_revenue_by_order_count) as total_revenue_by_customer_type, sum(total_customers_by_order_count) as total_customers_by_customer_type
from cte3
group by customer_type
),
cte5 as (
select customer_type, total_revenue_by_customer_type, total_customers_by_customer_type, CAST(total_revenue_by_customer_type AS DECIMAL(12,2))
    / total_customers_by_customer_type
    AS average_revenue_per_customer
from cte4
 )
 select customer_type, total_revenue_by_customer_type, total_customers_by_customer_type, average_revenue_per_customer,
 lead(average_revenue_per_customer) over (order by average_revenue_per_customer desc) - average_revenue_per_customer as revenue_difference,
 lag(average_revenue_per_customer) over (order by average_revenue_per_customer desc) - average_revenue_per_customer as revenue_difference_lag
 from cte5

 -----------------------------------------------------------------

 ;with cte as (
select c.customer_unique_id, count(o.order_id) as total_orders, sum(oi.price) as total_revenue
from [dbo].[olist_customers_dataset] as c inner join [dbo].[olist_orders_dataset] as o
on c.customer_id = o.customer_id
inner join [dbo].[olist_order_items_dataset] as oi
on o.order_id = oi.order_id
group by c.customer_unique_id
), 
cte2 as (
select total_orders, sum(total_revenue) as total_revenue_by_order_count, count(*) as total_customers_by_order_count
from cte
group by total_orders
),
cte3 as (
select case
when total_orders > 1 then 'Repeat Customers' else 'One-Time Customers' end as customer_type, total_revenue_by_order_count, total_customers_by_order_count
from cte2
),
cte4 as (
select customer_type, sum(total_revenue_by_order_count) as total_revenue_by_customer_type, sum(total_customers_by_order_count) as total_customers_by_customer_type
from cte3
group by customer_type
),
cte5 as (
select customer_type, total_revenue_by_customer_type, total_customers_by_customer_type, CAST(total_revenue_by_customer_type AS DECIMAL(12,2))
    / total_customers_by_customer_type
    AS average_revenue_per_customer
from cte4
 )
 select customer_type, total_revenue_by_customer_type, total_customers_by_customer_type, average_revenue_per_customer,
 case 
 when customer_type = 'repeat customers' then average_revenue_per_customer - (select average_revenue_per_customer from cte5 where customer_type = 'one-time customers')
 else (select average_revenue_per_customer from cte5 where customer_type = 'repeat customers') - average_revenue_per_customer
 end as revenue_difference
 from cte5



 ----------------------------------------------------------------------------------------------------------------------------




 --What percentage of total customers are repeat customers, and what percentage of total revenue do they generate?


 ;with cte as (
 select c.customer_unique_id, count(o.order_id) as total_orders, sum(oi.price) as total_revenue
 from [dbo].[olist_customers_dataset] as c inner join [dbo].[olist_orders_dataset] as o
 on c.customer_id = o.customer_id
 inner join [dbo].[olist_order_items_dataset] as oi
 on o.order_id = oi.order_id
 group by c.customer_unique_id
 ),
 cte2 as (
 select 
    case 
        when total_orders > 1 then 'Repeat Customers' 
        else 'One-Time Customers' 
    end as customer_type,
    count(distinct customer_unique_id) as total_customers_by_type,
    sum(total_revenue) as total_revenue_by_type
    from cte
    group by case 
        when total_orders > 1 then 'Repeat Customers' 
        else 'One-Time Customers' 
    end
    ),
    cte3 as (
    select customer_type, total_customers_by_type, total_revenue_by_type,
        total_revenue_by_type / sum(total_revenue_by_type) over() * 100 as percentage_of_total_revenue,
        total_customers_by_type / sum(total_customers_by_type) over() * 100 as percentage_of_total_customers
        from cte2
        )
        select customer_type, total_customers_by_type, total_revenue_by_type, percentage_of_total_customers, percentage_of_total_revenue
from cte3




---------------------------------------------------------------------
--Customer Analysis: Final Question

--Let's finish Customer Analysis with one slightly more analytical question:

Which customer order-frequency group contributes the most revenue per customer, and how does revenue per customer change as order frequency increases?



;with cte as (
select c.customer_unique_id, count(o.order_id) as total_orders, sum(oi.price) as total_revenue
from [dbo].[olist_customers_dataset] as c inner join [dbo].[olist_orders_dataset] as o
on c.customer_id = o.customer_id
inner join [dbo].[olist_order_items_dataset] as oi
on o.order_id = oi.order_id
group by c.customer_unique_id
),
cte2 as (select total_orders, sum(total_revenue) as total_revenue_by_order_count, count(*) as total_customers_by_order_count,cast(sum(total_revenue) as decimal(12,2)) / count(*) as average_revenue_per_customer,
    SUM(SUM(total_revenue)) OVER() AS total_revenue_all_order_counts,
    sum(count(*)) over() as total_customers_all_order_counts
    from cte
    group by total_orders
    )
    select total_orders, total_revenue_by_order_count, total_customers_by_order_count, average_revenue_per_customer,
    cast(total_revenue_by_order_count as decimal(12,2)) / total_revenue_all_order_counts * 100 as percentage_of_total_revenue
    from cte2
    order by total_orders


    ------------------------------------------------------------------------------------------------------------------------------------





