 -- Creating CTE for reusability, and readibility
WITH TopCustomer AS (SELECT
	cu.ContactName,
    ROUND(SUM((od.UnitPrice * od.Quantity) * (1- od.Discount)),3) AS Total_Spent,
    cu.Country,
    ROW_NUMBER() OVER(PARTITION BY Country ORDER BY SUM((od.UnitPrice * od.Quantity) * (1- od.Discount)) DESC) AS ranked_customers
FROM
	customers cu
LEFT JOIN
	orders o
ON
	cu.CustomerID = o.CustomerID
INNER JOIN
	order_details od
ON
	o.OrderID = od.OrderID
GROUP BY 
	ContactName, Country
ORDER BY Total_Spent DESC),
Countries_Spending AS (SELECT
	cu.Country,
    ROUND(SUM((od.UnitPrice * od.Quantity) * (1- od.Discount)),3) AS Total_Spent
FROM
	customers cu
LEFT JOIN
	orders o
ON
	cu.CustomerID = o.CustomerID
INNER JOIN
	order_details od
ON
	o.OrderID = od.OrderID
GROUP BY 
	Country
ORDER BY Total_Spent DESC)



SELECT
	cs.Country,
    cs.Total_Spent AS Country_Total_Spend,
    tc.ContactName AS Country_Highest_Spender,
    tc.Total_Spent AS Amount_Spent,
    ROUND((tc.Total_Spent / cs.Total_Spent) * 100,2 ) AS Percent_As_Countries_Total
FROM 
	Countries_Spending cs
INNER JOIN
	TopCustomer tc
ON
	cs.Country = tc.Country
WHERE
	ranked_customers = 1



