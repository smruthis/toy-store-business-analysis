#How many visitors reached each page?
SELECT pageview_url,
    COUNT(DISTINCT website_session_id) AS visitors
FROM website_pageviews
GROUP BY pageview_url
ORDER BY visitors DESC;

#Which page has the highest drop-off?
SELECT pageview_url, COUNT(DISTINCT website_session_id) AS visitors
FROM website_pageviews
WHERE pageview_url IN ('/home','/products','/the-original-mr-fuzzy','/cart','/shipping',
'/billing','/thank-you-for-your-order')
GROUP BY pageview_url
ORDER BY visitors DESC;

#Which landing page performs best?
SELECT wp.pageview_url AS landing_page, COUNT(*) AS total_sessions
FROM website_pageviews wp
JOIN (SELECT website_session_id, MIN(website_pageview_id) AS first_pageview_id
    FROM website_pageviews
    GROUP BY website_session_id
) fp
ON wp.website_pageview_id = fp.first_pageview_id
GROUP BY wp.pageview_url
ORDER BY total_sessions DESC;


#Overall Conversion Funnel
SELECT
    SUM(home) AS home_sessions,
    SUM(products) AS product_sessions,
    SUM(product_page) AS product_page_sessions,
    SUM(cart) AS cart_sessions,
    SUM(shipping) AS shipping_sessions,
    SUM(billing) AS billing_sessions,
    SUM(purchase) AS purchase_sessions
FROM
(
    SELECT
        website_session_id,

        MAX(CASE WHEN pageview_url='/home' THEN 1 ELSE 0 END) AS home,
        MAX(CASE WHEN pageview_url='/products' THEN 1 ELSE 0 END) AS products,
        MAX(CASE WHEN pageview_url='/the-original-mr-fuzzy' THEN 1 ELSE 0 END) AS product_page,
        MAX(CASE WHEN pageview_url='/cart' THEN 1 ELSE 0 END) AS cart,
        MAX(CASE WHEN pageview_url='/shipping' THEN 1 ELSE 0 END) AS shipping,
        MAX(CASE WHEN pageview_url='/billing' THEN 1 ELSE 0 END) AS billing,
        MAX(CASE WHEN pageview_url='/thank-you-for-your-order' THEN 1 ELSE 0 END) AS purchase

    FROM website_pageviews
    GROUP BY website_session_id
) funnel;

