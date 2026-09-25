--    Product Analysis.

--Your first Product Analysis business question should be:



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

-----------------------------------------------------------------------------------------------


--Which products generate the highest sales revenue, and how does sales volume compare with revenue?



select top 10 p.product_id, p.product_category_name, sum(oi.price) as total_revenue, count(oi.order_id) as total_sales_volume
from [dbo].[olist_products_dataset] as p inner join [dbo].[olist_order_items_dataset] as oi
on p.product_id = oi.product_id
group by p.product_id, p.product_category_name
order by total_revenue desc




--Do the products with the highest sales volume also generate the highest revenue?

;with ProductSales AS (
select top 10 p.product_id, sum(oi.price) as total_revenue, count(oi.order_id) as total_sales_volume
from [dbo].[olist_products_dataset] as p inner join [dbo].[olist_order_items_dataset] as oi
on p.product_id = oi.product_id
group by p.product_id
order by total_sales_volume desc
)
select *
from ProductSales inner join (select top 10 p.product_id, sum(oi.price) as total_revenue, count(oi.order_id) as total_sales_volume
from [dbo].[olist_products_dataset] as p inner join [dbo].[olist_order_items_dataset] as oi
on p.product_id = oi.product_id
group by p.product_id
order by total_revenue desc) as ProductRevenue
on ProductSales.product_id = ProductRevenue.product_id





--------------------------
;with ProductSales AS (
select p.product_id, sum(oi.price) as total_revenue, count(oi.order_id) as total_sales_volume
from [dbo].[olist_products_dataset] as p inner join [dbo].[olist_order_items_dataset] as oi
on p.product_id = oi.product_id
group by p.product_id

),
cte AS (
select *,
ROW_NUMBER() over (order by total_sales_volume desc) as sales_volume_rank
from ProductSales
),
top_revenue AS (
select  p.product_id, sum(oi.price) as total_revenue, count(oi.order_id) as total_sales_volume
from [dbo].[olist_products_dataset] as p inner join [dbo].[olist_order_items_dataset] as oi
on p.product_id = oi.product_id
group by p.product_id

),
cte2 AS (
select *,
ROW_NUMBER() over (order by total_revenue desc) as revenue_rank
from top_revenue
)
select cte.sales_volume_rank, cte.product_id, cte.total_revenue, cte.total_sales_volume, cte2.revenue_rank, cte2.total_revenue,cte2.total_sales_volume
from cte inner join cte2
on cte.sales_volume_rank = cte2.revenue_rank
where cte.sales_volume_rank <= 10 and cte2.revenue_rank <= 10

-----------------------------------------


--Which products sell in high volume but generate relatively low revenue per unit, and which products generate high revenue per unit despite lower sales volume?



;with cte as (
select p.product_id, sum(oi.price) as total_revenue, count(oi.order_id) as total_sales_volume, cast(sum(oi.price) as decimal(12,2)) / count(oi.order_id) as revenue_per_unit
from [dbo].[olist_products_dataset] as p inner join [dbo].[olist_order_items_dataset] as oi
on p.product_id = oi.product_id
group by p.product_id
),
cte2 as (
select *, ROW_NUMBER() over (order by revenue_per_unit desc) as revenue_rank
from cte
),
cte3 as (
select p.product_id, sum(oi.price) as total_revenue, count(oi.order_id) as total_sales_volume, cast(sum(oi.price) as decimal(12,2)) / count(oi.order_id) as revenue_per_unit
from [dbo].[olist_products_dataset] as p inner join [dbo].[olist_order_items_dataset] as oi
on p.product_id = oi.product_id
group by p.product_id

),
cte4 as (
select *, ROW_NUMBER() over (order by total_sales_volume desc) as sales_volume_rank
from cte3
)
select cte2.revenue_rank, cte2.product_id, cte2.total_revenue, cte2.total_sales_volume, cte2.revenue_per_unit, cte4.sales_volume_rank, cte4.total_revenue, cte4.total_sales_volume, cte4.revenue_per_unit
from cte2 inner join cte4
on cte2.revenue_rank = cte4.sales_volume_rank
where cte2.revenue_rank <= 10 and cte4.sales_volume_rank <= 10

-----------------------------------------------------------------------------------


