drop table if exists zepto;
create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGrams INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);
--data exploration

--count of rows
SELECT COUNT (*) FROM zepto;

SELECT * FROM zepto;

SELECT COUNT (*) FROM zepto;

--sample data 
SELECT * FROM zepto
LIMIT 10;

--null values
SELECT * FROM zepto
WHERE name IS NULL
OR
category is NULL
OR
mrp is NULL
OR
discountPercent is NULL
OR
availableQuantity is NULL
OR 
discountedSellingPrice is NULL
OR
weightInGrams is NULL
OR
outOfStock is NULL
OR
quantity is NULL;

--different product categories
SELECT DISTINCT category FROM zepto
ORDER BY category;

--products in stock vs out of stock
SELECT outOfStock, COUNT(sku_id) 
FROM zepto
GROUP BY outOfStock;

--product names present multiple times
SELECT name, COUNT(sku_id) as "Number of SKUs"
FROM zepto
GROUP BY name
HAVING count(sku_id)>1
ORDER BY count(sku_id) DESC;

--data cleaning

--products with price = 0
SELECT * FROM  zepto
WHERE mrp = 0 or discountedSellingPrice = 0;

DELETE FROM zepto WHERE mrp = 0;

--convert paise to rupees
UPDATE zepto
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

SELECT mrp, discountedSellingPrice FROM zepto;

--data analysis

--Q1. Find the top 10 best-value products based on the discount percentage
SELECT DISTINCT name,mrp,discountPercent 
from zepto
ORDER BY discountPercent DESC
LIMIT 10;

--Q2. What are the products with High MRP but out of stock
SELECT DISTINCT name, mrp
FROM zepto
WHERE outOfStock = TRUE and mrp>300
ORDER BY mrp DESC;

--Q3. Calculate estimated revenue for each category
SELECT category, SUM(discountedSellingPrice * availableQuantity) 
AS TotalRevenue
from zepto
GROUP BY category
ORDER BY TotalRevenue;

--Q4. Find all products where mrp is greater than 500 and discount is less than 10%
SELECT name, mrp, discountPercent
FROM zepto
WHERE mrp>500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;
--Q5.Identify the top 5 categories offering the highest average discount Percentage
SELECT category, AVG(discountPercent) as average_discount_percentage
FROM zepto
GROUP BY category
ORDER BY average_discount_percentage DESC
LIMIT 5;

--Q6. Find the price per gram for products above 100g and sort by best value
SELECT name, weightInGrams, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGrams,2) AS price_per_gram
FROM zepto
WHERE weightInGrams >= 100
ORDER BY price_per_gram ;

--Q7. Group the products into categories like low, Medium< Bulk
SELECT DISTINCT name, weightInGrams,
CASE WHEN weightInGrams< 1000 THEN 'Low'
	 WHEN weightInGrams< 1000 THEN 'Medium'
	 ELSE 'Bulk'
	 END AS weight_category
FROM zepto
ORDER BY weight_category;

--Q8. What is the Total Inventory Weight per Category
SELECT category, SUM(weightInGrams*availableQuantity) AS total_inventory_weight
FROM zepto
GROUP BY category
ORDER BY total_inventory_weight DESC;