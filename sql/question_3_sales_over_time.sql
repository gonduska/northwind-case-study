-- TotalSales CTE
WITH TotalSales AS(
SELECT 
	OrderID,
    ProductID,
    ROUND((UnitPrice * Quantity) * (1-Discount),3) TotalAmount
FROM order_details
),
-- Finding the names of the products
ProductName AS(
SELECT
	ProductID,
    CategoryName
FROM
	products
INNER JOIN
	categories
ON
	products.CategoryID = categories.CategoryID
)

-- Connecting each sale with order date, destination of shipping and category of product
SELECT
	DATE(OrderDate) AS OrderDate,
    TotalAmount,
    ShipCountry,
    CategoryName
FROM
	orders o
LEFT JOIN
	TotalSales ts
ON
	o.OrderID = ts.OrderID
INNER JOIN
	ProductName pn
ON
	ts.ProductID = pn.ProductID







