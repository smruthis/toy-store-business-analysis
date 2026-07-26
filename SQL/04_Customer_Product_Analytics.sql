#Which products generate the highest revenue?
SELECT
    p.product_name,
    ROUND(SUM(oi.price_usd),2) AS total_revenue
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;


#Which products sold the highest number of units?
SELECT
    p.product_name,
    COUNT(oi.order_item_id) AS units_sold
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY units_sold DESC;


#Which products have the highest average selling price?
SELECT
    p.product_name,
    ROUND(AVG(oi.price_usd),2) AS average_selling_price
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY average_selling_price DESC;


#Which products have the highest refund rate?
SELECT
    p.product_name,
    COUNT(DISTINCT oi.order_item_id) AS total_items_sold,
    COUNT(DISTINCT oir.order_item_refund_id) AS total_refunds,
    ROUND(
        COUNT(DISTINCT oir.order_item_refund_id) * 100.0 /
        COUNT(DISTINCT oi.order_item_id),
        2
    ) AS refund_rate
FROM order_items oi
LEFT JOIN order_item_refunds oir
    ON oi.order_item_id = oir.order_item_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY refund_rate DESC;

#What percentage of total revenue comes from each product?
SELECT
    p.product_name,
    ROUND(SUM(oi.price_usd),2) AS revenue,
    ROUND(
        SUM(oi.price_usd) * 100.0 /
        (
            SELECT SUM(price_usd)
            FROM order_items
        ),
        2
    ) AS revenue_contribution_pct
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC;


#Which customers place the most orders?
SELECT
    user_id,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY user_id
ORDER BY total_orders DESC
LIMIT 10;

