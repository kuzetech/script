INSERT INTO enriched_orders
SELECT 
    o.order_id, 
    o.order_date, 
    o.customer_name, 
    o.price, 
    o.product_id, 
    o.order_status, 
    p.name as product_name, 
    p.description as product_description
FROM orders AS o
INNER JOIN products FOR SYSTEM_TIME AS OF o.order_date AS p ON o.product_id = p.id;