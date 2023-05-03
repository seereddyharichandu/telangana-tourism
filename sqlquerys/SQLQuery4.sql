-----q4
---- top 3 and bottom 3 peakmonths of hyderabad from 2016 to 2019
SELECT  TOP 3
    MONTH as peakmonth,
    SUM(VISITORS) AS TotalVisitors,
    SUM(VISITORS) / 4.0 AS AvgVisitorsPeryear
FROM 
       (
    SELECT district, MONTH, SUM(visitors) AS visitors
    FROM 
        (
        SELECT district,MONTH , visitors FROM [dbo].[domestic_visitors$]
        UNION ALL
        SELECT district, MONTH, visitors FROM [dbo].[foreign_visitors$]
        ) AS v
    GROUP BY district, MONTH
    ) AS t

WHERE 
    DISTRICT = 'Hyderabad' 
GROUP BY 
    MONTH  
ORDER BY 
      AvgVisitorsPeryear desc


------ this are the lowmonths 

SELECT  TOP 3
    MONTH as peakmonth,
    SUM(VISITORS) AS TotalVisitors,
    SUM(VISITORS) / 4.0 AS AvgVisitorsPeryear
FROM 
       (
    SELECT district, MONTH, SUM(visitors) AS visitors
    FROM 
        (
        SELECT district,MONTH , visitors FROM [dbo].[domestic_visitors$]
        UNION ALL
        SELECT district, MONTH, visitors FROM [dbo].[foreign_visitors$]
        ) AS v
    GROUP BY district, MONTH
    ) AS t

WHERE 
    DISTRICT = 'Hyderabad' 
GROUP BY 
    MONTH  
ORDER BY 
      AvgVisitorsPeryear asc