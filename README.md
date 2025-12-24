# ⚡ Near-Real-Time Data Warehouse with Hybrid Join

![Python](https://img.shields.io/badge/Python-3.8%2B-blue?style=for-the-badge&logo=python&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-8.0-orange?style=for-the-badge&logo=mysql&logoColor=white)
![Status](https://img.shields.io/badge/Status-Complete-success?style=for-the-badge)

**A high-performance ETL pipeline implementing the Hybrid Join algorithm to integrate streaming transactional data with disk-based master data for Walmart.**

---

## 📖 Project Overview
[cite_start]This project designs and implements a **Near-Real-Time Data Warehouse (DW)** prototype for Walmart[cite: 15]. [cite_start]The primary goal is to optimize sales analysis and enhance customer satisfaction by processing shopping behavior dynamically[cite: 19].

[cite_start]The core challenge addressed is the efficient joining of a fast-arriving, potentially bursty **data stream (transactions)** with a large, **disk-based relation (customer master data)**[cite: 78]. [cite_start]Standard joins are too slow for real-time streams, so this project implements the **Hybrid Join Algorithm** in Python to handle the transformation phase[cite: 76].

---

## 🏗️ System Architecture

### 1. Data Warehouse Schema (Star Schema)
[cite_start]The system uses a **Star Schema** to model sales data, placing the `fact_sales` table at the center surrounded by dimension tables[cite: 228, 229].

* [cite_start]**Fact Table:** `fact_sales` (Contains measures like quantity, total_amount, and foreign keys)[cite: 239].
* [cite_start]**Dimensions:** `customer`, `product`, `store`, `supplier`, `dateDim`[cite: 239].
* [cite_start]**Optimization:** In-memory caching is used for dimension tables to reduce disk I/O[cite: 223].

### 2. The Hybrid Join Algorithm
[cite_start]The custom Python implementation (`HybridJoin.py`) bridges the gap between streaming data and disk storage using a multi-threaded approach[cite: 242].

**Key Components:**
* [cite_start]**Stream Buffer:** Temporarily holds incoming bursty stream tuples[cite: 80].
* [cite_start]**Hash Table (Memory):** Stores stream tuples mapped by `Customer_ID` for $O(1)$ lookups[cite: 255].
* [cite_start]**Queue (FIFO):** A doubly-linked list tracking the arrival order of transactions to ensure fairness[cite: 86].
* [cite_start]**Disk Buffer:** Loads partitions of Customer Master Data (500 tuples at a time) based on the oldest key in the Queue[cite: 251].

**Workflow:**
1.  [cite_start]**Extract:** A `stream_feeder` thread mimics live transactions, pushing data into the Stream Buffer[cite: 258].
2.  [cite_start]**Transform (Join):** The `hybrid_worker` thread hashes stream data and selectively fetches matching blocks from the disk-based Customer table[cite: 259, 260].
3.  [cite_start]**Load:** Enriched data is batched and bulk-inserted into the MySQL `fact_sales` table[cite: 277].

---

## 📊 Analytics & Insights
The project includes a suite of OLAP queries (`queries.sql`) to derive business insights, such as:
* [cite_start]**Top Revenue Products:** Identifying top-selling items split by weekdays vs. weekends[cite: 133].
* [cite_start]**Customer Demographics:** Analyzing purchase behavior by Gender, Age, and City Category[cite: 137].
* [cite_start]**Seasonal Trends:** Drill-down analysis of sales across Spring, Summer, Fall, and Winter[cite: 162].
* [cite_start]**Growth Rate:** Calculating month-over-month sales growth for products and stores[cite: 151].

---

## 📂 Project Structure
```text
├── HybridJoin.py          # Main Python script (ETL & Hybrid Join Logic)
├── datawearhouse.sql      # SQL script to create the Star Schema
├── queries.sql            # OLAP queries for business intelligence
├── project_Report.docx    # Detailed documentation & performance analysis
├── transactional_data.csv # Source data (simulated stream)
└── README.md              # Project documentation
