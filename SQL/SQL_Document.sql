create table sales(
InvoiceNo varchar(20) ,
stockCode varchar(50) ,
Description varchar(255) ,
Quantity int,
InvoiceDate Timestamp ,
UnitPrice decimal(10,2),
CustomerID int null,
Country varchar(100)
);

CREATE TABLE retail_clean AS
SELECT *
FROM sales;




--1. Total number of orders
SELECT COUNT(DISTINCT InvoiceNo) AS total_orders
FROM retail_clean;
-- Answer - 11139



--2. Total number of customers
SELECT COUNT(DISTINCT CustomerID) AS total_customers
FROM retail_clean
WHERE CustomerID IS NOT NULL;
-- Answer - 3125




--3. Total products
SELECT COUNT(DISTINCT StockCode) AS total_products
FROM retail_clean;
--Answer - 3858




--4. Total quantity sold
SELECT SUM(Quantity) AS total_units
FROM retail_clean
WHERE Quantity > 0
  AND UnitPrice > 0
  AND InvoiceNo NOT LIKE 'A%'
  AND InvoiceNo NOT LIKE 'C%';
-- Answer - 2394678




--5. Gross sales
SELECT
    SUM(Quantity * UnitPrice) AS gross_sales
FROM retail_clean
WHERE Quantity > 0
  AND UnitPrice > 0
  AND InvoiceNo NOT LIKE 'A%'
  AND InvoiceNo NOT LIKE 'C%';
-- Answer - 4662256.59




--6. Cancellation value
SELECT
    ABS(SUM(Quantity * UnitPrice)) AS cancellation_value
FROM retail_clean
WHERE InvoiceNo LIKE 'C%';

--Answer - 502915.96




--7. Top 10 products by revenue
SELECT
    StockCode,
    MAX(Description) AS Description,
    SUM(Quantity * UnitPrice) AS revenue
FROM retail_clean
WHERE Quantity > 0
  AND UnitPrice > 0
  AND InvoiceNo NOT LIKE 'A%'
  AND InvoiceNo NOT LIKE 'C%'
GROUP BY StockCode
ORDER BY revenue DESC
LIMIT 10; 

--Answer- ["23843","DOT","22423","85123A","22502","85099B","47566","POST","22086","84879"]




--8. Bottom products
SELECT
    StockCode,
    MAX(Description) AS Description,
    SUM(Quantity * UnitPrice) AS revenue
FROM retail_clean
WHERE Quantity > 0
  AND UnitPrice > 0
  AND InvoiceNo NOT LIKE 'A%'
  AND InvoiceNo NOT LIKE 'C%'
GROUP BY StockCode
ORDER BY revenue ASC
LIMIT 10;

-- Answer - ["47013A","35818B","44089C","79151B","71215","84990","71495A","21268","44091A","62074B"]





--9. Country Analysis
SELECT
    Country,
    SUM(Quantity * UnitPrice) AS revenue
FROM retail_clean
WHERE Quantity > 0
  AND UnitPrice > 0
  AND InvoiceNo NOT LIKE 'A%'
  AND InvoiceNo NOT LIKE 'C%'
GROUP BY Country
ORDER BY revenue DESC;




--10. Top 10 customers by revenue
SELECT
    CustomerID,
    SUM(Quantity * UnitPrice) AS revenue
FROM retail_clean
WHERE CustomerID IS NOT NULL
  AND Quantity > 0
  AND UnitPrice > 0
  AND InvoiceNo NOT LIKE 'A%'
  AND InvoiceNo NOT LIKE 'C%'
GROUP BY CustomerID
ORDER BY revenue DESC
LIMIT 10;




--11. Orders per customer
SELECT
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS total_orders
FROM retail_clean
WHERE CustomerID IS NOT NULL
  AND Quantity > 0
  AND InvoiceNo NOT LIKE 'C%'
GROUP BY CustomerID
ORDER BY total_orders DESC;




--12. Average Order Value
SELECT
    SUM(Quantity * UnitPrice)
    / COUNT(DISTINCT InvoiceNo) AS AOV
FROM retail_clean
WHERE Quantity > 0
  AND UnitPrice > 0
  AND InvoiceNo NOT LIKE 'A%'
  AND InvoiceNo NOT LIKE 'C%';

-- Answer - aov- 544.97




--13. Average Selling Price
SELECT
    SUM(Quantity * UnitPrice)
    / SUM(Quantity) AS average_selling_price
FROM retail_clean
WHERE Quantity > 0
  AND UnitPrice > 0
  AND InvoiceNo NOT LIKE 'A%'
  AND InvoiceNo NOT LIKE 'C%';
--Answer- 1.9469




--14. Returning customers 
SELECT
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS order_count
FROM retail_clean
WHERE CustomerID IS NOT NULL
  AND Quantity > 0
  AND InvoiceNo NOT LIKE 'C%'
  AND InvoiceNo NOT LIKE 'A%'
GROUP BY CustomerID
HAVING COUNT(DISTINCT InvoiceNo) > 1;