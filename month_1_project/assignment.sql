-- ANALYSIS FOR RETAIL DATA
SELECT * FROM retail;
-- PROCESS FLOW
-- CREATE TABLE NAMED RETAIL
CREATE TABLE retail (
    Invoiceno VARCHAR(20),
    Stockcode VARCHAR(20),
    Description TEXT,
    Quantity INT,
    Invoicedate DATETIME,
    Unitprice DECIMAL(10,2),
    Customerid INT,
    Country VARCHAR(50)
);

-- COPY DATA FROM CSV TO TABLE
\copy retail from 'Retail_data.xlsx\ -\ Online\ Retail.csv' DELIMITER ',' CSV HEADER;

-- GET UNIQUE PRODUCTS PURCHASED BY CLIENTS
SELECT DISTINCT customerid, stockcode from retail GROUP BY (customerid, stockcode)

-- CUSTOMERS WHO HAVE MADE ONLY 1 PURCHASE FROM THE COMPANY
-- WITH getUniqueProducts AS (
    SELECT customerid, count(DISTINCT Invoiceno) as unique_products from retail GROUP BY (customerid) HAVING count(DISTINCT Invoiceno) = 1;
-- )
-- select * from getUniqueProducts WHERE unique_products = 1;

-- PRODUCTS  THAT ARE COMMONLY BOUGHT TOGETHER
SELECT 
    s1.StockCode AS Product_1, 
    s2.StockCode AS Product_2, 
    COUNT(*) AS purchase_count 
FROM retail s1
JOIN retail s2 ON s1.InvoiceNo = s2.InvoiceNo AND s1.StockCode > s2.StockCode
GROUP BY Product_1, Product_2
ORDER BY purchase_count DESC
LIMIT 10;

-- TOP 5 SPENDING CUSTOMERS IN EACH COUNTRY
WITH CustomerSpending AS (
    SELECT 
        CustomerID, 
        Country, 
        SUM(Quantity * UnitPrice) AS total_spent, 
        RANK() OVER (PARTITION BY Country ORDER BY SUM(Quantity * UnitPrice) DESC) AS rank 
    FROM retail 
    GROUP BY CustomerID, Country
)
SELECT * FROM CustomerSpending WHERE rank <= 5;

-- MONTH on MONTH BASIS
SELECT 
    TO_CHAR(InvoiceDate, 'YYYY-MM') AS month, 
    AVG(Quantity * UnitPrice) AS avg_sales 
FROM retail 
GROUP BY month 
ORDER BY month;

-- MONTH WITH THE HIGHEST SALES
SELECT 
    TO_CHAR(InvoiceDate, 'YYYY-MM') AS month, 
    SUM(Quantity * UnitPrice) AS total_sales 
FROM retail 
GROUP BY month 
ORDER BY total_sales DESC 
LIMIT 1;

-- ITEMS PERFORMED BETTER IN THE UNITED UNITED KINGDOM THAN FRANCE
SELECT 
    StockCode, 
    SUM(CASE WHEN Country = 'United Kingdom' THEN Quantity * UnitPrice ELSE 0 END) AS UK_Sales,
    SUM(CASE WHEN Country = 'France' THEN Quantity * UnitPrice ELSE 0 END) AS France_Sales,
    (SUM(CASE WHEN Country = 'United Kingdom' THEN Quantity * UnitPrice ELSE 0 END) -
     SUM(CASE WHEN Country = 'France' THEN Quantity * UnitPrice ELSE 0 END)) AS Difference
FROM retail
WHERE Country IN ('United Kingdom', 'France')
GROUP BY StockCode
-- HAVING UK_Sales > France_Sales
ORDER BY Difference DESC
LIMIT 10;