INSERT INTO enriched_orders
SELECT 
    o.order_id, 
    o.order_date, 
    o.customer_name, 
    o.price, 
    o.product_id, 
    o.order_status, 
    p.name as product_name, 
    p.description as product_description, 
    s.shipment_id, 
    s.origin, 
    s.destination, 
    s.is_arrived, 
    ip2Address('218.107.213.115', 'country') as country
FROM orders AS o
LEFT JOIN products AS p ON o.product_id = p.id;
LEFT JOIN shipments AS s ON o.order_id = s.order_id;