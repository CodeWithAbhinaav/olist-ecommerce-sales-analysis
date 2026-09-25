# Olist E-Commerce Sales Analysis

A SQL Server-based e-commerce analytics project using the Brazilian Olist dataset to analyze sales, customers, products, sellers, delivery performance, and time-based business trends.

## Project Overview

This project was built to practice and demonstrate practical SQL analytics using a relational e-commerce dataset.

The analysis focuses on turning raw transactional data into business-oriented insights using:

* SQL Server
* SSMS
* Relational joins
* Aggregations
* CTEs
* Window functions
* Ranking
* Date and time analysis
* Data validation
* Business metrics
* Analytical debugging

The project was developed as an internship-focused SQL analytics project, with emphasis on understanding **data grain, relationships, business logic, and validation**, rather than only writing queries that execute successfully.

---

## Dataset

The project uses the **Brazilian Olist E-Commerce dataset**.

The main tables used are:

| Table                       | Description                      | Grain                       |
| --------------------------- | -------------------------------- | --------------------------- |
| `olist_customers_dataset`   | Customer information             | Customer/order relationship |
| `olist_orders_dataset`      | Order information and timestamps | One row per order           |
| `olist_order_items_dataset` | Products included in orders      | One row per order item      |
| `olist_products_dataset`    | Product information              | One row per product         |
| `olist_sellers_dataset`     | Seller information               | One row per seller          |

### Main relationships

```text
Customers
    │
    │ customer_id
    ▼
Orders
    │
    │ order_id
    ▼
Order Items
   │       │
   │       └──────────► Sellers
   │
   └──────────────────► Products
```

---

## Business Areas Analyzed

### 1. Data Exploration

Initial exploration of:

* Table sizes
* Columns
* Data structure
* Basic distributions
* Identifiers
* Missing values
* Data relationships

### 2. Data Validation

Validation of:

* Row counts
* NULL values
* Customer identifiers
* Order/item grain
* Date relationships
* Delivery chronology
* Analytical assumptions

### 3. Sales Analysis

Analysis of:

* Product sales
* Revenue
* Order volume
* Average values
* Monthly performance
* Sales trends

### 4. Customer Analysis

Analysis of:

* Unique customers
* Orders per customer
* Repeat customers
* One-time customers
* Customer spending
* Customer revenue contribution
* Geographic distribution

An important part of this analysis was understanding the difference between:

```text
customer_id
```

and:

```text
customer_unique_id
```

`customer_id` is associated with orders, while `customer_unique_id` was used to identify customers across multiple orders.

### 5. Product Analysis

Analysis of:

* Product revenue
* Product sales volume
* Average selling price
* Product categories
* Top-performing products
* Category performance
* Product data quality

### 6. Seller Analysis

Analysis of:

* Seller revenue
* Seller sales volume
* Average selling price
* Revenue per order
* Seller ranking
* Revenue concentration
* Seller performance segmentation

### 7. Delivery Analysis

Analysis of:

* Delivery duration
* Average delivery time
* Late vs on-time delivery
* Early deliveries
* Delivery performance by state
* Difference between actual and estimated delivery dates

### 8. Advanced Analysis

Time-based and comparative analysis including:

* Monthly revenue
* Month-over-month growth
* Monthly revenue increases and declines
* Year-over-year trends
* Customer-type revenue contribution
* Category-level monthly performance

---

## SQL Techniques Used

### SQL Fundamentals

* `SELECT`
* `WHERE`
* `DISTINCT`
* `TOP`
* `ORDER BY`
* `CASE`

### Aggregation

* `COUNT()`
* `COUNT(DISTINCT ...)`
* `SUM()`
* `AVG()`
* `MIN()`
* `MAX()`
* `GROUP BY`
* `HAVING`

### Joins

* `INNER JOIN`
* Multi-table joins
* Foreign-key relationships
* Join-grain validation

### CTEs

Used Common Table Expressions to break complex analytical queries into logical steps.

### Window Functions

Used:

