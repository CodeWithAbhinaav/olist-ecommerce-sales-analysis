# Olist E-Commerce Sales Analysis — Learning Notes

## 1. Understanding Table Grain

One of the most important lessons from this project was understanding the grain of each table before writing SQL.

### Orders Table

One row represents one order.

### Order Items Table

One row represents one item within an order.

Therefore:

- `COUNT(*)` on order items counts item records.
- `COUNT(DISTINCT order_id)` counts unique orders.

This distinction is important when calculating order volume and seller performance.

### Products Table

One row represents one product.

### Customers Table

The table contains customer-level information, but `customer_id` and `customer_unique_id` serve different purposes.

---

## 2. Customer ID vs Customer Unique ID

`customer_id` is associated with an order and is useful for joining customers to orders.

`customer_unique_id` represents the actual customer across orders.

This distinction was important when identifying repeat customers.

A customer can have multiple orders, so using the correct identifier is necessary for customer-level analysis.

---

## 3. Understanding Table Relationships

The main relationships used in the project were:

customers
→ customer_id → orders
→ order_id → order_items

Additional relationships:

products
→ product_id → order_items

sellers
→ seller_id → order_items

Understanding these relationships made it easier to decide which tables were required for each business question.

---

## 4. Revenue Calculation

For product sales analysis, revenue was calculated using the product price from the order-item table.

A basic revenue calculation is:

`SUM(oi.price)`

The correct aggregation level must always be considered before calculating revenue.

---

## 5. GROUP BY and Aggregation

`GROUP BY` was used extensively to summarize data.

Examples included:

- Sales by month
- Customers by state
- Revenue by product
- Revenue by category
- Revenue by seller
- Delivery performance by state

A major lesson was that aggregation changes the number of rows available for further calculations.

---

## 6. Window Functions

Window functions were used for:

- Ranking
- Percentages
- Totals
- Growth analysis
- Customer analysis

An important lesson was that a window function operates on the result produced by the query at that stage.

For example, after grouping customers by order count:

`COUNT(*) OVER()`

counts the grouped rows, not the original customer records.

For a total across grouped values, an expression such as:

`SUM(COUNT(*)) OVER()`

may be required.

---

## 7. CTEs

Common Table Expressions were used to break complex analysis into logical steps.

Typical structure:

Raw Data  
↓  
CTE 1  
↓  
CTE 2  
↓  
Final Analysis

This made complex queries easier to understand and debug.

CTEs were particularly useful for:

- Monthly sales
- Customer segmentation
- Ranking
- Time-series analysis
- Seller analysis

---

## 8. Ranking Functions

Ranking functions were used to identify top-performing:

- Products
- Categories
- Sellers
- Customers

Different ranking functions have different behavior.

Examples:

`RANK()`

`DENSE_RANK()`

`ROW_NUMBER()`

`NTILE()`

The choice depends on the analytical question.

---

## 9. Average Selling Price

Revenue alone does not explain product or seller performance.

For example:

- High revenue can come from high sales volume.
- High revenue can also come from a higher selling price.

Therefore, average selling price was also analyzed.

A useful calculation is:

`SUM(price) / COUNT(...)`

The denominator must match the intended business definition.

---

## 10. COUNT vs COUNT(DISTINCT)

This was one of the important practical SQL lessons.

For example:

`COUNT(order_id)`

can count multiple item records belonging to the same order when used on the order-item table.

Where the business question asks for unique orders:

`COUNT(DISTINCT order_id)`

is required.

The correct function depends on the grain of the table.

---

## 11. Date and Time Analysis

Date functions were used throughout the project.

Important functions included:

- `YEAR()`
- `MONTH()`
- `DATEFROMPARTS()`
- `DATEADD()`
- `DATEDIFF()`

These were used for:

- Monthly sales
- Monthly growth
- Year-over-year analysis
- Delivery time
- Delivery delays

---

## 12. Delivery Analysis

Delivery analysis required comparing:

- Purchase date
- Actual delivery date
- Estimated delivery date

`DATEDIFF()` was used to calculate delivery duration.

Delivery status was then classified using `CASE`.

The analysis included:

- Average delivery time
- Late delivery percentage
- Early/on-time/late delivery
- Difference between estimated and actual delivery
- State-level delivery performance

---

## 13. NULL Handling

NULL values were important in delivery and product analysis.

Before calculating metrics, NULL values needed to be understood rather than automatically treated as zero.

