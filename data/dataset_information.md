# Dataset Information

## Source

**Brazilian E-Commerce Public Dataset by Olist**
Published on Kaggle: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

This is real, anonymized commercial data from Olist, a Brazilian e-commerce marketplace that connects small businesses to major online sales channels. The data covers orders placed between **2016 and 2018** across multiple Brazilian marketplaces.

## Tables Used

| Table | Rows | Description |
|---|---|---|
| `customers` | 99,441 | Customer ID, location (city/state/zip) |
| `orders` | 99,441 | Order status and timestamps (purchase, approval, delivery) |
| `order_items` | 112,650 | Line-item detail per order: product, seller, price, freight |
| `products` | 32,951 | Product attributes (category, weight, dimensions) |
| `order_payments` | 103,886 | Payment method, installments, payment value |
| `order_reviews` | 99,222 | Customer review scores and comments |
| `sellers` | 3,095 | Seller ID and location |
| `product_category_name_translation` | 71 | Maps Portuguese category names to English |

## Known Data Notes

- **`order_reviews`**: 99,222 of 99,224 source rows were loaded (99.998%). Two rows were excluded due to malformed formatting in the raw CSV (unescaped characters within free-text review comments).
- **Date columns** (e.g. `order_purchase_timestamp`, `order_delivered_customer_date`) were imported as `TEXT` and converted to proper `DATETIME` values within queries using `STR_TO_DATE()`, since MySQL Workbench's import wizard does not auto-detect this dataset's `M/D/YYYY H:i` date format.
- **Data collection cutoff**: order volume drops sharply in September-October 2018. This reflects when the dataset's collection period ended, not an actual decline in business activity.
- **`customer_id` vs `customer_unique_id`**: Olist assigns a new `customer_id` for every order, even from a repeat customer. `customer_unique_id` is the actual unique identifier for a real person. This project uses `customer_unique_id` where "unique customers" is the intended meaning.

## Tools Used

- **MySQL 8.0** / **MySQL Workbench** for data import, querying, and analysis
- CSV files imported via Workbench's Table Data Import Wizard and, where that wizard failed to parse quoted/multi-line text fields correctly, via `LOAD DATA INFILE`
