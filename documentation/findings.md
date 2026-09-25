# Olist E-Commerce Sales Analysis — Key Findings

## 1. Executive Summary

This project analyzes the Brazilian Olist e-commerce dataset using SQL Server.

The analysis covers:

- Sales performance
- Customer behavior
- Product performance
- Seller performance
- Delivery performance
- Time-based revenue trends
- Data validation and analytical quality checks

The main analytical focus was understanding how revenue, customers, products, sellers, and delivery performance behave across the Olist marketplace.

> **Note:** This document records findings supported by the completed analysis. Where an exact result was not retained in the project notes, it is not invented here.

---

# 2. Dataset & Data Quality Findings

## 2.1 Core Dataset Size

The main tables used in the analysis contain:

| Table | Records |
|---|---:|
| `olist_customers_dataset` | 99,441 |
| `olist_orders_dataset` | 99,441 |
| `olist_order_items_dataset` | 112,650 |
| `olist_products_dataset` | 32,951 |

The order and customer tables contain 99,441 records, while the order-items table contains 112,650 records because one order can contain multiple items.

## 2.2 Customer Identifier Finding

A key distinction was identified between:

- `customer_id`
- `customer_unique_id`

`customer_id` is used to connect orders with customer records, while `customer_unique_id` identifies the actual customer across multiple orders.

Therefore, `customer_unique_id` is the appropriate identifier for repeat-customer analysis.

## 2.3 Order vs Order-Item Grain

`olist_orders_dataset` has order-level grain:

> 1 row = 1 order

`olist_order_items_dataset` has item-level grain:

> 1 row = 1 item within an order

Therefore, counting rows in `olist_order_items_dataset` does not necessarily equal counting unique orders.

For unique-order analysis, `COUNT(DISTINCT order_id)` is required.

---

# 3. Sales Performance

## 3.1 Sales Analysis Scope

Sales analysis examined:

- Monthly product revenue
- Monthly order activity
- Revenue by city
- Customer-level sales
- Sales per customer
- Average revenue per order
- Time-based revenue movement

Revenue analysis primarily uses:

```text
SUM(price)
```

from `olist_order_items_dataset`.

## 3.2 Revenue Measurement

The project distinguishes between:

- Product revenue → `SUM(price)`
- Freight value → `SUM(freight_value)`
- Product value plus freight → `SUM(price + freight_value)`

This distinction prevents freight from being incorrectly treated as product revenue.

## 3.3 Time-Based Sales

Monthly and yearly revenue analysis was used to identify:

- Revenue trends
- Month-over-month growth
- Month-over-month decline
- Absolute revenue increases
- Year-over-year growth
- Year-over-year decline

The advanced analysis compares a month with the **previous calendar month**, rather than simply comparing the previous available row. This matters because the dataset contains periods where a calendar month is missing.

> Exact monthly and yearly values should be added from the executed result tables if they are needed for the final portfolio version.

---

# 4. Customer Analysis

## 4.1 Customer Base

The analysis identified:

- **96,096 unique customers with orders**
- **2,997 repeat customers**
- **93,099 one-time customers**

Average orders per customer:

**1.0348089410589 orders/customer**

This shows that the large majority of customers placed only one order in the analyzed dataset.

## 4.2 Repeat vs One-Time Customers

The repeat-customer analysis was based on `customer_unique_id`, rather than `customer_id`.

The results show a substantially larger one-time customer group than repeat-customer group.

This makes customer retention and repeat purchasing an important area for further business analysis.

## 4.3 Customer Spending

The project also analyzed:

- Highest-spending customers
- Average customer revenue
- Average order value
- Revenue by order frequency
- Revenue contribution from repeat vs one-time customers

These analyses help distinguish customer volume from customer value.

## 4.4 Geographic Customer Analysis

Customer analysis examined:

- Customers by state
- Customers by city
- Top cities by unique customer count
- Sales per customer by geography

This allows customer concentration to be evaluated geographically rather than only at the overall marketplace level.

---

# 5. Product Analysis

## 5.1 Product Dataset

The product table contains:

**32,951 product records**

The validation analysis found:

- **32,341 products with a category**
- **610 products without a category**
- **32,949 products with weight**
- **2 products without weight**

These missing values were identified as part of product data-quality exploration.

## 5.2 Product Revenue vs Sales Volume

Product analysis compared:

- Total revenue
- Sales volume
- Revenue per unit

The analysis demonstrates that sales volume and revenue are separate dimensions of product performance.

A product can have high sales volume without being among the highest-revenue products, while products with higher revenue per unit can generate substantial revenue with lower volume.

## 5.3 Product Category Performance

Product categories were analyzed using:

- Total revenue
- Sales volume
- Average selling price
- Revenue rank
- Sales-volume rank

The analysis also separated categories with high average selling prices from categories with sufficient sales volume to make the comparison more meaningful.

## 5.4 Analytical Lesson

Product performance should not be evaluated using a single metric.

The project therefore considers:

```text
Revenue
+
Sales Volume
+
Revenue per Unit
+
Average Selling Price
```

rather than relying only on total sales.

---

# 6. Seller Analysis

## 6.1 Seller Revenue

Seller analysis compared:

- Total revenue
- Sales volume
- Average selling price
- Unique orders
- Revenue per order

This showed that seller revenue and seller volume do not necessarily move together.

## 6.2 Average Selling Price

Sellers were evaluated using average selling price per item.

A minimum sales-volume threshold was used in the relevant analysis so that sellers with very few transactions would not dominate the comparison simply because of a small sample.

## 6.3 Revenue per Order

For seller-level order analysis, the project uses:

```text
Revenue per Order =
Total Revenue / COUNT(DISTINCT order_id)
```