* `COUNT() OVER()`
* `SUM() OVER()`
* `ROW_NUMBER()`
* `DENSE_RANK()`
* `NTILE()`
* `LAG()`

### Date Functions

Used:

* `YEAR()`
* `MONTH()`
* `DATEDIFF()`
* `DATEFROMPARTS()`
* `DATEADD()`

### Data Quality & Safe Calculations

Used:

* `NULL` checks
* `CAST()`
* `NULLIF()`
* Date validation
* Chronology checks
* Percentage calculations

---

## Key Analytical Lessons

### 1. Data grain matters

Different tables represent different levels of data.

For example:

```text
Orders       → order-level
Order Items  → item-level
Products     → product-level
Customers    → customer-level
Sellers      → seller-level
```

Understanding the grain prevents incorrect counts and revenue calculations.

### 2. Customer identifiers are not interchangeable

The project demonstrated why `customer_id` and `customer_unique_id` should not automatically be treated as the same identifier.

### 3. COUNT(order_id) is not always order count

When working with the order-items table:

```sql
COUNT(order_id)
```

counts item records.

For unique orders:

```sql
COUNT(DISTINCT order_id)
```

is required.

### 4. SQL execution does not guarantee analytical correctness

Several parts of the project required validating unexpected results and checking whether the SQL logic matched the intended business question.

### 5. Time-series analysis requires calendar awareness

A simple `LAG()` approach can compare against the previous available row rather than the previous calendar month when months are missing.

The project therefore used calendar-aware date matching for the final MoM approach.

---

## Project Structure

```text
Olist E-Commerce Sales Analysis/
│
├── 00. Project Overview/
│
├── 01. SQL/
│   ├── 01. Data Exploration/
│   ├── 02. Data Validation/
│   ├── 03. Sales Analysis/
│   ├── 04. Customer Analysis/
│   ├── 05. Product Analysis/
│   ├── 06. Seller Analysis/
│   ├── 07. Delivery Analysis/
│   └── 08. Advanced Analysis/
│
├── 02. Documentation/
│   ├── Data Dictionary/
│   ├── Business Questions/
│   ├── Findings/
│   └── Learning Notes/
│
├── 03. Dataset/
│   └── Raw/
│
├── 04. Project Progress/
│   ├── Progress Log.md
│   ├── Problems & Debugging.md
│   └── SQL Skills Tracker.md
│
└── 05. Final Deliverables/
    ├── Final SQL Scripts/
    ├── README.md
    └── Portfolio Decision.md
```

---

## What I Learned

This project helped me move beyond basic SQL syntax toward practical analytical SQL.

The main areas of learning were:

* Understanding relational data
* Understanding table grain
* Building multi-table joins
* Creating business metrics
* Using CTEs for complex analysis
* Applying window functions
* Performing ranking and segmentation
* Working with dates and time series
* Validating analytical results
* Debugging unexpected SQL outputs
* Translating business questions into SQL
* Explaining analytical results in business terms

---

## Current Skill Level Demonstrated

This project demonstrates a **practical analytical SQL foundation** using SQL Server.

I can demonstrate experience with:

* Relational data analysis
* Aggregations
* Joins
* CTEs
* Window functions
* Ranking
* Time-series analysis
* Data validation
* SQL debugging
* Business-oriented analysis

Areas such as query optimization, execution plans, indexing, and deeper SQL performance tuning are **not the primary focus of this project and require further practice**.

---

## Tools

* **SQL Server**
* **SQL Server Management Studio (SSMS)**
* **Git / GitHub** for project versioning and portfolio presentation

---

## Project Status

**Status:** Analysis and documentation completed; final packaging in progress.

The analytical SQL, documentation, validation notes, learning notes, and project progress tracking have been completed.

Remaining portfolio work:

* Final SQL packaging
* README
* Portfolio decision
* GitHub preparation

---

## Author

**Abhinav Yadav**

B.Tech CSE (AI & ML)

Focused on building practical skills in:

* SQL & Data Analytics
* Python
* Machine Learning
* Power BI
* AI/ML Applications
