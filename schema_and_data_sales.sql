-- Make sure we are in the right database
USE SQL_Interview_Practice;
GO

-- ============================================================================
-- 10. CLEAN SLATE: SALES MODULE
-- Description: Drop child tables first, then parent tables.
-- ============================================================================
DROP TABLE IF EXISTS product_reviews;
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS customers;
GO

-- ============================================================================
-- 11. CREATE SALES TABLES (DDL)
-- ============================================================================
-- Parent Table 1: Customers
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    registration_date DATE,
    country VARCHAR(50),
    region VARCHAR(50),
    segment VARCHAR(50)
);

-- Parent Table 2: Categories
CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100)
);

-- Child Table 1: Products (Depends on Categories)
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category_id INT REFERENCES categories(category_id),
    price DECIMAL(10, 2),
    launch_date DATE,
    discontinued BIT DEFAULT 0 -- In SQL Server, BIT is used for True(1)/False(0)
);

-- Child Table 2: Orders (Depends on Customers)
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE,
    amount DECIMAL(15, 2),
    discount DECIMAL(10, 2),
    discount_used BIT,
    payment_method VARCHAR(50),
    order_channel VARCHAR(50),
    shipping_method VARCHAR(50),
    delivery_date DATE
);

-- Child Table 3: Sales (Depends on Customers, Products, AND Employees!)
CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    product_id INT REFERENCES products(product_id),
    salesperson_id INT REFERENCES employees(id), -- This connects Sales to HR!
    sale_date DATE,
    amount DECIMAL(15, 2),
    quantity INT
);

-- Child Table 4: Reviews (Depends on Products and Customers)
CREATE TABLE product_reviews (
    review_id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT REFERENCES products(product_id),
    customer_id INT REFERENCES customers(customer_id),
    rating INT CHECK (rating >= 1 AND rating <= 5),
    review_date DATE
);
GO

-- ============================================================================
-- 12. INSERT MOCK DATA: CUSTOMERS & CATEGORIES
-- ============================================================================
INSERT INTO customers (customer_id, name, registration_date, country, region, segment) VALUES 
(1, 'TechCorp', '2020-05-10', 'USA', 'North America', 'Enterprise'),
(2, 'Global Goods', '2021-08-15', 'UK', 'Europe', 'SMB'),
(3, 'Local Shop', '2022-01-20', 'USA', 'North America', 'SMB'),
(4, 'Sarah Connor', '2022-11-05', 'Canada', 'North America', 'Consumer'),
(5, 'John Doe', '2023-02-10', 'Australia', 'Oceania', 'Consumer'),
(6, 'Wayne Enterprises', '2019-10-10', 'USA', 'North America', 'Enterprise'),
(7, 'Stark Industries', '2018-04-25', 'USA', 'North America', 'Enterprise'),
(8, 'Ghost Customer', '2024-01-01', 'Germany', 'Europe', 'Consumer'); -- Edge case: 0 Orders

INSERT INTO categories (category_id, category_name) VALUES 
(1, 'Electronics'), 
(2, 'Software'), 
(3, 'Office Supplies'), 
(4, 'Furniture');

-- ============================================================================
-- 13. INSERT MOCK DATA: PRODUCTS
-- ============================================================================
INSERT INTO products (product_id, product_name, category_id, price, launch_date, discontinued) VALUES 
(101, 'Laptop Pro', 1, 1500.00, '2021-01-01', 0),
(102, 'Smartphone X', 1, 999.00, '2022-05-01', 0),
(103, 'Cloud Storage 1TB', 2, 120.00, '2020-03-15', 0),
(104, 'Ergonomic Chair', 4, 350.00, '2019-08-20', 0),
(105, 'Legacy Server Rack', 1, 5000.00, '2015-01-01', 1), -- Discontinued
(106, 'Wireless Mouse', 1, 45.00, '2022-01-10', 0),
(107, 'Standing Desk', 4, 600.00, '2021-06-15', 0),
(108, 'Phantom Product', 2, 99.00, '2024-01-01', 0); -- Edge case: Never Sold

-- ============================================================================
-- 14. INSERT MOCK DATA: ORDERS, SALES & REVIEWS
-- ============================================================================
INSERT INTO orders (order_id, customer_id, order_date, amount, discount, discount_used, payment_method, order_channel, shipping_method, delivery_date) VALUES 
(1001, 1, '2022-01-15', 4500.00, 0.00, 0, 'Bank Transfer', 'Direct Sales', 'Freight', '2022-01-20'),
(1002, 6, '2022-03-10', 5000.00, 500.00, 1, 'Wire', 'Direct Sales', 'Freight', '2022-03-15'),
(1003, 2, '2022-06-22', 999.00, 0.00, 0, 'Credit Card', 'Online', 'Express', '2022-06-24'),
(1004, 3, '2023-01-05', 1050.00, 50.00, 1, 'PayPal', 'Online', 'Standard', '2023-01-10'),
(1005, 4, '2023-03-10', 120.00, 0.00, 0, 'Credit Card', 'Mobile App', 'Standard', '2023-03-14'),
(1006, 1, '2023-08-15', 3000.00, 0.00, 0, 'Bank Transfer', 'Direct Sales', 'Freight', '2023-08-20'),
(1007, 7, '2023-11-20', 15000.00, 1500.00, 1, 'Wire', 'Direct Sales', 'Freight', '2023-11-25'),
(1008, 5, '2024-01-10', 45.00, 0.00, 0, 'Debit Card', 'Online', 'Express', '2024-01-12'),
(1009, 2, '2024-02-14', 600.00, 0.00, 0, 'Credit Card', 'Online', 'Standard', NULL); -- Undelivered

-- Notice salesperson_id maps back to HR employees 9, 10, 11, 12 (The Sales Team)
INSERT INTO sales (sale_id, customer_id, product_id, salesperson_id, sale_date, amount, quantity) VALUES 
(5001, 1, 101, 9, '2022-01-15', 4500.00, 3),
(5002, 6, 105, 10, '2022-03-10', 5000.00, 1),
(5003, 2, 102, 11, '2022-06-22', 999.00, 1),
(5004, 3, 104, 11, '2023-01-05', 1050.00, 3),
(5005, 4, 103, 12, '2023-03-10', 120.00, 1),
(5006, 1, 101, 9, '2023-08-15', 3000.00, 2),
(5007, 7, 101, 9, '2023-11-20', 15000.00, 10),
(5008, 5, 106, 12, '2024-01-10', 45.00, 1),
(5009, 2, 107, 11, '2024-02-14', 600.00, 1);

INSERT INTO product_reviews (product_id, customer_id, rating, review_date) VALUES 
(101, 1, 5, '2022-02-01'), 
(105, 6, 2, '2022-04-01'), 
(102, 2, 4, '2022-07-01'),
(104, 3, 5, '2023-01-15'), 
(101, 7, 5, '2023-12-01'), 
(106, 5, 4, '2024-01-15');
GO

