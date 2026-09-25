--Advanced Q1 — Monthly Revenue

--Business question:

--How does monthly sales revenue change over time?


   ;WITH MonthlySales AS (
    
    SELECT DATEFROMPARTS(
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp),
    1
    ) AS SALES_MONTH,
    SUM(OI.PRICE) AS product_sales,
    LAG(SUM(OI.PRICE)) OVER (ORDER BY YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp)) AS previous_month_sales
    FROM [dbo].[olist_orders_dataset] AS O
    INNER JOIN [dbo].[olist_order_items_dataset] AS OI
    ON O.ORDER_ID = OI.ORDER_ID
    GROUP BY MONTH(o.order_purchase_timestamp), YEAR(o.order_purchase_timestamp)
    )
,SalesGrowth AS (
    SELECT SALES_MONTH, product_sales,  previous_month_sales,
     ( (Product_sales - previous_month_sales)/ PREVIOUS_MONTH_SALES) * 100 AS sales_growth_percentage
    FROM MonthlySales 
    )
    SELECT * FROM SalesGrowth;
    -----------------------------------------------------
    
    SELECT DATEFROMPARTS(
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp),1) AS SALES_MONTH,
    SUM(OI.PRICE) AS PRODUST_SALES
     FROM [dbo].[olist_orders_dataset] AS O
    INNER JOIN [dbo].[olist_order_items_dataset] AS OI
    ON O.ORDER_ID = OI.ORDER_ID
    GROUP BY MONTH(o.order_purchase_timestamp), YEAR(o.order_purchase_timestamp)


    -------------------------------------------------------------
    ------------------------------------------------------------


;WITH MonthlySales AS (
    SELECT 
        DATEFROMPARTS(
            YEAR(o.order_purchase_timestamp),
            MONTH(o.order_purchase_timestamp),
            1
        ) AS sales_month,
        SUM(oi.price) AS product_sales
    FROM olist_orders_dataset AS o
    INNER JOIN olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    GROUP BY 
        YEAR(o.order_purchase_timestamp),
        MONTH(o.order_purchase_timestamp)

),
SalesGrowth AS (
    SELECT
        current_month.sales_month,
        current_month.product_sales,
        previous_month.product_sales AS previous_month_sales,
        CAST(
            (current_month.product_sales - previous_month.product_sales)
            AS DECIMAL(18,2)
        ) / NULLIF(previous_month.product_sales, 0) * 100
            AS sales_growth_percentage
    FROM MonthlySales AS current_month
    LEFT JOIN MonthlySales AS previous_month
        ON previous_month.sales_month =
           DATEADD(MONTH, -1, current_month.sales_month)
)
SELECT TOP 1
    sales_month,
    product_sales,
    previous_month_sales,
    sales_growth_percentage
FROM SalesGrowth
ORDER BY product_sales DESC; 

--------------------------------------------------------
----------------------------------------------------------

--Find the month with the highest positive MoM revenue growth.

;WITH MonthlySales AS (
    SELECT 
        DATEFROMPARTS(
            YEAR(o.order_purchase_timestamp),
            MONTH(o.order_purchase_timestamp),
            1
        ) AS sales_month,
        SUM(oi.price) AS product_sales
    FROM olist_orders_dataset AS o
    INNER JOIN olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    GROUP BY 
        YEAR(o.order_purchase_timestamp),
        MONTH(o.order_purchase_timestamp)

),
SalesGrowth AS (
    SELECT
        current_month.sales_month,
        current_month.product_sales,
        previous_month.product_sales AS previous_month_sales,
        CAST(
            (current_month.product_sales - previous_month.product_sales)
            AS DECIMAL(18,2)
        ) / NULLIF(previous_month.product_sales, 0) * 100
            AS sales_growth_percentage
    FROM MonthlySales AS current_month
    LEFT JOIN MonthlySales AS previous_month
        ON previous_month.sales_month =
           DATEADD(MONTH, -1, current_month.sales_month)
)
SELECT TOP 1
    sales_month,
    product_sales,
    previous_month_sales,
    sales_growth_percentage
