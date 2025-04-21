-- CTEs
-- Fetching Employee Details
WITH emp_details AS(
SELECT
	EmployeeID,
    CONCAT(TitleOfCourtesy, ' ', FirstName, ' ', LastName) AS Employee_Name
FROM
	employees
),
-- Finding total orders completed by each employee
emp_total_order AS(
SELECT
	EmployeeID,
    COUNT(OrderID) AS Total_Orders
FROM
	orders
GROUP BY 
	EmployeeID
),
-- Finding total revenue from each employee
emp_total_amount AS(
SELECT
	EmployeeID,
    SUM(Order_Cost) AS Order_Cost
FROM
	orders
INNER JOIN
	(SELECT
		OrderID,
		(UnitPrice * Quantity) * (1-Discount) AS Order_Cost
	FROM
	order_details)t
ON
	orders.OrderID = t.OrderID
GROUP BY 
	EmployeeID
)

SELECT
	Employee_Name,
    Total_Orders,
    ROUND(etm.Order_Cost, 3) AS Total_Amount,
    DENSE_RANK() OVER(ORDER BY ROUND(Order_Cost, 3) DESC) AS Ranking
FROM
	emp_details ed
LEFT JOIN
	emp_total_order eto
ON	
	ed.EmployeeID = eto.EmployeeID
LEFT JOIN
	emp_total_amount etm
ON
	eto.EmployeeID = etm.EmployeeID