This avoids treating multiple items from the same order as multiple orders.

## 6.4 Revenue Concentration

The analysis also examined the contribution of high-revenue sellers to total seller revenue.

Seller ranking was combined with revenue contribution to understand marketplace concentration rather than looking only at absolute revenue.

## 6.5 High-Revenue / Lower-Volume Sellers

The final seller analysis used revenue and unique-order groups to identify sellers with high revenue but relatively lower order volume.

This highlights the difference between:

- high transaction volume
- high-value transactions

---

# 7. Delivery Performance

## 7.1 Delivery Time

Delivery time was calculated using:

```text
Order Delivered Customer Date
-
Order Purchase Timestamp
```

The analysis measured delivery duration for delivered orders.

## 7.2 Late vs On-Time Delivery

Delivered orders were classified as:

- Early
- On time
- Late

The classification compares:

```text
Actual Delivery Date
vs
Estimated Delivery Date
```

## 7.3 Delivery Difference

Delivery difference was calculated as:

```text
Actual Delivery Date
-
Estimated Delivery Date
```

Interpretation:

- Negative → delivered early
- Zero → delivered on the estimated date
- Positive → delivered late

## 7.4 Geographic Delivery Performance

Delivery performance was analyzed by customer state using:

- Average delivery difference
- Percentage of late deliveries
- Average delivery time

This makes it possible to identify geographic differences in delivery performance.

## 7.5 Delivery Validation

The project also checked for:

- Delivered orders with missing actual delivery dates
- Delivered orders with missing estimated delivery dates
- Delivered orders where the delivery date occurred before the purchase date

These checks help identify potentially invalid or incomplete delivery records.

---

# 8. Advanced Time-Based Analysis

## 8.1 Monthly Revenue Movement

Monthly revenue was analyzed using calendar-month comparisons.

The analysis identified:

- Highest-revenue month
- Highest positive MoM growth
- Largest MoM decline
- Highest absolute MoM revenue increase

## 8.2 Yearly Revenue Movement

Yearly revenue was analyzed using year-over-year comparisons.

The analysis identified:

- Yearly revenue trend
- Highest positive YoY growth
- Largest negative YoY growth

## 8.3 Why Calendar-Aware Comparison Matters

The monthly growth analysis uses the actual previous calendar month rather than simply using the previous available observation.

This is important because a missing calendar month should not automatically be treated as the previous month.

For example:

```text
Month A
↓
Missing Month
↓
Month C
```

Month C should not be treated as directly following Month A when calculating MoM growth.

---

# 9. Overall Analytical Insights

## 9.1 Customer Behavior

The customer analysis shows a strong difference between one-time and repeat customers.

The dataset contains:

- 2,997 repeat customers
- 93,099 one-time customers

This makes customer retention and repeat purchasing an important dimension of marketplace performance.

## 9.2 Revenue Is Multi-Dimensional

Revenue should not be analyzed independently of:

- Order volume
- Customer frequency
- Product volume
- Seller volume
- Average selling price
- Revenue per order

The project therefore uses multiple measures to avoid misleading conclusions from a single metric.

## 9.3 Data Grain Matters

One of the most important technical findings from the project is the importance of understanding table grain.

Examples:

```text
Orders
1 row = 1 order

Order Items
1 row = 1 order item
```

This affects calculations such as order counts, seller volume, product volume, and revenue per order.

## 9.4 Data Validation Is Part of Analysis

The project did not treat SQL query execution as the end of analysis.

Validation was used to check:

- Customer identifiers
- Repeat-customer logic
- NULL delivery dates
- Delivery chronology
- Unique order counting
- Product missing values

This improves confidence in the analytical results.

---

# 10. Business Interpretation

Based on the completed analysis, the main areas that emerge for business attention are:

### Customer Retention
The difference between one-time and repeat customers makes repeat purchasing an important area for further investigation.

### Customer Value
Customer frequency and spending should be considered together rather than evaluating customers only by order count.

### Product Portfolio
Revenue, volume, and average selling price provide different views of product performance.

### Seller Performance
Seller revenue, order volume, and revenue per order should be considered together because high revenue does not necessarily imply the highest transaction volume.

### Delivery Performance
Delivery should be evaluated using both overall performance and geographic variation across customer states.

### Time-Based Performance
Monthly and yearly growth analysis helps identify periods of strong growth and decline and provides context for changes in overall revenue.

---

# 11. Key SQL Skills Demonstrated

This project demonstrates practical SQL Server skills including:

- SELECT and filtering
- INNER JOIN
- GROUP BY
- HAVING
- Aggregate functions
- COUNT and COUNT DISTINCT
- CASE statements
- Common Table Expressions (CTEs)
- Window functions
- ROW_NUMBER
- DENSE_RANK
- NTILE
- Date functions
- DATEFROMPARTS
- DATEADD
- DATEDIFF
- NULL handling
- Monthly analysis
- MoM growth
- YoY growth
- Ranking
- Revenue contribution
- Data validation
- Business-question-driven SQL

---

# 12. Final Takeaway

The Olist analysis demonstrates how raw relational e-commerce data can be transformed into business-oriented analysis using SQL.

The project goes beyond basic SELECT and GROUP BY queries by addressing:

```text
Data Understanding
        ↓
Data Validation
        ↓
Sales Analysis
        ↓
Customer Analysis
        ↓
Product Analysis
        ↓
Seller Analysis
        ↓
Delivery Analysis
        ↓
Advanced Time-Based Analysis
        ↓
Business Interpretation
```

The strongest technical lessons from the project are understanding table grain, choosing the correct customer identifier, distinguishing item-level records from unique orders, validating analytical assumptions, and translating business questions into SQL.