`NULLIF()` was also useful for protecting calculations from division by zero.

Example:

`NULLIF(denominator, 0)`

---

## 14. AND / OR Logic

Filtering conditions require careful logical reasoning.

For example:

`WHERE condition1 AND condition2`

means both conditions must be true.

Whereas:

`WHERE condition1 OR condition2`

requires at least one condition to be true.

Parentheses can be important when combining multiple conditions.

---

## 15. Data Validation

Analysis should not immediately be trusted just because the SQL executes successfully.

Validation checks were performed for:

- NULL delivery dates
- Invalid delivery chronology
- Missing product categories
- Missing product weights
- Unexpected calculations

An important lesson:

**A query can execute successfully and still produce a logically incorrect result.**

---

## 16. Integer Division

Percentage calculations can produce incorrect results when integer division occurs.

For example, when calculating revenue contribution, the numerator may need to be explicitly converted to a decimal value.

Example:

`CAST(total_revenue_by_type AS DECIMAL(18,2))
 / NULLIF(SUM(total_revenue_by_type) OVER(), 0) * 100`

Data types therefore matter in analytical calculations.

---

## 17. Month-over-Month Analysis

Month-over-month analysis compares a month with the previous calendar month.

An important discovery was that the dataset contains periods where a calendar month is missing.

A simple `LAG()` over existing rows can therefore compare against the previous available row rather than the previous calendar month.

For calendar-aware analysis, the previous month can instead be matched using:

`DATEADD(MONTH, -1, sales_month)`

This was an important time-series lesson from the project.

---

## 18. Year-over-Year Analysis

Year-over-year analysis compares a period with the corresponding period in the previous year.

This helps identify longer-term changes without relying only on month-to-month fluctuations.

The project used YoY analysis to study revenue trends.

---

## 19. Revenue vs Volume

Another important analytical lesson was that revenue and volume do not necessarily tell the same story.

A product, category, or seller can have:

- High volume but lower revenue per transaction
- Lower volume but higher revenue per transaction

Therefore, multiple metrics should be considered together.

---

## 20. Seller Analysis

Seller performance was analyzed using multiple dimensions:

- Revenue
- Unique orders
- Average selling price
- Revenue concentration
- Revenue vs volume

This showed why a single metric is often insufficient for evaluating business performance.

---

## 21. Customer Analysis

Customer analysis included:

- Customer concentration
- Repeat customers
- One-time customers
- Orders per customer
- Customer revenue
- Revenue contribution by customer type

The main lesson was to distinguish between customer count and customer purchasing behavior.

---

## 22. Business Question → SQL

A useful workflow developed during the project was:

Business Question  
↓  
Identify Required Metric  
↓  
Identify Required Tables  
↓  
Understand Table Grain  
↓  
Identify Join Keys  
↓  
Filter Data  
↓  
Aggregate  
↓  
Apply Analytical Logic  
↓  
Validate Result  
↓  
Interpret Business Meaning

This is more useful than simply trying to write SQL immediately.

---

## 23. Debugging Lessons

When a query produced an unexpected result, the debugging process was:

1. Check the table grain.
2. Check the joins.
3. Check filters.
4. Check aggregation.
5. Check NULL values.
6. Check data types.
7. Check calculations.
8. Compare intermediate results.
9. Validate the final output.

This helped separate SQL syntax problems from analytical logic problems.

---

## 24. Main Lessons From the Project

The most important lessons were:

- Understand table grain before querying.
- Understand relationships before joining tables.
- Distinguish orders from order items.
- Use the correct customer identifier.
- Use `COUNT(DISTINCT ...)` when uniqueness matters.
- Use CTEs to structure complex analysis.
- Use window functions carefully after aggregation.
- Validate calculations instead of trusting successful execution.
- Pay attention to NULL values.
- Pay attention to data types and integer division.
- Handle calendar dates carefully in time-series analysis.
- Look at multiple business metrics together.
- Translate SQL results into business meaning.

---

## 25. Overall Learning

This project moved SQL learning from isolated syntax practice toward practical analytical problem solving.

The main progression was:

SQL Syntax  
↓  
Joins  
↓  
Aggregation  
↓  
Business Questions  
↓  
Analytical SQL  
↓  
Validation  
↓  
Time-Series Analysis  
↓  
Business Interpretation

The project provided a practical foundation in analytical SQL using a real-world relational e-commerce dataset.