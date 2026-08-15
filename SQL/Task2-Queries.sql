Task2-SQL Data Extraction
-- =========================================================
-- 1. SQL FUNDAMENTALS
-- =========================================================
-- SELECT
SELECT
    "Order ID",
    "Product Name",
    Sales,
    Profit
FROM sales
LIMIT 10;
-- WHERE
SELECT *
FROM sales
WHERE Sales > 500;
-- ORDER BY
SELECT *
FROM sales
ORDER BY Sales DESC
LIMIT 10;
-- GROUP BY
SELECT
    Category,
    SUM(Sales) AS Total_Sales
FROM sales
GROUP BY Category
ORDER BY Total_Sales DESC;
-- HAVING
SELECT
    Category,
    SUM(Sales) AS Total_Sales
FROM sales
GROUP BY Category
HAVING SUM(Sales) > 100000;
-- =========================================================
-- 2. JOIN
-- =========================================================
SELECT
    s."Order ID",
    s."Customer ID",
    c."Customer Name",
    c."Segment",
    s.Sales
FROM sales AS s
JOIN customers AS c
    ON s."Customer ID" = c."Customer ID"
LIMIT 10;
-- =========================================================
-- 3. ADVANCED SQL - SUBQUERY
-- =========================================================
-- Products/orders with sales greater than the average sales
SELECT
    "Product Name",
    Sales
FROM sales
WHERE Sales > (
    SELECT AVG(Sales)
    FROM sales
)
ORDER BY Sales DESC;
-- Products whose total sales are above the average
-- product-level total sales
SELECT
    "Product Name",
    SUM(Sales) AS Total_Sales
FROM sales
GROUP BY "Product Name"
HAVING SUM(Sales) > (
    SELECT AVG(Product_Sales)
    FROM (
        SELECT
            "Product Name",
            SUM(Sales) AS Product_Sales
        FROM sales
        GROUP BY "Product Name"
    )
)
ORDER BY Total_Sales DESC;

-- =========================================================
-- 4. CTE
-- =========================================================
WITH category_sales AS (
    SELECT
        Category,
        SUM(Sales) AS Total_Sales
    FROM sales
    GROUP BY Category
)
SELECT *
FROM category_sales
ORDER BY Total_Sales DESC;
-- Product-level CTE
WITH product_sales AS (
    SELECT
        "Product Name",
        SUM(Sales) AS Total_Sales
    FROM sales
    GROUP BY "Product Name"
)
SELECT *
FROM product_sales
ORDER BY Total_Sales DESC
LIMIT 10;

-- =========================================================
-- 5. WINDOW FUNCTIONS
-- =========================================================

-- ROW_NUMBER
SELECT
    "Product Name",
    SUM(Sales) AS Total_Sales,
    ROW_NUMBER() OVER (
        ORDER BY SUM(Sales) DESC
    ) AS Product_Number
FROM sales
GROUP BY "Product Name";

-- RANK by category
SELECT
    Category,
    SUM(Sales) AS Total_Sales,
    RANK() OVER (
        ORDER BY SUM(Sales) DESC
    ) AS Sales_Rank
FROM sales
GROUP BY Category;


-- RANK individual sales records
SELECT
    "Product Name",
    Sales,
    RANK() OVER (
        ORDER BY Sales DESC
    ) AS Sales_Rank
FROM sales
LIMIT 20;


-- LAG
WITH monthly_sales AS (
    SELECT
        strftime('%Y-%m', "Order Date") AS Month,
        SUM(Sales) AS Total_Sales
    FROM sales
    GROUP BY strftime('%Y-%m', "Order Date")
)
SELECT
    Month,
    Total_Sales,
    LAG(Total_Sales) OVER (
        ORDER BY Month
    ) AS Previous_Month_Sales
FROM monthly_sales
ORDER BY Month;


-- LEAD
WITH monthly_sales AS (
    SELECT
        strftime('%Y-%m', "Order Date") AS Month,
        SUM(Sales) AS Total_Sales
    FROM sales
    GROUP BY strftime('%Y-%m', "Order Date")
)
SELECT
    Month,
    Total_Sales,
    LEAD(Total_Sales) OVER (
        ORDER BY Month
    ) AS Next_Month_Sales
FROM monthly_sales
ORDER BY Month;


-- =========================================================
-- 6. VIEW
-- =========================================================

CREATE VIEW IF NOT EXISTS category_sales AS
SELECT
    Category,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM sales
GROUP BY Category;


-- Query the view
SELECT *
FROM category_sales
ORDER BY Total_Sales DESC;


-- =========================================================
-- 7. BUSINESS QUESTIONS
-- =========================================================


-- Question 1:
-- What are the top 5 products by sales?

SELECT
    "Product Name",
    SUM(Sales) AS Total_Sales
FROM sales
GROUP BY "Product Name"
ORDER BY Total_Sales DESC
LIMIT 5;


-- Question 2:
-- What is the monthly sales trend?

SELECT
    strftime('%Y-%m', "Order Date") AS Month,
    SUM(Sales) AS Total_Sales
FROM sales
GROUP BY Month
ORDER BY Month;


-- Question 3:
-- Which customer segment has the highest sales?

SELECT
    Segment,
    SUM(Sales) AS Total_Sales
FROM sales
GROUP BY Segment
ORDER BY Total_Sales DESC
LIMIT 1;


-- Question 4:
-- Which category generates the highest profit?

SELECT
    Category,
    SUM(Profit) AS Total_Profit
FROM sales
GROUP BY Category
ORDER BY Total_Profit DESC
LIMIT 1;


-- Question 5:
-- Which region has the highest sales?

SELECT
    Region,
    SUM(Sales) AS Total_Sales
FROM sales
GROUP BY Region
ORDER BY Total_Sales DESC
LIMIT 1;


-- Question 6:
-- What are the top 10 customers by sales?

SELECT
    "Customer Name",
    SUM(Sales) AS Total_Sales
FROM sales
GROUP BY "Customer Name"
ORDER BY Total_Sales DESC
LIMIT 10;


-- Question 7:
-- Which sub-category has the highest profit?

SELECT
    "Sub-Category",
    SUM(Profit) AS Total_Profit
FROM sales
GROUP BY "Sub-Category"
ORDER BY Total_Profit DESC
LIMIT 1;


-- Question 8:
-- Which products are loss-making?

SELECT
    "Product Name",
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM sales
GROUP BY "Product Name"
HAVING ROUND(SUM(Profit), 2) < 0
ORDER BY Total_Profit ASC;


-- Question 9:
-- What is the total sales and profit?

SELECT
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM sales;


-- Question 10:
-- Which state has the highest sales?

SELECT
    State,
    SUM(Sales) AS Total_Sales
FROM sales
GROUP BY State
ORDER BY Total_Sales DESC
LIMIT 1;