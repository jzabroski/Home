# Where Shared
Keeping track of where this page is shared allows me to update trackback links so that there are no 404s to this page.

1. https://github.com/dotnet/efcore/issues/4693#issuecomment-624068637
2. As a link in client documentation on using SQL Server Temporal Tables with EF

# See Also

You may be able to use IDbCommandTreeInterceptor to solve some of these problems.  A summary of tricks found on StackOverflow can be found here: https://github.com/jzabroski/Home/blob/b68b048692296f8b163a82c9f467a1a784f2bba4/EntityFramework/EF6/IDbCommandTreeInterceptor/README.md

# Overview
This example demonstrates how to de-sugar temporal table `FOR SYSTEM_TIME AS OF` syntactic sugar.

```sql
USE master
GO

DROP DATABASE IF EXISTS SqlExampleQueryingTemporalDB
GO

CREATE DATABASE SqlExampleQueryingTemporalDB
GO
USE SqlExampleQueryingTemporalDB
GO
CREATE TABLE dbo.Customer 
(  
  Id INT NOT NULL PRIMARY KEY CLUSTERED,
  Name NVARCHAR(100) NOT NULL, 
  StartTime DATETIME2 GENERATED ALWAYS AS ROW START
            HIDDEN NOT NULL,
  EndTime   DATETIME2 GENERATED ALWAYS AS ROW END
            HIDDEN NOT NULL,
  PERIOD FOR SYSTEM_TIME (StartTime, EndTime)   
) 
WITH(SYSTEM_VERSIONING= ON (HISTORY_TABLE=dbo.CustomerHistory))
GO


INSERT INTO dbo.Customer VALUES (1,'John')
GO
WAITFOR DELAY '00:00:10'
GO
UPDATE dbo.Customer SET Name = 'John Zabroski' WHERE Id = 1
GO
WAITFOR DELAY '00:00:10'
GO
UPDATE dbo.Customer SET Name = 'John A Zabroski'
WHERE Id = 1
GO
WAITFOR DELAY '00:00:10'
GO
UPDATE dbo.Customer SET Name = 'John Alexander Zabroski'
WHERE Id = 1
GO

SET STATISTICS XML ON;
GO -- The SET STATISTICS statements must be the only statements in the batch.

/* To verify these plans are equivalent under default temporal table conditions
   (e.g., column-store index on date range), you can:
   1. Execute this file in SSMS Grid Results Mode.
   2. Click on the blue "<ShowPlanXML ..." links in query 1 to open it in a new tab.
   3. In the new tab, right-click and select "Save Execution Plan As...",
      and save it in the default location as 'SqlExampleQueryingTemporalDB_ExecutionPlan1.sqlplan'
   4. Go back to the results tab.
   5. Click on the blue "<ShowPlanXML ..." link in quey 2 to open it in a new tab.
   6. In the new tab, right-click and select "Compare Showplan".
   7. In the file dialog, choose the file we saved in step 3:
      'SqlExampleQueryingTemporalDB_ExecutionPlan1.sqlplan'
*/

-- First edit
DECLARE @FlashBackDate DATETIME2 = DATEADD(SECOND, -15, SYSUTCDATETIME())
SELECT Id, Name, StartTime, EndTime 
FROM dbo.Customer
FOR SYSTEM_TIME AS OF @FlashBackDate;

DECLARE @PointInTime DATETIME = @FlashBackDate
SELECT Id, Name, StartTime, EndTime 
FROM dbo.Customer
WHERE StartTime<= @PointInTime  AND EndTime > @PointInTime 
UNION ALL
SELECT Id, Name, StartTime, EndTime 
FROM dbo.CustomerHistory
WHERE StartTime<= @PointInTime  AND EndTime > @PointInTime 
GO

; WITH PointInTime (Date) AS (
	SELECT Date = @FlashBackDate
)
SELECT c.Id, c.Name, c.StartTime, c.EndTime 
FROM dbo.Customer c
	INNER JOIN PointInTime PIT ON
		 c.StartTime<= pit.Date  AND c.EndTime > pit.Date 
UNION ALL
SELECT ch.Id, ch.Name, ch.StartTime, ch.EndTime 
FROM dbo.CustomerHistory ch
	INNER JOIN PointInTime PIT ON
		ch.StartTime<= pit.Date  AND ch.EndTime > pit.Date
GO

-- Second edit
DECLARE @FlashBackDate DATETIME2 = DATEADD(SECOND, -5, SYSUTCDATETIME())
SELECT Id, Name, StartTime, EndTime 
FROM dbo.Customer
FOR SYSTEM_TIME AS OF @FlashBackDate

DECLARE @PointInTime DATETIME = @FlashBackDate
SELECT Id, Name, StartTime, EndTime 
FROM dbo.Customer
WHERE StartTime<= @PointInTime  AND EndTime > @PointInTime 
UNION ALL
SELECT Id, Name, StartTime, EndTime 
FROM dbo.CustomerHistory
WHERE StartTime<= @PointInTime  AND EndTime > @PointInTime 
GO

; WITH PointInTime (Date) AS (
	SELECT Date = @FlashBackDate
)
SELECT c.Id, c.Name, c.StartTime, c.EndTime 
FROM dbo.Customer c
	INNER JOIN PointInTime PIT ON
		 c.StartTime<= pit.Date  AND c.EndTime > pit.Date 
UNION ALL
SELECT ch.Id, ch.Name, ch.StartTime, ch.EndTime 
FROM dbo.CustomerHistory ch
	INNER JOIN PointInTime PIT ON
		ch.StartTime<= pit.Date  AND ch.EndTime > pit.Date
GO

-- Third edit
DECLARE @FlashBackDate DATETIME2 = DATEADD(SECOND, 0, SYSUTCDATETIME())
SELECT Id, Name, StartTime, EndTime 
FROM dbo.Customer
FOR SYSTEM_TIME AS OF @FlashBackDate

DECLARE @PointInTime DATETIME = @FlashBackDate
SELECT Id, Name, StartTime, EndTime 
FROM dbo.Customer
WHERE StartTime<= @PointInTime  AND EndTime > @PointInTime 
UNION ALL
SELECT Id, Name, StartTime, EndTime 
FROM dbo.CustomerHistory
WHERE StartTime<= @PointInTime  AND EndTime > @PointInTime 
GO

; WITH PointInTime (Date) AS (
	SELECT Date = @FlashBackDate
)
SELECT c.Id, c.Name, c.StartTime, c.EndTime 
FROM dbo.Customer c
	INNER JOIN PointInTime PIT ON
		 c.StartTime<= pit.Date  AND c.EndTime > pit.Date 
UNION ALL
SELECT ch.Id, ch.Name, ch.StartTime, ch.EndTime 
FROM dbo.CustomerHistory ch
	INNER JOIN PointInTime PIT ON
		ch.StartTime<= pit.Date  AND ch.EndTime > pit.Date
GO

SET STATISTICS XML OFF;
GO  -- The SET STATISTICS statements must be the only statements in the batch.
```
