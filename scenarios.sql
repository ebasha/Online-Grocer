-- All Purchases with items and vendor details
SELECT *
FROM purchases p
JOIN items i
	ON p.item_number = i.item_number
JOIN vendors v
	ON p.vendor_id = v.vendor_id
;

-- List of all sales with items details
SELECT *
FROM sales s
JOIN items i
	ON s.item_number = i.item_number
;

-- All transactions purchases or sales with details

WITH all_transactions AS (
	SELECT
		transaction_type,
		purchase_id ,
		vendor_id AS ID,
		item_number,
		date_purchased,
		quantity_purchased AS Quantity,
		cost_per_unit AS amount
	FROM purchases
	UNION ALL
	SELECT
		transaction_type,
		sale_id AS trans_num,
		customer_id AS ID ,
		item_number,
		date_sold ,
		quantity_sold AS Quantity,
		price_per_unit AS amount
	FROM sales)
SELECT *
FROM all_transactions t
JOIN items i
	ON t.item_number = i.item_number
;
		
-- number of items sold and revenues made
SELECT
	i.item_type,
    SUM(s.quantity_sold) AS Quantity_Sold,
    SUM(s.quantity_sold * s.price_per_unit) AS Total_Revenue
FROM sales s
JOIN items i
	ON s.item_number = i.item_number
GROUP BY i.item_type
ORDER BY i.item_type
;


-- Maximum revenue of items from the vendors

WITH sales_totals AS (
SELECT
	v.vendor_id,
    v.vendor_name,
    i.item_number,
    i.item_desc,
    SUM(s.quantity_sold) AS total_qty_sold,
    SUM(s.quantity_sold * s.price_per_unit) AS total_revenue
FROM sales s
JOIN items i
	ON s.item_number = i.item_number
JOIN vendors v
	ON i.vendor_id = v.vendor_id
GROUP BY v.vendor_id, i.item_number
)
SELECT
	vendor_name,
    item_desc,
    total_revenue
FROM sales_totals
WHERE (vendor_name, total_revenue) IN
		(SELECT
			vendor_name,
			MAX(total_revenue)
		FROM sales_totals
		GROUP BY vendor_name)
;

-- Revenue of items sold
SELECT
	s.item_number,
    i.item_desc,
    SUM(quantity_sold) AS Quantity_sold,
    SUM(quantity_sold * price_per_unit) AS Revenues
FROM sales s
JOIN items i
ON i.item_number = s.item_number
GROUP BY item_number
;