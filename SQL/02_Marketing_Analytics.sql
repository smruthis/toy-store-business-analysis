#Find the number of website sessions for each traffic source, sorted from highest to lowest.
SELECT utm_source, COUNT(website_session_id) AS total_sessions
FROM website_sessions
GROUP BY utm_source
ORDER BY total_sessions DESC;

#Which traffic source generated the highest number of orders?
SELECT ws.utm_source, COUNT(o.order_id) AS total_orders
FROM website_sessions ws
INNER JOIN orders o
    ON ws.website_session_id = o.website_session_id
GROUP BY ws.utm_source
ORDER BY total_orders DESC;

#Which traffic source has the highest conversion rate?
SELECT ws.utm_source,
    COUNT(DISTINCT ws.website_session_id) AS total_sessions,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(
        COUNT(DISTINCT o.order_id) * 100.0 /
        COUNT(DISTINCT ws.website_session_id),
        2
    ) AS conversion_rate
FROM website_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id
GROUP BY ws.utm_source
ORDER BY conversion_rate DESC;

#Which marketing campaign (utm_campaign) generated the highest number of orders?
SELECT
    ws.utm_campaign,
    COUNT(o.order_id) AS total_orders
FROM website_sessions ws
INNER JOIN orders o
    ON ws.website_session_id = o.website_session_id
GROUP BY ws.utm_campaign
ORDER BY total_orders DESC;

#Which device converts better: Desktop or Mobile?
SELECT
    ws.device_type,
    COUNT(DISTINCT ws.website_session_id) AS total_sessions,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(
        COUNT(DISTINCT o.order_id) * 100.0 /
        COUNT(DISTINCT ws.website_session_id),
        2
    ) AS conversion_rate
FROM website_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id
GROUP BY ws.device_type
ORDER BY conversion_rate DESC;

#Which traffic source generates the highest revenue?
SELECT
    ws.utm_source,
    ROUND(SUM(o.price_usd), 2) AS total_revenue
FROM website_sessions ws
INNER JOIN orders o
    ON ws.website_session_id = o.website_session_id
GROUP BY ws.utm_source
ORDER BY total_revenue DESC;

