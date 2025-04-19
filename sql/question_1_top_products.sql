--  CTE for Total Revenue
WITH TotalRev AS (SELECT
	ProductName,
	ROUND(SUM(od.UnitPrice * Quantity * (1-Discount)),3) AS Top_Products_By_Revenue,
    CategoryName
FROM
	order_details od
INNER JOIN
	products p
ON od.ProductID = p.ProductID
INNER JOIN
	categories ca
ON ca.CategoryID = p.CategoryID
GROUP BY 
	od.ProductID, p.ProductName, ca.CategoryName
ORDER BY Top_Products_By_Revenue DESC)

SELECT
    *,
    CONCAT(ROUND((Top_Products_By_Revenue * 100) / SUM(Top_Products_By_Revenue)  OVER(),2), '%') AS Percentage_Of_Total_Sales,
    ROW_NUMBER() OVER(ORDER BY Top_Products_By_Revenue DESC) Product_Rank
FROM TotalRev