FROM SalesGrowth
WHERE SALES_GROWTH_PERCENTAGE IS NOT NULL
AND SALES_GROWTH_PERCENTAGE >0
ORDER BY sales_growth_percentage DESC; 


-----------------------------------------------------
-----------------------------------------------------
--Advanced Q4 — Month with the highest revenue decline

--Next question:

--Which month experienced the largest month-over-month revenue decline?


;WITH MonthlySales AS (
    SELECT 
        DATEFROMPARTS(
            YEAR(o.order_purchase_timestamp),
            MONTH(o.order_purchase_timestamp),
            1
        ) AS sales_month,
        SUM(oi.price) AS product_sales
    FROM olist_orders_dataset AS o
    INNER JOIN olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    GROUP BY 
        YEAR(o.order_purchase_timestamp),
        MONTH(o.order_purchase_timestamp)

),
SalesGrowth AS (
    SELECT
        current_month.sales_month,
        current_month.product_sales,
        previous_month.product_sales AS previous_month_sales,
        CAST(
            (current_month.product_sales - previous_month.product_sales)
            AS DECIMAL(18,2)
        ) / NULLIF(previous_month.product_sales, 0) * 100
            AS sales_growth_percentage
    FROM MonthlySales AS current_month
    LEFT JOIN MonthlySales AS previous_month
        ON previous_month.sales_month =
           DATEADD(MONTH, -1, current_month.sales_month)
)
SELECT TOP 1
    sales_month,
    product_sales,
    previous_month_sales,
    sales_growth_percentage
FROM SalesGrowth
WHERE SALES_GROWTH_PERCENTAGE IS NOT NULL
AND SALES_GROWTH_PERCENTAGE < 0
ORDER BY sales_growth_percentage ASC; 


--------------------------------------------------
----------------------------------------------------
--Next — Advanced Q5

--Which month had the highest revenue growth in absolute amount, not percentage?



;WITH MonthlySales AS (
    SELECT 
        DATEFROMPARTS(
            YEAR(o.order_purchase_timestamp),
            MONTH(o.order_purchase_timestamp),
            1
        ) AS sales_month,
        SUM(oi.price) AS product_sales
    FROM olist_orders_dataset AS o
    INNER JOIN olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    GROUP BY 
        YEAR(o.order_purchase_timestamp),
        MONTH(o.order_purchase_timestamp)

),
SalesGrowth AS (
    SELECT
        current_month.sales_month,
        current_month.product_sales,
        previous_month.product_sales AS previous_month_sales,
        CAST(
            (current_month.product_sales - previous_month.product_sales)
            AS DECIMAL(18,2)
        ) / NULLIF(previous_month.product_sales, 0) * 100
            AS sales_growth_percentage
        ,(current_month.product_sales - previous_month.product_sales) AS GROWTH_IN_AMOUNT
    FROM MonthlySales AS current_month
    LEFT JOIN MonthlySales AS previous_month
        ON previous_month.sales_month =
           DATEADD(MONTH, -1, current_month.sales_month)
)
SELECT TOP 1
GROWTH_IN_AMOUNT,
    sales_month,
    product_sales,
    previous_month_sales,
    sales_growth_percentage
FROM SalesGrowth
WHERE SALES_GROWTH_PERCENTAGE IS NOT NULL
ORDER BY GROWTH_IN_AMOUNT DESC; 

------------------------------------
------------------------------------------------------------------
--Next: Advanced Q6 — Revenue trend by year
--Business question

--How did total revenue change year over year?

;WITH YEARLY_Sales AS (
    SELECT 
            YEAR(o.order_purchase_timestamp)
         AS sales_YEAR,
        SUM(oi.price) AS product_sales
    FROM olist_orders_dataset AS o
    INNER JOIN olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    GROUP BY 
        YEAR(o.order_purchase_timestamp)

),
SalesGrowth AS (
    SELECT
        current_YEAR.sales_YEAR,
        current_YEAR.product_sales,
        previous_YEAR.product_sales AS previous_YEAR_sales,
        CAST(
            (current_YEAR.product_sales - previous_YEAR.product_sales)
            AS DECIMAL(18,2)
        ) / NULLIF(previous_YEAR.product_sales, 0) * 100
            AS sales_growth_percentage
        ,(current_YEAR.product_sales - previous_YEAR.product_sales) AS GROWTH_IN_AMOUNT
    FROM YEARLY_Sales AS current_YEAR
    LEFT JOIN YEARLY_Sales AS previous_YEAR
        ON previous_YEAR.sales_YEAR = current_YEAR.sales_YEAR - 1
)
SELECT 
GROWTH_IN_AMOUNT,
    sales_YEAR,
    product_sales,
    previous_YEAR_sales,
    sales_growth_percentage
