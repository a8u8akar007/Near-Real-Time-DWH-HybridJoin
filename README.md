# ⚡ Near-Real-Time Data Warehouse with Hybrid Join

[![Python](https://img.shields.io/badge/Python-3.8%2B-blue?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-orange?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com/)
![Status](https://img.shields.io/badge/Status-Complete-success?style=for-the-badge)

**A high-performance ETL pipeline implementing the Hybrid Join algorithm to integrate streaming transactional data with disk-based master data for Walmart.**

---

## 📖 Project Overview
This project designs and implements a **Near-Real-Time Data Warehouse (DW)** prototype for Walmart. The primary goal is to optimize sales analysis and enhance customer satisfaction by processing shopping behavior dynamically.

The core challenge addressed is the efficient joining of a fast-arriving, potentially bursty **data stream (transactions)** with a large, **disk-based relation (customer master data)**. Standard joins are too slow for real-time streams, so this project implements the **Hybrid Join Algorithm** in Python to handle the transformation phase.

---

## 🏗️ System Architecture

### 1. Data Warehouse Schema (Star Schema)
The system uses a **Star Schema** to model sales data, placing the `fact_sales` table at the center surrounded by dimension tables.

* **Fact Table:** `fact_sales` (Contains measures like quantity, total_amount, and foreign keys).
* **Dimensions:** `customer`, `product`, `store`, `supplier`, `dateDim`.
* **Optimization:** In-memory caching is used for dimension tables to reduce disk I/O.

### 2. The Hybrid Join Algorithm
The custom Python implementation (`HybridJoin.py`) bridges the gap between streaming data and disk storage using a multi-threaded approach.

**Key Components:**
* **Stream Buffer:** Temporarily holds incoming bursty stream tuples.
* **Hash Table (Memory):** Stores stream tuples mapped by `Customer_ID` for O(1) lookups.
* **Queue (FIFO):** A doubly-linked list tracking the arrival order of transactions to ensure fairness.
* **Disk Buffer:** Loads partitions of Customer Master Data (500 tuples at a time) based on the oldest key in the Queue.

**Workflow:**
1.  **Extract:** A `stream_feeder` thread mimics live transactions, pushing data into the Stream Buffer.
2.  **Transform (Join):** The `hybrid_worker` thread hashes stream data and selectively fetches matching blocks from the disk-based Customer table.
3.  **Load:** Enriched data is batched and bulk-inserted into the MySQL `fact_sales` table.

---

## 📊 Analytics & Insights
The project includes a suite of OLAP queries (`queries.sql`) to derive business insights, such as:
* **Top Revenue Products:** Identifying top-selling items split by weekdays vs. weekends.
* **Customer Demographics:** Analyzing purchase behavior by Gender, Age, and City Category.
* **Seasonal Trends:** Drill-down analysis of sales across Spring, Summer, Fall, and Winter.
* **Growth Rate:** Calculating month-over-month sales growth for products and stores.

---

## 📂 Project Structure
```text
├── HybridJoin.py          # Main Python script (ETL & Hybrid Join Logic)
├── datawearhouse.sql      # SQL script to create the Star Schema
├── queries.sql            # OLAP queries for business intelligence
├── project_Report.docx    # Detailed documentation & performance analysis
├── transactional_data.csv # Source data (simulated stream)
└── README.md              # Project documentation
```

## 🚀 How to Run
### Prerequisites
1. **Python 3.x**
2. **MySQL Server**
3. **Required Python libraries: pymysql, pandas**

### Steps
1. **Setup Database:**
Run the script datawearhouse.sql in your MySQL workbench to create the schema and tables.
2. **configure Connection:**
Open HybridJoin.py. You can either update the MYSQL_CONF dictionary with your credentials or simply run the script and enter them when prompted.
3. **Execute Pipeline:**
**python HybridJoin.py**
This will start the stream feeder and worker threads, processing the transactions and populating the DW.
4. **Run Analysis:**
Execute the SQL commands in queries.sql to view the analytics reports.
