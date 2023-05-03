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