FROM SalesGrowth
WHERE SALES_GROWTH_PERCENTAGE IS NOT NULL
ORDER BY sales_YEAR; 

-------------------------------------------------
------------------------------------------------

--Q6 = Year-over-year revenue trend. Next we'll use this CTE to find the year with the highest YoY growth,

;WITH YEARLY_Sales AS (
    SELECT 
            YEAR(o.order_purchase_timestamp)
         AS sales_YEAR,
        SUM(oi.price) AS product_sales
    FROM olist_orders_dataset AS o
    INNER JOIN olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    GROUP BY 
        YEAR(o.order_purchase_timestamp)

),
SalesGrowth AS (
    SELECT
        current_YEAR.sales_YEAR,
        current_YEAR.product_sales,
        previous_YEAR.product_sales AS previous_YEAR_sales,
        CAST(
            (current_YEAR.product_sales - previous_YEAR.product_sales)
            AS DECIMAL(18,2)
        ) / NULLIF(previous_YEAR.product_sales, 0) * 100
            AS sales_growth_percentage
        ,(current_YEAR.product_sales - previous_YEAR.product_sales) AS GROWTH_IN_AMOUNT
    FROM YEARLY_Sales AS current_YEAR
    LEFT JOIN YEARLY_Sales AS previous_YEAR
        ON previous_YEAR.sales_YEAR = current_YEAR.sales_YEAR - 1
)
SELECT TOP 1
GROWTH_IN_AMOUNT,
    sales_YEAR,
    product_sales,
    previous_YEAR_sales,
    sales_growth_percentage
FROM SalesGrowth
WHERE SALES_GROWTH_PERCENTAGE IS NOT NULL
AND
SALES_GROWTH_PERCENTAGE > 0
ORDER BY SALES_GROWTH_PERCENTAGE DESC; 


----------------------------------------------------
-------------------------------------------------------

--Which year experienced the largest year-over-year revenue decline?


;WITH YEARLY_Sales AS (
    SELECT 
            YEAR(o.order_purchase_timestamp)
         AS sales_YEAR,
        SUM(oi.price) AS product_sales
    FROM olist_orders_dataset AS o
    INNER JOIN olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    GROUP BY 
        YEAR(o.order_purchase_timestamp)

),
SalesGrowth AS (
    SELECT
        current_YEAR.sales_YEAR,
        current_YEAR.product_sales,
        previous_YEAR.product_sales AS previous_YEAR_sales,
        CAST(
            (current_YEAR.product_sales - previous_YEAR.product_sales)
            AS DECIMAL(18,2)
        ) / NULLIF(previous_YEAR.product_sales, 0) * 100
            AS sales_growth_percentage
        ,(current_YEAR.product_sales - previous_YEAR.product_sales) AS GROWTH_IN_AMOUNT
    FROM YEARLY_Sales AS current_YEAR
    LEFT JOIN YEARLY_Sales AS previous_YEAR
        ON previous_YEAR.sales_YEAR = current_YEAR.sales_YEAR - 1
)
SELECT TOP 1
GROWTH_IN_AMOUNT,
    sales_YEAR,
    product_sales,
    previous_YEAR_sales,
    sales_growth_percentage
FROM SalesGrowth
WHERE SALES_GROWTH_PERCENTAGE IS NOT NULL
AND
SALES_GROWTH_PERCENTAGE < 0
ORDER BY SALES_GROWTH_PERCENTAGE ASC; 

----------------------------------------------------
--------------------------------------------------------------
--Q9 — Revenue contribution by customer type
--Business question:

--How much of total revenue comes from repeat customers vs one-time customers?


