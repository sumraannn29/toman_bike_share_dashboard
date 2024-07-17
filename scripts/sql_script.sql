WITH cte AS 
(SELECT * 
    FROM bike_share_yr_0
UNION ALL
SELECT * 
    FROM bike_share_yr_1)


SELECT 
dteday,
season,
cte.yr,
weekday,
hr,
rider_type,
riders,
price,
cogs,
riders*price as revenue,
riders*price - cogs*riders as profit
    FROM cte
LEFT JOIN cost_table
ON cte.yr = cost_table.yr
