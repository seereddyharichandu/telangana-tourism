------q2
---- top3 districts with high growth rate 
SELECT 
   top 3
    district,
    CASE 
        WHEN SUM(CASE WHEN year = 2016 THEN visitors ELSE 0 END) = 0 
            THEN NULL 
        ELSE ((SUM(CASE WHEN year = 2019 THEN visitors ELSE 0 END) - SUM(CASE WHEN year = 2016 THEN visitors ELSE 0 END)) / SUM(CASE WHEN year = 2016 THEN visitors ELSE 0 END)) * 100
    END AS increase_percentage
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
order by increase_percentage desc

