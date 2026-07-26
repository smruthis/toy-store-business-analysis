#How has monthly revenue changed over time?
SELECT YEAR(o.created_at) AS order_year, MONTH(o.created_at) AS order_month,
ROUND(SUM(oi.price_usd),2) AS monthly_revenue
FROM orders o JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY YEAR(o.created_at), MONTH(o.created_at)
ORDER BY order_year, order_month;


#How many orders were placed each month?
SELECT YEAR(created_at) AS order_year, MONTH(created_at) AS order_month,
COUNT(order_id) AS total_orders
FROM orders
GROUP BY YEAR(created_at), MONTH(created_at)
ORDER BY order_year, order_month;


#What is the Average Order Value (AOV) each month?
SELECT YEAR(o.created_at) AS order_year, MONTH(o.created_at) AS order_month,
ROUND(SUM(oi.price_usd),2) AS total_revenue,
COUNT(DISTINCT o.order_id) AS total_orders,
ROUND(SUM(oi.price_usd) / COUNT(DISTINCT o.order_id),2) AS average_order_value
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY YEAR(o.created_at), MONTH(o.created_at)
ORDER BY order_year, order_month;



#How many refunds occurred each month?
SELECT YEAR(oir.created_at) AS refund_year, MONTH(oir.created_at) AS refund_month, 
COUNT(oir.order_item_refund_id) AS total_refunds
FROM order_item_refunds oir
GROUP BY YEAR(oir.created_at), MONTH(oir.created_at)
ORDER BY refund_year, refund_month;



#What is the total refund amount by month?
SELECT YEAR(oir.created_at) AS refund_year,
    MONTH(oir.created_at) AS refund_month,
    ROUND(SUM(oi.price_usd),2) AS total_refund_amount
FROM order_item_refunds oir
JOIN order_items oi
    ON oir.order_item_id = oi.order_item_id
GROUP BY
    YEAR(oir.created_at),
    MONTH(oir.created_at)
ORDER BY
    refund_year,
    refund_month;
    

#What is the net revenue after accounting for refunds?
SELECT
    YEAR(o.created_at) AS order_year,
    MONTH(o.created_at) AS order_month,

    ROUND(SUM(oi.price_usd), 2) AS gross_revenue,

    ROUND(
        SUM(
            CASE
                WHEN oir.order_item_refund_id IS NOT NULL THEN oi.price_usd
                ELSE 0
            END
        ),
        2
    ) AS refund_amount,

    ROUND(
        SUM(oi.price_usd) -
        SUM(
            CASE
                WHEN oir.order_item_refund_id IS NOT NULL THEN oi.price_usd
                ELSE 0
            END
        ),
        2
    ) AS net_revenue

FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
LEFT JOIN order_item_refunds oir
    ON oi.order_item_id = oir.order_item_id

GROUP BY
    YEAR(o.created_at),
    MONTH(o.created_at)

ORDER BY
    order_year,
    order_month;