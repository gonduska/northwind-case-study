WITH order_time AS (
SELECT
	orders.OrderID,
	CompanyName,
    Country AS Shipping_From,
    ShipCountry AS Shipping_To,
    ProductName,
    OrderDate,
    ShippedDate,
    RequiredDate,
    DATEDIFF(ShippedDate,OrderDate) AS DeliveryDays,
    CASE 
		WHEN Discontinued = 1 THEN 'Discontinued'
        WHEN Discontinued = 0 THEN 'In production'
    END 'State'
FROM
	suppliers
INNER JOIN
	products
ON
	suppliers.SupplierID = products.SupplierID
INNER JOIN
	order_details
ON
	products.ProductID = order_details.ProductID
INNER JOIN
	orders
ON
	order_details.OrderID = orders.OrderID

 ),
 null_orders AS (
 select * from order_time
 WHERE
	DATEDIFF(ShippedDate,OrderDate) IS NULL
 ),
 avg_time AS (
 SELECT
	ROUND(AVG(DeliveryDays),1) AS avg_delivery_days
FROM
	order_time
 )
 
 select * from null_orders where State = 'Discontinued';
 
