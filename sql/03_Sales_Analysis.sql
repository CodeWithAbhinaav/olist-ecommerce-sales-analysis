SELECT
    YEAR(o.order_purchase_timestamp) AS order_year,
    MONTH(o.order_purchase_timestamp) AS order_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.price) AS product_sales,
    SUM(oi.freight_value) AS freight_value
FROM olist_orders_dataset AS o
INNER JOIN olist_order_items_dataset AS oi
    ON o.order_id = oi.order_id
GROUP BY
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp)
ORDER BY
    order_year,
    order_month;


    SELECT TOP 1 * FROM [dbo].[olist_customers_dataset]
    SELECT TOP 1 * FROM [dbo].[olist_order_items_dataset]
    SELECT TOP 1 * FROM [dbo].[olist_orders_dataset]
    ON O.ORDER_ID = OI.ORDER_ID


    --"I want to understand how our sales are performing month by month."

    SELECT
    YEAR(o.order_purchase_timestamp) AS order_year,
    MONTH(o.order_purchase_timestamp) AS order_month,
    COUNT(DISTINCT O.ORDER_ID) AS TOTAL_ORDERS,
    SUM(OI.PRICE) AS PRODUCT_SALES,
    SUM(OI.FREIGHT_VALUE) AS FREIGHT_VALUE
    FROM [dbo].[olist_orders_dataset] AS O
    INNER JOIN [dbo].[olist_order_items_dataset] AS OI
    ON O.ORDER_ID = OI.ORDER_ID
    GROUP BY YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp)
    ORDER BY  YEAR(o.order_purchase_timestamp) ,
    MONTH(o.order_purchase_timestamp)


    --"Okay, sales are changing every month. But how fast are they growing or declining compared with the previous month?"

    ;WITH MonthlySales AS (
    SELECT 
    YEAR(o.order_purchase_timestamp) AS order_year,
    MONTH(o.order_purchase_timestamp) AS order_month,
    SUM(OI.PRICE) AS product_sales,
    LAG(SUM(OI.PRICE)) OVER (PARTITION BY YEAR(o.order_purchase_timestamp) ORDER BY MONTH(o.order_purchase_timestamp)) AS previous_month_sales
    FROM [dbo].[olist_orders_dataset] AS O
    INNER JOIN [dbo].[olist_order_items_dataset] AS OI
    ON O.ORDER_ID = OI.ORDER_ID
    GROUP BY MONTH(o.order_purchase_timestamp), YEAR(o.order_purchase_timestamp)
    )
,SalesGrowth AS (
    SELECT order_year, order_month, product_sales,  previous_month_sales,
     ( (Product_sales - previous_month_sales)/ PREVIOUS_MONTH_SALES) * 100 AS sales_growth_percentage
    FROM MonthlySales 
    )
    SELECT * FROM SalesGrowth;
    

    SELECT
    ((120000.0 - 100000.0) / 100000.0) * 100 AS growth_percentage;

    SELECT
    ((120000.0 - 100000.0) / 100000.0) * 100 AS growth_percentage;


    
    ;WITH MonthlySales AS (
    
    SELECT DATEFROMPARTS(
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp),
    1
    ) AS SALES_MONTH,
    SUM(OI.PRICE) AS product_sales,
    LAG(SUM(OI.PRICE)) OVER (PARTITION BY YEAR(o.order_purchase_timestamp) ORDER BY MONTH(o.order_purchase_timestamp)) AS previous_month_sales
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
    
    SELECT DATEFROMPARTS(
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp),
    1
    ) AS SALES_MONTH
    FROM [dbo].[olist_orders_dataset] AS O
    WHERE o.order_purchase_timestamp IS NOT NULL;


    
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

-------------------------------------------------------------------------------


--restructure the CTE into two stages


