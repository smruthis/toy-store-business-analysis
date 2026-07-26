#Which Traffic Source Has the Highest Conversion Rate?
SELECT ws.utm_source, COUNT(DISTINCT ws.website_session_id) AS total_sessions,
COUNT(DISTINCT o.order_id) AS total_orders,
ROUND(COUNT(DISTINCT o.order_id) * 100.0 /COUNT(DISTINCT ws.website_session_id),2) AS conversion_rate
FROM website_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id
WHERE ws.utm_source IS NOT NULL
GROUP BY ws.utm_source
ORDER BY conversion_rate DESC;


#Which marketing source generates the highest revenue?
SELECT
    ws.utm_source,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price_usd),2) AS total_revenue
FROM website_sessions ws
JOIN orders o
    ON ws.website_session_id = o.website_session_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE ws.utm_source IS NOT NULL
GROUP BY ws.utm_source
ORDER BY total_revenue DESC;



#How did the website conversion rate change month by month?
SELECT YEAR(ws.created_at) AS year, MONTH(ws.created_at) AS month,
COUNT(DISTINCT ws.website_session_id) AS total_sessions,
COUNT(DISTINCT o.order_id) AS total_orders,
ROUND(COUNT(DISTINCT o.order_id) * 100.0 /COUNT(DISTINCT ws.website_session_id),2) AS conversion_rate
FROM website_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id
GROUP BY YEAR(ws.created_at), MONTH(ws.created_at)
ORDER BY year, month;

#How does each traffic source perform month by month?
SELECT
    YEAR(ws.created_at) AS year,
    MONTH(ws.created_at) AS month,
    ws.utm_source,
    COUNT(DISTINCT ws.website_session_id) AS total_sessions,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(COUNT(DISTINCT o.order_id) * 100.0 / COUNT(DISTINCT ws.website_session_id),2) AS conversion_rate
FROM website_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id
WHERE ws.utm_source IS NOT NULL
GROUP BY YEAR(ws.created_at), MONTH(ws.created_at), ws.utm_source
ORDER BY year, month, ws.utm_source;