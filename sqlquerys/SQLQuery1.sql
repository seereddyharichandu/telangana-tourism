-----q1
--- top10 districts that has highest number of domesticvisitors 
SELECT TOP 10 district, SUM(visitors) AS TotalVisitors
FROM [dbo].[domestic_visitors$]
GROUP BY District
ORDER BY TotalVisitors DESC