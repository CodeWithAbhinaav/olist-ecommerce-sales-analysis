# Olist E-Commerce Sales Analysis — Data Dictionary

## 1. Dataset Overview

**Dataset:** Brazilian E-Commerce Public Dataset by Olist

**Purpose:** Document the main Olist tables and columns used in this SQL analysis project.

---

## 2. `olist_customers_dataset`

**Grain:** 1 row = 1 customer record

| Column | Description | Role in Project |
|---|---|---|
| `customer_id` | Identifier used to connect customer records with orders. | Join key |
| `customer_unique_id` | Unique identifier used to identify the actual customer across multiple orders. | Repeat-customer analysis |
| `customer_zip_code_prefix` | Customer ZIP/postal-code prefix. | Location |
| `customer_city` | Customer city. | Geographic analysis |
| `customer_state` | Customer state. | Geographic analysis |

**Key note:** `customer_unique_id` is used for repeat-customer analysis because one actual customer can be associated with multiple orders.

---

## 3. `olist_orders_dataset`

**Grain:** 1 row = 1 order

| Column | Description | Role in Project |
|---|---|---|
| `order_id` | Unique identifier for an order. | Order key |
| `customer_id` | Identifier connecting the order to the customer record. | Join with customers |
| `order_status` | Status of the order. | Filtering and validation |
| `order_purchase_timestamp` | Timestamp when the order was purchased. | Sales/time analysis |
| `order_approved_at` | Timestamp when the order/payment was approved. | Order timeline |
| `order_delivered_carrier_date` | Date the order was handed to the carrier. | Delivery analysis |
| `order_delivered_customer_date` | Date the order was delivered to the customer. | Delivery analysis |
| `order_estimated_delivery_date` | Estimated delivery date. | Delivery analysis |

---

## 4. `olist_order_items_dataset`

**Grain:** 1 row = 1 item within an order

| Column | Description | Role in Project |
|---|---|---|
| `order_id` | Identifier of the order containing the item. | Join with orders |
| `order_item_id` | Item number within an order. | Item-level identification |
| `product_id` | Identifier of the purchased product. | Join with products |
| `seller_id` | Identifier of the seller. | Join with sellers |
| `shipping_limit_date` | Date by which the seller should ship the item. | Shipping analysis |
| `price` | Price of the item. | Revenue analysis |
| `freight_value` | Freight/shipping value associated with the item. | Shipping/revenue analysis |

**Important:** This is an item-level table. `COUNT(*)` counts item records, while `COUNT(DISTINCT order_id)` counts unique orders.

---

## 5. `olist_products_dataset`

**Grain:** 1 row = 1 product

| Column | Description | Role in Project |
|---|---|---|
| `product_id` | Unique identifier for a product. | Join with order items |
| `product_category_name` | Product category name. | Product/category analysis |
| `product_name_lenght` | Length of the product name. | Product attribute |
| `product_description_lenght` | Length of the product description. | Product attribute |
| `product_photos_qty` | Number of product photos. | Product attribute |
| `product_weight_g` | Product weight in grams. | Product attribute |
| `product_length_cm` | Product length in centimeters. | Product attribute |
| `product_height_cm` | Product height in centimeters. | Product attribute |
| `product_width_cm` | Product width in centimeters. | Product attribute |

---

## 6. `olist_sellers_dataset`

**Grain:** 1 row = 1 seller

| Column | Description | Role in Project |
|---|---|---|
| `seller_id` | Unique identifier for a seller. | Seller key |
| `seller_zip_code_prefix` | Seller ZIP/postal-code prefix. | Location |
| `seller_city` | Seller city. | Seller location |
| `seller_state` | Seller state. | Seller location |

---

## 7. Table Relationships

```text
olist_customers_dataset
        |
        | customer_id
        v
olist_orders_dataset
        |
        | order_id
        v
olist_order_items_dataset
       /       /   product_id seller_id
   |           |
   v           v
olist_products_dataset    olist_sellers_dataset
```

| From Table | Key | To Table | Key | Purpose |
|---|---|---|---|---|
| Customers | `customer_id` | Orders | `customer_id` | Connect customers and orders |
| Orders | `order_id` | Order Items | `order_id` | Connect orders and purchased items |
| Products | `product_id` | Order Items | `product_id` | Connect products and sales |
| Sellers | `seller_id` | Order Items | `seller_id` | Connect sellers and sales |

---

## 8. Important Analytical Concepts

### Customer Identity

- `customer_id` connects an order to a customer record.
- `customer_unique_id` identifies the actual customer across multiple orders.
- Repeat-customer analysis uses `customer_unique_id`.

### Order vs Order Item

One order can contain multiple items:

```text
1 Order
├── Item 1
├── Item 2
└── Item 3
```

Therefore:

```text
COUNT(*)
→ item records

COUNT(DISTINCT order_id)
→ unique orders
```

---

## 9. Main Measures Used

| Measure | Meaning |
|---|---|
| `SUM(price)` | Total product revenue |
| `SUM(freight_value)` | Total freight value |
| `SUM(price + freight_value)` | Product value plus freight value |
| `COUNT(DISTINCT order_id)` | Number of unique orders |
| `COUNT(oi.order_id)` | Number of order-item records |
| `AVG(price)` | Average item price |
| Revenue per order | Revenue divided by unique orders |
| Revenue per customer | Revenue divided by customers |
| Delivery days | Difference between purchase and delivery dates |
| Delivery difference | Difference between actual and estimated delivery dates |

---

## 10. Delivery Analysis Definitions

### Delivery Time

```text
Order Delivered Customer Date
        -
Order Purchase Timestamp
```

### Delivery Difference

```text
Actual Delivery Date
        -
Estimated Delivery Date
```

- Negative value → delivered early
- Zero → delivered on estimated date
- Positive value → delivered late

---

## 11. Time Analysis Definitions

### MoM Growth
Compares revenue for the current month with the previous calendar month.

### YoY Growth
Compares revenue for the current year with the previous year.

Used to identify revenue growth, decline, and major changes over time.

---

## 12. Data Quality Notes

The project includes validation for:

- customer identifier behavior
- repeat-customer patterns
- NULL delivery dates
- delivery date chronology
- order vs item grain
- unique order counting

---

## 13. Primary Tables Used

1. `olist_customers_dataset`
2. `olist_orders_dataset`
3. `olist_order_items_dataset`
4. `olist_products_dataset`
5. `olist_sellers_dataset`

Other Olist files may exist in `03. Dataset/Raw/`, but these five tables form the core of this project's analysis.
