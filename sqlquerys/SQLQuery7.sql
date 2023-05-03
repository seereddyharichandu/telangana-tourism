------Q7 
------ the projection of total visitors in hyderabad in 2025
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
        ((SUM(total_visitors)/4) ) AS projected_total_visitors,
		(((SUM(total_visitors)/4) )/81)*80 as projected_domestic_visitors,
		(((SUM(total_visitors)/4) )/81)*1 as projected_foreign_visitors
    FROM historical_data
)
SELECT projected_total_visitors ,projected_domestic_visitors,projected_foreign_visitors FROM projected_data;
