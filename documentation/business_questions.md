# Olist E-Commerce Sales Analysis — Business Questions

## Purpose

This document defines the business questions investigated in the Olist E-Commerce Sales Analysis project.

The questions are organized from basic sales analysis to deeper customer, product, seller, delivery, and business-level analysis.

---

# 1. Sales Analysis

### Monthly Sales

- What are the monthly product sales?
- How does revenue change over time?

### Monthly Order Volume

- How many orders are placed each month?
- How does order volume change over time?

### Average Order Value

- What is the average order value?
- How does average order value vary across different periods?

### Sales Growth

- Are sales growing or declining?
- What is the month-over-month sales growth?
- Which months experienced the highest positive growth?
- Which months experienced the largest decline?

### Highest and Lowest Sales Periods

- Which month generated the highest sales?
- Which month generated the lowest sales?
- Which periods experienced significant changes in sales?

---

# 2. Customer Analysis

### Customers by State

- How many customers are present in each state?
- Which states have the highest customer concentration?

### Customer Cities

- Which cities have the highest number of customers?

### Repeat Customers

- How many customers have placed more than one order?
- How many customers placed only one order?

### Orders per Customer

- How many orders does each customer place?
- What is the average number of orders per customer?

### Customer Purchasing Behavior

- Which customers generate the highest revenue?
- How much revenue comes from repeat customers?
- How much revenue comes from one-time customers?
- What proportion of revenue is contributed by each customer type?

---

# 3. Product Analysis

### Top-Selling Products

- Which products have the highest sales volume?
- Which products are ordered most frequently?

### Highest-Revenue Products

- Which products generate the highest revenue?

### Average Product Price

- What is the average selling price of products?
- How does selling price vary across products?

### Sales by Category

- Which product categories generate the most revenue?
- Which categories have the highest sales volume?

### Product Category Performance

- Which categories perform strongly in terms of revenue?
- Which categories have relatively high sales volume but lower revenue?
- How does category performance change over time?

---

# 4. Seller Analysis

### Top Sellers

- Which sellers generate the highest revenue?
- Which sellers have the highest order volume?

### Seller Revenue

- How much revenue does each seller generate?
- How concentrated is revenue among sellers?

### Seller Order Volume

- How many unique orders does each seller serve?
- Which sellers handle the highest number of orders?

### Average Selling Price by Seller

- What is the average selling price for each seller?
- How does seller pricing differ?

### Seller Performance

- Which sellers generate high revenue with relatively low order volume?
- Which sellers generate high order volume?
- Are revenue and order volume distributed similarly across sellers?

---

# 5. Delivery Analysis

### Average Delivery Time

- How many days does it take to deliver an order?
- What is the average delivery time?

### Estimated vs Actual Delivery

- How does actual delivery compare with the estimated delivery date?
- How many days early or late are orders delivered?

### Late Delivery Rate

- What percentage of delivered orders are late?
- What percentage are delivered on time or early?

### Delivery Performance by State

- Which states have better delivery performance?
- Which states have higher late-delivery rates?
- Which states have longer average delivery times?

### Delivery Performance by Seller / Category

- Which sellers have stronger or weaker delivery performance?
- Which product categories are associated with delivery delays?

---

# 6. Advanced Business Analysis

### Revenue Trends

- Are sales growing over time?
- Which months have the strongest revenue growth?
- Which months experience the largest declines?

### Month-over-Month Analysis

- What is the revenue change compared with the previous calendar month?
- Which months have the highest positive month-over-month growth?
- Which months have the largest negative month-over-month growth?

### Year-over-Year Analysis

- How does revenue change compared with the same period in the previous year?
- Which periods show the strongest year-over-year growth?
- Which periods show the largest year-over-year decline?

### Customer Revenue Contribution

- How much revenue is contributed by repeat customers?
- How much revenue is contributed by one-time customers?
- What percentage of total revenue comes from each customer type?

### Category Revenue Trends

- Which product categories generate the most revenue?
- How does category revenue change month over month?
- Which categories show strong or weak revenue growth?

---

# 7. Business-Level Questions

The analysis ultimately aims to answer broader business questions such as:

> Which product categories generate the most revenue?

> Which states generate the most sales?

> Which sellers contribute the most revenue?

> Are sales growing?

> Are customers returning?

> Which categories have high sales but poor delivery performance?

> Where should the business focus its attention?

---

# 8. Analysis Workflow

For each business question, the analysis follows this process:

Business Question
↓
Required Tables
↓
Required Columns
↓
Table Relationships
↓
Aggregation Level
↓
SQL Approach
↓
Validation
↓
Business Interpretation

---

# 9. Key Analytical Principles

### Correct Grain

Always identify the grain of the tables before calculating metrics.

### Correct Aggregation

Distinguish between:

- Orders
- Order items
- Customers
- Products
- Sellers

For order counts, use unique orders where appropriate:

`COUNT(DISTINCT order_id)`

### Validation

Unexpected results should be investigated before changing the query.

### Business Relevance

The objective is not to write complicated SQL.

The objective is:

**Correct + Understandable + Business Useful**