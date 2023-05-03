
----- q8 
----projecting the revenue of hyderabadin 2025
WITH historical_data AS (
    SELECT
        COALESCE(SUM(dv.visitors), 0) AS domestic_visitors,
        COALESCE(SUM(fv.visitors), 0) AS foreign_visitors,
        COALESCE(SUM(dv.visitors), 0) + COALESCE(SUM(fv.visitors), 0) AS total_visitors,
        dv.year
    FROM [dbo].[domestic_visitors$] AS dv
    FULL OUTER JOIN [dbo].[foreign_visitors$] AS fv ON dv.District = fv.District AND dv.Year = fv.Year and dv.month = fv.month
    WHERE dv.district = 'hyderabad'
    GROUP BY dv.year
),
projected_data AS (
    SELECT
        2025 AS year,
        COALESCE(SUM(total_visitors), 0) AS total_visitors,
        ((SUM(total_visitors)/4)) AS projected_total_visitors
    FROM historical_data
),
revenue_data AS (
    SELECT 
         (projected_total_visitors / 81) * 80 AS domestic_visitors,
        ( projected_total_visitors / 81) * 1 AS foreign_visitors
    FROM projected_data
)
SELECT 
    (domestic_visitors * 1200) AS domestic_revenue2025,
    (foreign_visitors * 5600) AS foreign_revenue2025,
    ((domestic_visitors * 1200)) + ((foreign_visitors * 5600))  AS projectedtotal_revenue2025
FROM revenue_data;


