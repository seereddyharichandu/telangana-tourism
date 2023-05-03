------q3
----- top 3 districts with low growth rate 
SELECT 
  top 3
    district,
    ((SUM(CASE WHEN year = 2019 THEN visitors ELSE 0 END) - SUM(CASE WHEN year = 2016 THEN visitors ELSE 0 END)) / NULLIF(SUM(CASE WHEN year = 2016 THEN visitors ELSE 0 END),0)) * 100 AS decrease_percent
FROM 
    (
    SELECT district, year, SUM(visitors) AS visitors
    FROM 
        (
        SELECT district, year, visitors FROM [dbo].[domestic_visitors$]
        UNION ALL
        SELECT district, year, visitors FROM [dbo].[foreign_visitors$]
        ) AS v
    GROUP BY district, year
    ) AS t
WHERE year BETWEEN 2016 AND 2019
GROUP BY district
HAVING SUM(CASE WHEN year = 2016  THEN visitors ELSE 0 END) <> 0
ORDER BY decrease_percent ASC
