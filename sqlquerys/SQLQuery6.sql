-----q6
---- Q6 this for top5 and bottom 5 the ratio of total visitors to total poulation 
SELECT top 5
    COALESCE(DV.District, FV.District, S2.District) AS District,
   --- COALESCE(SUM(DV.Visitors), 0) AS DomesticVisitors,
   ---COALESCE(SUM(FV.Visitors), 0) AS ForeignVisitors,
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
SELECT top 5  *
FROM (
    SELECT COALESCE(DV.District, FV.District, S2.District) AS District,
       --- COALESCE(SUM(DV.Visitors), 0) AS DomesticVisitors,
       --- COALESCE(SUM(FV.Visitors), 0) AS ForeignVisitors,
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
) AS subquery
---WHERE VisitorsRatioToPopulation IS NOT NULL AND VisitorsRatioToPopulation <> 0
ORDER BY VisitorsRatioToPopulation ASC