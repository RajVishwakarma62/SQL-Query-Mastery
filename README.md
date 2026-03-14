# 🚀 SQL-Query-Mastery

Welcome to my SQL mastery repository! This project contains the schema, mock data, and my personal solutions to 300 real-world SQL interview questions asked at top-tier firms including PwC, Deloitte, EY, KPMG, Tredence, and Accenture. 

The goal of this repository is to demonstrate an advanced understanding of database querying, logical problem solving, and data manipulation using **Microsoft SQL Server (T-SQL)**.

## 🧠 Key Skills Demonstrated
Throughout these 300 queries, I heavily utilize advanced SQL concepts to solve complex business problems:
* **Window Functions:** Running totals, moving averages, ranking (`ROW_NUMBER`, `RANK`, `DENSE_RANK`), and percentiles.
* **Common Table Expressions (CTEs) & Recursive CTEs:** Navigating employee-manager hierarchies and reporting chains.
* **Complex Data Analysis:** Solving "Gaps and Islands" problems, calculating month-over-month growth, and customer retention metrics.
* **Data Transformation:** Dynamic pivoting, unpivoting, and conditional aggregations.
* **Advanced Joins & Self-Joins:** Identifying overlapping date ranges and comparing current vs. previous rows.

## 🗄️ The Database Architecture
To practice these queries realistically, I designed a simulated enterprise relational database divided into three core modules:

1. **Human Resources (HR) Module:** Tracks organizational hierarchy, departmental budgets, salary history, and employee attendance.
2. **E-Commerce & Sales Module:** Manages the customer journey, from product catalogs and categories to granular order details and reviews.
3. **Project Management Module:** Bridges the HR and workload side, tracking employee assignments, overlapping project dates, and budgets.

## 📂 Repository Structure
The repository is organized logically by business module. Each folder contains the SQL scripts needed to build the tables, populate the mock data, and the `.sql` files containing my solutions.

```text
├── 01_HR_Module/
│   ├── schema_and_data.sql      # DDL and DML for HR tables
│   └── hr_solutions.sql         # Solutions for HR-specific questions
├── 02_Sales_Module/
│   ├── schema_and_data.sql      # DDL and DML for Sales tables
│   └── sales_solutions.sql      # Solutions for E-commerce questions
├── 03_Projects_Module/
│   ├── schema_and_data.sql      # DDL and DML for Project tables
│   └── project_solutions.sql    # Solutions for Project questions
└── README.md