;with cte as (
select p.product_id, sum(oi.price) as total_revenue, count(oi.order_id) as total_sales_volume, cast(sum(oi.price) as decimal(12,2)) / count(oi.order_id) as revenue_per_unit
from [dbo].[olist_products_dataset] as p inner join [dbo].[olist_order_items_dataset] as oi
on p.product_id = oi.product_id
group by p.product_id
),
cte2 as (
select *, ROW_NUMBER() over (order by revenue_per_unit desc) as revenue_rank
from cte
),
cte3 as (
select *, ROW_NUMBER() over (order by total_sales_volume desc) as sales_volume_rank
from cte2
)
select cte2.revenue_rank, cte2.product_id, cte2.total_revenue, cte2.total_sales_volume, cte2.revenue_per_unit, cte3.sales_volume_rank, cte3.total_revenue, cte3.total_sales_volume, cte3.revenue_per_unit
from cte2 inner join cte3
on cte2.product_id = cte3.product_id
where cte2.revenue_rank <= 10 and cte3.sales_volume_rank <= 10


---------------------------------------------------------------------------------------------------
--Which product categories generate the highest total revenue and sales volume?

;with cte as (
select p.product_category_name, sum(oi.price) as total_revenue, count(oi.order_id) as total_sales_volume
from [dbo].[olist_products_dataset] as p inner join [dbo].[olist_order_items_dataset] as oi
on p.product_id = oi.product_id
group by p.product_category_name

),
cte2 as (
select *, ROW_NUMBER() over (order by total_revenue desc) as revenue_rank
from cte
),
cte3 as (
select *, ROW_NUMBER() over (order by total_sales_volume desc) as sales_volume_rank
from cte2
)
select cte2.revenue_rank, cte2.product_category_name, cte2.total_revenue, cte2.total_sales_volume, cte3.sales_volume_rank, cte3.total_revenue, cte3.total_sales_volume
from cte2 inner join cte3
on cte2.product_category_name = cte3.product_category_name
where cte2.revenue_rank <= 10 and cte3.sales_volume_rank <= 10


------------------------------------------------------------------------

--Which product categories have the highest average selling price per unit?


select top 1 p.product_category_name, cast(sum(oi.price) as decimal(12,2)) / count(oi.order_id) as average_selling_price_per_unit
from [dbo].[olist_products_dataset] as p inner join [dbo].[olist_order_items_dataset] as oi
on p.product_id = oi.product_i
group by product_category_named
order by average_selling_price_per_unit desc

----------------------------------------------------------------------------

--Which product categories have a high average selling price but relatively low sales volume?


;with cte as (
select p.product_category_name,sum(oi.price) as total_sale, count(oi.order_id) as sales_volumn, cast(sum(oi.price) as decimal(12,2)) / count(oi.order_id) as average_selling_price_per_category
from [dbo].[olist_products_dataset] as p inner join [dbo].[olist_order_items_dataset] as oi
on p.product_id = oi.product_id
group by product_category_name
),
cte2 as (
select *,
ROW_NUMBER() over (order by average_selling_price_per_category desc) as average_rank
from cte
),
cte3 as (
select *,
ROW_NUMBER() over (order by sales_volumn asc) as sale_volumn_rank
from cte2
)
select product_category_name, total_sale, average_selling_price_per_category, sales_volumn, average_rank, sale_volumn_rank
from cte3


---------------------------------------------------------------------------------------------------


--Which product categories have a high average selling price while also having enough sales volume to make the result meaningful?

;with cte as (
select p.product_category_name,sum(oi.price) as total_sale, count(oi.order_id) as sales_volumn, cast(sum(oi.price) as decimal(12,2)) / count(oi.order_id) as average_selling_price_per_category
from [dbo].[olist_products_dataset] as p inner join [dbo].[olist_order_items_dataset] as oi
on p.product_id = oi.product_id
group by product_category_name
having count(oi.order_id) >= 100
),
cte2 as (
select *,
ROW_NUMBER() over (order by average_selling_price_per_category desc) as average_rank
from cte
),
cte3 as (
select *,
ROW_NUMBER() over (order by sales_volumn desc) as sale_volumn_rank
from cte2
)
select product_category_name, total_sale, average_selling_price_per_category, sales_volumn, average_rank, sale_volumn_rank
from cte3
-----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
