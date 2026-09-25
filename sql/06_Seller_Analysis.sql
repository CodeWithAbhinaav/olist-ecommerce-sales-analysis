--Seller Analysis

--Which sellers generate the highest total revenue, and how does their sales volume compare?

select top 10 s.seller_id, sum(oi.price) as total_revenue, count(oi.order_id) as sales_volume
from olist_sellers_dataset as s inner join olist_order_items_dataset as oi
on s.seller_id = oi.seller_id
group by s.seller_id
order by total_revenue desc


-----------------------------------------------------------------------------

--Which sellers have the highest average selling price per item, and how does their sales volume compare?


--Among sellers with at least 50 sales, which 10 have the highest average selling price per item?

select top 10 s.seller_id, sum(oi.price) as total_revenue, count(oi.order_id) as sales_volume, cast(sum(oi.price) as decimal (12,2)) / count(oi.order_id) as average_selling_price
from olist_sellers_dataset as s inner join olist_order_items_dataset as oi
on s.seller_id = oi.seller_id
group by s.seller_id
having count(oi.order_id) >= 50
order by average_selling_price desc


-----------------------------------------------------------


--Do the highest-revenue sellers also have high average selling prices, or is their revenue mainly driven by sales volume?


;with cte as (
select s.seller_id, sum(oi.price) as total_revenue, count(oi.order_id) as sales_volume, cast(sum(oi.price) as decimal (12,2)) / count(oi.order_id) as average_selling_price
from olist_sellers_dataset as s inner join olist_order_items_dataset as oi
on s.seller_id = oi.seller_id
group by s.seller_id
having count(oi.order_id) >= 50
),
cte2 as (
select *, dense_rank() over (order by total_revenue desc) as revenue_rank
from cte
),
cte3 as (
select *,
dense_rank() over (order by average_selling_price desc) as average_rank
from cte2
)
select seller_id, total_revenue, sales_volume, average_selling_price, revenue_rank, average_rank from
cte3
where revenue_rank <= 10

----------------------------------------------------------------------------------------------------------------
--Which sellers have high revenue primarily because of high sales volume, rather than high average selling price?


;with cte as (
select s.seller_id, sum(oi.price) as total_revenue, count(oi.order_id) as sales_volume, cast(sum(oi.price) as decimal (12,2)) / count(oi.order_id) as average_selling_price
from olist_sellers_dataset as s inner join olist_order_items_dataset as oi
on s.seller_id = oi.seller_id
group by s.seller_id
having count(oi.order_id) >= 50
),
cte2 as (
select *, dense_rank() over (order by total_revenue desc) as revenue_rank
from cte
),
cte3 as (
select *,
dense_rank() over (order by average_selling_price desc) as average_rank
from cte2
)
select seller_id, total_revenue, sales_volume, average_selling_price, revenue_rank, average_rank from
cte3
WHERE revenue_rank <= 10
ORDER BY sales_volume DESC


------------------------------------------------------------------------------------------------------------


--Which sellers have the highest revenue per sale, while maintaining a meaningful sales volume?


;with cte as (
select s.seller_id, sum(oi.price) as total_revenue, count(DISTINCT oi.order_id) as sales_volume,  CAST(SUM(OI.PRICE) AS DECIMAL (12,2)) / COUNT(DISTINCT(OI.ORDER_ID)) AS REVENUE_PER_ORDER
from olist_sellers_dataset as s inner join olist_order_items_dataset as oi
on s.seller_id = oi.seller_id
group by s.seller_id
HAVING COUNT(DISTINCT OI.ORDER_ID) >= 100
),
cte2 as (
select *, dense_rank() over (order by total_revenue desc) as revenue_rank
from cte
),
cte3 as (
select *,
dense_rank() over (order by REVENUE_PER_ORDER desc) as PER_ORDER_rank
from cte2
)
select seller_id, total_revenue, sales_volume, revenue_rank, REVENUE_PER_ORDER,PER_ORDER_rank from
cte3
ORDER BY REVENUE_PER_ORDER DESC

-------------------------------------------------------------------------------------------


--Which sellers have the highest number of unique orders, and how much revenue do they generate from those orders?






select s.seller_id, count(distinct oi.order_id) as unique_orders, sum(oi.price) as revenue, cast(sum(oi.price) as decimal(12,2)) / count(distinct oi.order_id) as revenue_per_order 
from  olist_sellers_dataset as s inner join olist_order_items_dataset as oi
on s.seller_id = oi.seller_id
group by s.seller_id
order by count(distinct oi.order_id) desc

----------------------------------------------------------------------------------------------
--Seller Analysis — Q6
--Business Question

--Do a small group of sellers contribute a disproportionately large share of total seller revenue?

;with cte as (
select s.seller_id, sum(oi.price) as total_revenue
from
olist_sellers_dataset as s inner join olist_order_items_dataset as oi
on s.seller_id = oi.seller_id
group by s.seller_id
),
cte2 as (
select *,
dense_rank() over ( order by total_revenue desc) as revenue_rank,
sum(total_revenue) over () as overall_revenue
from cte
)
select seller_id, total_revenue, overall_revenue, revenue_rank, (cast(total_revenue as decimal(12,2)) / overall_revenue ) * 100 as percentage_of_total_revenue
from cte2
where revenue_rank <= 10;


----------------------------------------------------------------------
--Business Question

--Which sellers have strong revenue but relatively low sales volume?


;with cte As(
select s.seller_id, sum(oi.price) as total_revenue, count(distinct oi.order_id) as unique_orders, cast(sum(oi.price) as decimal(12,2)) / count(distinct oi.order_id) as revenue_per_order
from olist_sellers_dataset as s inner join olist_order_items_dataset as oi
on s.seller_id = oi.seller_id
group by s.seller_id 
),
cte2 as (
select * ,
dense_rank() over (order by total_revenue desc) as revenue_rank,
dense_rank() over (order by unique_orders asc) as order_rank
from cte
),
cte3 as (
 select *,
 NTILE(5) OVER (ORDER BY total_revenue DESC) as revenue_tile,
 NTILE(5) OVER (ORDER BY unique_orders DESC) as Order_Tile
 from cte2
 )
 select seller_id, total_revenue, unique_orders, revenue_per_order, revenue_tile, order_tile from cte3
 where revenue_tile = 1
 and Order_Tile in (3,4,5)

--------------------------------------------------------------------------------------------------

