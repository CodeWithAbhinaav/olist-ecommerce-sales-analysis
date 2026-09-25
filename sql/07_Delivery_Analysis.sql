--Delivery Analysis — Q1

--Business Question

--How long does Olist take to deliver orders, and how often are orders delivered late?


select * from olist_orders_dataset
select * from olist_customers_dataset

Select order_id, customer_id, order_purchase_timestamp, order_delivered_Customer_date, datediff(day, order_purchase_timestamp, order_delivered_Customer_date)
from olist_orders_dataset
where order_status = 'delivered';



-----------------------------------------------
--Delivery Analysis — Q2
--What is the average delivery time for Olist orders?


;with cte as (
Select order_id, customer_id, order_purchase_timestamp, order_delivered_Customer_date, datediff(day, order_purchase_timestamp, order_delivered_Customer_date) as dilever_days
from olist_orders_dataset
where order_status = 'delivered'
)
select avg(dilever_days)
from cte;

--------------------------------------------------------------------------------------------------------------
--Delivery Analysis — Q3
--How many orders were delivered late versus on time/early?

;with cte as (
select *,
case
when order_delivered_customer_date > order_estimated_delivery_date
then 'late'
else 'on_time'
end as order_st
from olist_orders_dataset
where order_status = 'delivered'
)
select order_st,
count(order_id) as total_orders,
sum(count(order_id)) over () as overall_total
from cte
group by order_st

--------------------------------

--Delivery Analysis — Q4

--What percentage of delivered orders were delivered late?

;with cte as (
select *,
case
when order_delivered_customer_date > order_estimated_delivery_date
then 'late'
else 'on_time'
end as order_st
from olist_orders_dataset
where order_status = 'delivered'
),
cte2 as (
select order_st,
count(order_id) as total_orders,
sum(count(order_id)) over () as overall_total
from cte
group by order_st
)
select
order_st, total_orders,
cast(total_orders as decimal(12,2)) / overall_total * 100 as percentage_of_orders
from cte2

------------------------------------------------------------------------------------

--Delivery Analysis — Q5
--How many days early or late are orders compared with the estimated delivery date?

select order_id, customer_id,order_estimated_delivery_date, order_delivered_customer_date,
datediff(day, order_estimated_delivery_date, order_delivered_customer_date) as delivery_difference_days
from olist_orders_dataset
where order_status = 'delivered'


----------------------------------------------

--Delivery Q6
--What is the average number of days orders were delivered early or late compared with the estimated delivery date?

;with cte as (
select order_id, customer_id,order_estimated_delivery_date, order_delivered_customer_date,
datediff(day, order_estimated_delivery_date, order_delivered_customer_date) as delivery_difference_days
from olist_orders_dataset
where order_status = 'delivered'
)
select  avg(delivery_difference_days) as avg_delivery_difference_days
from cte

---------------------------------------------------------------------------
--Delivery Q7 — Customer State Performance

--Which customer states have the highest average delivery delay/early delivery?

;with cte as (
select c.customer_state, o.order_id, o.customer_id,o.order_estimated_delivery_date, o.order_delivered_customer_date,
datediff(day, o.order_estimated_delivery_date, o.order_delivered_customer_date) as delivery_difference_days
from olist_orders_dataset as o inner join olist_customers_dataset as c
on o.customer_id = c.customer_id 
where o.order_status = 'delivered'
)
select customer_state, avg(delivery_difference_days) as avg_state_delivery_difference_days
from cte
group by customer_state;


-----------------------------------------------------------------------------------------------------

--Delivery Q8

--Which customer states have the highest percentage of late deliveries?

;with cte as (
select 
c.customer_state,
        o.order_id,
        o.customer_id,
        o.order_delivered_customer_date,
        o.order_estimated_delivery_date,
case
when o.order_delivered_customer_date > o.order_estimated_delivery_date
then 'late'
else 'on_time'
end as order_st
from olist_orders_dataset as o inner join olist_customers_dataset as c
on o.customer_id = c.customer_id
where o.order_status = 'delivered'
),
cte2 as (
select customer_state, order_st,
count(order_id) as total_orders,
sum(count(order_id)) over (partition by customer_state) as overall_total
from cte
group by customer_state, order_st
)
select customer_state, order_st, total_orders, overall_total, (cast(total_orders as decimal (12,2))  / overall_total) * 100   AS late_delivery_percentage from cte2
where order_st = 'late'


--------------------------------------------------------------------------------------


--Delivery Q9
--Which customer states have the highest average delivery time?

;with cte as (
Select
c.customer_state, o.order_id, o.customer_id, o.order_purchase_timestamp, o.order_delivered_Customer_date, datediff(day, o.order_purchase_timestamp, o.order_delivered_Customer_date) as dilever_days
from olist_orders_dataset as o inner join olist_customers_dataset as c
on o.customer_id = c.customer_id 
where order_status = 'delivered'
)
select customer_state, avg(dilever_days) as average_delivery_time
from cte
group by customer_state
order by average_delivery_time desc


-----------------------------------------------------------------------------------------------

--Delivery Q10
--What percentage of delivered orders were delivered early, on the estimated date, and late?

-----------------------------------


;with cte as (
select 
        o.order_id,
        o.customer_id,
        o.order_delivered_customer_date,
        o.order_estimated_delivery_date,
case
when o.order_delivered_customer_date > o.order_estimated_delivery_date
then 'late'
when o.order_delivered_customer_date = o.order_estimated_delivery_date then 'on_time'
else 'early'
end as order_st
from olist_orders_dataset as o inner join olist_customers_dataset as c
on o.customer_id = c.customer_id
where o.order_status = 'delivered'
),
cte2 as (
select order_st,
count(order_id) as total_orders,
sum(count(order_id)) over () as overall_total
from cte
group by order_st
)
select order_st, total_orders, overall_total, (cast(total_orders as decimal (12,2))  / overall_total) * 100   AS late_delivery_percentage from cte2

---------------------------------------------------
---------------------------------------------------


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



----------------------------------------------------------------
----------------------------------------------------------------