;WITH MonthlySales AS (
    
    SELECT DATEFROMPARTS(
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp),
    1
    ) AS SALES_MONTH,
    SUM(OI.PRICE) AS product_sales
    FROM [dbo].[olist_orders_dataset] AS O
    INNER JOIN [dbo].[olist_order_items_dataset] AS OI
    ON O.ORDER_ID = OI.ORDER_ID
    GROUP BY DATEFROMPARTS(
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp),
    1)
    )
   ,SalesGrowth AS (
    SELECT *
    ,LAG(product_sales) OVER (ORDER BY SALES_MONTH) AS previous_month_sales
    FROM MonthlySales 
    )
    SELECT SALES_MONTH, product_sales,  previous_month_sales,
     ( (Product_sales - previous_month_sales)/ PREVIOUS_MONTH_SALES) * 100 AS sales_growth_percentage
     FROM SalesGrowth;

    ---------------------------------------------------------------------------------------------------



    --"Which 5 months had the strongest positive month-over-month sales growth?"



    ;WITH MonthlySales AS (
    
    SELECT DATEFROMPARTS(
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp),
    1
    ) AS SALES_MONTH,
    SUM(OI.PRICE) AS product_sales
    FROM [dbo].[olist_orders_dataset] AS O
    INNER JOIN [dbo].[olist_order_items_dataset] AS OI
    ON O.ORDER_ID = OI.ORDER_ID
    GROUP BY DATEFROMPARTS(
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp),
    1)
    )
   ,SalesGrowth AS (
    SELECT F.SALES_MONTH, F.product_sales, E.product_sales AS previous_month_sales,
    F.PRODUCT_SALES - E.PRODUCT_SALES AS sales_difference, 
    ROUND( ( (F.Product_sales - E.product_sales)/ E.product_sales) * 100,2) AS sales_growth_percentage
    FROM MonthlySales AS F LEFT JOIN MonthlySales AS E
    ON E.SALES_MONTH = DATEADD(month, -1, F.SALES_MONTH)
    )
    SELECT TOP 5 * FROM SalesGrowth
    WHERE sales_growth_percentage > 0 AND sales_growth_percentage IS NOT NULL
    ORDER BY sales_growth_percentage DESC;



    --, FinalSalesGrowth AS (
    --SELECT SALES_MONTH, product_sales,  previous_month_sales,
    -- ( (Product_sales - previous_month_sales)/ PREVIOUS_MONTH_SALES) * 100 AS sales_growth_percentage
    -- FROM SalesGrowth
    -- )
    -- SELECT *
    -- FROM  FinalSalesGrowth AS F LEFT JOIN  FinalSalesGrowth AS E
    -- ON  E.SALES_MONTH = DATEADD(month, -1, F.SALES_MONTH)





--"Which 5 months generated the largest increase in sales compared with the previous calendar month?"


       ;WITH MonthlySales AS (
    
    SELECT DATEFROMPARTS(
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp),
    1
    ) AS SALES_MONTH,
    SUM(OI.PRICE) AS product_sales
    FROM [dbo].[olist_orders_dataset] AS O
    INNER JOIN [dbo].[olist_order_items_dataset] AS OI
    ON O.ORDER_ID = OI.ORDER_ID
    GROUP BY DATEFROMPARTS(
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp),
    1)
    )
   ,SalesGrowth AS (
    SELECT F.SALES_MONTH, F.product_sales, E.product_sales AS previous_month_sales,
    F.PRODUCT_SALES - E.product_sales AS sales_difference, 
    ROUND( ( (F.Product_sales - E.product_sales)/ E.product_sales) * 100,2) AS sales_growth_percentage
    FROM MonthlySales AS F LEFT JOIN MonthlySales AS E
    ON E.SALES_MONTH = DATEADD(month, -1, F.SALES_MONTH)
    )
    SELECT TOP 5 * FROM SalesGrowth
    WHERE sales_difference > 0 
    ORDER BY sales_difference DESC;



    --"Which months generated the most sales overall?"


          ;WITH MonthlySales AS (
    
    SELECT DATEFROMPARTS(
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp),
    1
    ) AS SALES_MONTH,
    SUM(OI.PRICE) AS product_sales
    FROM [dbo].[olist_orders_dataset] AS O
    INNER JOIN [dbo].[olist_order_items_dataset] AS OI
    ON O.ORDER_ID = OI.ORDER_ID
    GROUP BY DATEFROMPARTS(
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp),
    1)
    )
SELECT TOP 5 SALES_MONTH, PRODUCT_SALES
FROM MonthlySales
ORDER BY PRODUCT_SALES DESC;





