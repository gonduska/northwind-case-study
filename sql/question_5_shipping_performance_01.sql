-- CTE
WITH shipping AS (
	SELECT
		OrderID,
		CompanyName,
		OrderDate,
		ShippedDate,
		DATEDIFF(ShippedDate,OrderDate) AS CompletionTime,
		ShipCountry
	FROM(
		SELECT
			OrderID,
			ShipVia,
			DATE(RequiredDate) AS RequiredDate,
			DATE(OrderDate) AS OrderDate,
			DATE(ShippedDate) AS ShippedDate,
			ShipCountry
		FROM
			orders)t
	INNER JOIN
		shippers
	ON
		t.ShipVia = shippers.ShipperID
),
-- Filtering orders that has NULL value in their ComletionTime
null_time AS(
SELECT * FROM shipping WHERE CompletionTime IS NULL
),
-- Finding AVG Shipping Time
avg_time AS (SELECT
	ROUND(AVG(CompletionTime),1) AS Avg_Completion_Time
FROM 
	shipping
)
-- Orders took longer than avg/company
SELECT
	CompanyName,
	COUNT(OrderID) Order_Amount
FROM
	shipping
WHERE
	CompletionTime > 
    (
    SELECT Avg_Completion_Time FROM avg_time
    )
GROUP BY CompanyName;









    