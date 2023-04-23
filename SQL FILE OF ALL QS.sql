




-----q1
--- top10 districts that has highest number of domesticvisitors 
SELECT TOP 10 district, SUM(visitors) AS TotalVisitors
FROM [dbo].[domestic_visitors$]
GROUP BY District
ORDER BY TotalVisitors DESC

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
HAVING SUM(CASE WHEN year = 2016 THEN visitors ELSE 0 END) <> 0
ORDER BY decrease_percent ASC


	
-----q4
---- top 3 and bottom 3 peakmonths of hyderabad from 2016 to 2019
SELECT TOP 3
    MONTH as peakmonth,
    SUM(VISITORS) AS TotalVisitors,
    SUM(VISITORS) / 4.0 AS AvgVisitorsPeryear
FROM 
    [dbo].[domestic_visitors$]
WHERE 
    DISTRICT = 'Hyderabad'
GROUP BY 
    MONTH
ORDER BY 
    TotalVisitors DESC


------ this are the lowmonths 
SELECT top 3
    MONTH as lowmonths,
    SUM(VISITORS) AS TotalVisitors,
    SUM(VISITORS) / 4.0 AS AvgVisitorsPeryear---------there i divided with 4 because the total is for 4 years 
FROM 
    [dbo].[domestic_visitors$]
WHERE 
    DISTRICT = 'Hyderabad'
GROUP BY 
    MONTH
ORDER BY 
    TotalVisitors ASC

-----q5
----this is for top 3 and bottom 3 foreign and domesticvisitors ratio 
WITH 
    FORTotalVisitors AS (
        SELECT  
            district, 
            SUM(visitors) AS FORTotalVisitors
        FROM  
            [dbo].[foreign_visitors$]
        GROUP BY 
            district
    ),
    DOMTotalVisitors AS (
        SELECT 
            district, 
            SUM(visitors) AS DOMTotalVisitors
        FROM 
            [dbo].[domestic_visitors$]
        GROUP BY 
            district
    ),
    RatioByDistrict AS (
        SELECT 
            DOMTotalVisitors.district,
            ISNULL(DOMTotalVisitors.DOMTotalVisitors / NULLIF(FORTotalVisitors.FORTotalVisitors, 0), 0) AS Ratio
        FROM 
            FORTotalVisitors 
            INNER JOIN DOMTotalVisitors ON FORTotalVisitors.district = DOMTotalVisitors.district
    )
SELECT top 3 
    RatioByDistrict.district,
    RatioByDistrict.Ratio
FROM 
    RatioByDistrict
WHERE 
    Ratio <> 0
ORDER BY 
    Ratio DESC;
	-----this for the bottom 3
WITH 
    FORTotalVisitors AS (
        SELECT  
            district, 
            SUM(visitors) AS FORTotalVisitors
        FROM  
            [dbo].[foreign_visitors$]
        GROUP BY 
            district
    ),
    DOMTotalVisitors AS (
        SELECT 
            district, 
            SUM(visitors) AS DOMTotalVisitors
        FROM 
            [dbo].[domestic_visitors$]
        GROUP BY 
            district
    ),
    RatioByDistrict AS (
        SELECT 
            DOMTotalVisitors.district,
            ISNULL(DOMTotalVisitors.DOMTotalVisitors / NULLIF(FORTotalVisitors.FORTotalVisitors, 0), 0) AS Ratio
        FROM 
            FORTotalVisitors 
            INNER JOIN DOMTotalVisitors ON FORTotalVisitors.district = DOMTotalVisitors.district
    )
	SELECT TOP 3 
    RatioByDistrict.district,
    RatioByDistrict.Ratio
FROM 
    RatioByDistrict
WHERE 
    Ratio <> 0
ORDER BY 
    Ratio asc;


-----q6
---- Q6 this for top5 and bottom 5 the ratio of total visitors to total poulation 
SELECT top 5
    COALESCE(DV.District, FV.District, S2.District) AS District,
    COALESCE(SUM(DV.Visitors), 0) AS DomesticVisitors,
    COALESCE(SUM(FV.Visitors), 0) AS ForeignVisitors,
    COALESCE(S2.Population, 0) AS Population,
    CASE WHEN COALESCE(S2.Population, 0) > 0 
         THEN (COALESCE(SUM(DV.Visitors), 0) + COALESCE(SUM(FV.Visitors), 0)) / (S2.Population) 
         ELSE NULL 
    END AS VisitorsRatioToPopulation
FROM [dbo].[domestic_visitors$] AS DV
FULL OUTER JOIN [dbo].[foreign_visitors$] AS FV ON DV.District = FV.District AND DV.Year = FV.Year AND DV.Month = FV.Month
FULL OUTER JOIN [dbo].[Sheet2$a] AS S2 ON COALESCE(DV.District, FV.District) = S2.District AND COALESCE(DV.Year, FV.Year) = S2.Year
WHERE COALESCE(DV.Year, FV.Year, S2.Year) = 2019 
GROUP BY COALESCE(DV.District, FV.District, S2.District), S2.Population
ORDER BY VisitorsRatioToPopulation  desc

--- bottom 5
SELECT top 5
    COALESCE(DV.District, FV.District, S2.District) AS District,
    COALESCE(SUM(DV.Visitors), 0) AS DomesticVisitors,
    COALESCE(SUM(FV.Visitors), 0) AS ForeignVisitors,
    COALESCE(S2.Population, 0) AS Population,
    CASE WHEN COALESCE(S2.Population, 0) > 0 
         THEN (COALESCE(SUM(DV.Visitors), 0) + COALESCE(SUM(FV.Visitors), 0)) / (S2.Population) 
         ELSE NULL 
    END AS VisitorsRatioToPopulation
FROM [dbo].[domestic_visitors$] AS DV
FULL OUTER JOIN [dbo].[foreign_visitors$] AS FV ON DV.District = FV.District AND DV.Year = FV.Year AND DV.Month = FV.Month
FULL OUTER JOIN [dbo].[Sheet2$a] AS S2 ON COALESCE(DV.District, FV.District) = S2.District AND COALESCE(DV.Year, FV.Year) = S2.Year
WHERE COALESCE(DV.Year, FV.Year, S2.Year) = 2019 
GROUP BY COALESCE(DV.District, FV.District, S2.District), S2.Population
ORDER BY VisitorsRatioToPopulation  ASC
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
		(((SUM(total_visitors)/4)*6 )/81)*80 as projected_domestic_visitors,
		(((SUM(total_visitors)/4)*6 )/81)*1 as projected_foreign_visitors
    FROM historical_data
)
SELECT projected_total_visitors ,projected_domestic_visitors,projected_foreign_visitors FROM projected_data;


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
        ((SUM(total_visitors)/4) ) AS projected_total_visitors
    FROM historical_data
),
revenue_data AS (
    SELECT 
         (projected_total_visitors / 81) * 80 AS domestic_visitors,
        ( projected_total_visitors / 81) * 1 AS foreign_visitors
    FROM projected_data
)
SELECT 
    (domestic_visitors * 1200)/82 AS domestic_revenue2025$,
    (foreign_visitors * 5600)/82 AS foreign_revenue2025$,
    ((domestic_visitors * 1200)/82) + ((foreign_visitors * 5600)/82)  AS projectedtotal_revenue2025
FROM revenue_data;


