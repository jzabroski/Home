# Dynamic Range Queries
1. https://gertjans.home.xs4all.nl/sql/date-range-scans.html
2. https://blogs.solidq.com/en/businessanalytics/interval-queries-in-sql-server-part-2/
3. https://www.itprotoday.com/software-development/interval-queries-sql-server

See also:
1. https://www.red-gate.com/simple-talk/sql/t-sql-programming/sql-server-spatial-indexes/
> SQL Server 2012 has added support for the auto grid spatial index, available for both the geography and geometry data types. An auto grid uses eight levels instead of the usual four levels. The advantage of using an auto grid is that when creating an index we can get good index support without studying the queries that will run against the table. In addition, you do not need to add a GRIDS clause to your CREATE SPATIAL INDEX statement because the database engine determines the best strategy to use to maximize performance.

# Spatial Indexes
1. [How to ensure your spatial index is being used - Bob Beauchemin](http://sqlskills.com/BLOGS/BOBB/post/How-to-ensure-your-spatial-index-is-being-used.aspx)
2. [Is my spatial index being used? - Isaac Kunen](https://blogs.msdn.microsoft.com/isaac/2008/08/29/is-my-spatial-index-being-used/)
3. [Spatial Index Diagnostic Procs – Intro - Bob Beauchemin](https://www.sqlskills.com/blogs/bobb/spatial-index-diagnostic-procs-intro/)

# Working With Partitions
It can be a quick win for many customers to get them to use partitions.
## How to Partition an existing SQL Server Table
https://www.mssqltips.com/sqlservertip/2888/how-to-partition-an-existing-sql-server-table/
## Fast Delete From Partition
https://dba.stackexchange.com/questions/171625/what-could-be-the-fastest-way-to-delete-all-data-from-a-partition-of-a-partition

# Common Date Routines

```sql
DECLARE @ThisDate DATETIME;
SET @ThisDate = GETDATE();

SELECT DATEADD(DAY, DATEDIFF(DAY, 0, @ThisDate), 0)     -- Beginning of this day
SELECT DATEADD(DAY, DATEDIFF(DAY, 0, @ThisDate) + 1, 0) -- Beginning of next day
SELECT DATEADD(DAY, DATEDIFF(DAY, 0, @ThisDate) - 1, 0) -- Beginning of previous day
SELECT DATEADD(WEEK, DATEDIFF(WEEK, 0, @ThisDate), 0)     -- Beginning of this week (Monday)
SELECT DATEADD(WEEK, DATEDIFF(WEEK, 0, @ThisDate) + 1, 0) -- Beginning of next week (Monday)
SELECT DATEADD(WEEK, DATEDIFF(WEEK, 0, @ThisDate) - 1, 0) -- Beginning of previous week (Monday)
SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @ThisDate), 0)     -- Beginning of this month
SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @ThisDate) + 1, 0) -- Beginning of next month
SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @ThisDate) - 1, 0) -- Beginning of previous month
SELECT DATEADD(QUARTER, DATEDIFF(QUARTER, 0, @ThisDate), 0)     -- Beginning of this quarter (Calendar)
SELECT DATEADD(QUARTER, DATEDIFF(QUARTER, 0, @ThisDate) + 1, 0) -- Beginning of next quarter (Calendar)
SELECT DATEADD(QUARTER, DATEDIFF(QUARTER, 0, @ThisDate) - 1, 0) -- Beginning of previous quarter (Calendar)
SELECT DATEADD(YEAR, DATEDIFF(YEAR, 0, @ThisDate), 0)     -- Beginning of this year
SELECT DATEADD(YEAR, DATEDIFF(YEAR, 0, @ThisDate) + 1, 0) -- Beginning of next year
SELECT DATEADD(YEAR, DATEDIFF(YEAR, 0, @ThisDate) - 1, 0) -- Beginning of previous year
```

# Less Common Date Routines
From Books OnLine:
> When you refer to date data type string literals in indexed computed columns in SQL Server, we recommend that you explicitly convert the literal to the date type that you want by using a deterministic date format style. For a list of the date format styles that are deterministic, see `CAST` and `CONVERT`. Expressions that involve implicit conversion of character strings to date data types are considered nondeterministic, unless the database compatibility level is set to 80 or earlier. This is because the results depend on the LANGUAGE and `DATEFORMAT` settings of the server session. For example, the results of the expression `CONVERT (datetime, '30 listopad 1996', 113)` depend on the LANGUAGE setting because the string '30 listopad 1996' means different months in different languages. Similarly, in the expression `DATEADD(mm,3,'2000-12-01')`, the Database Engine interprets the string `'2000-12-01'` based on the `DATEFORMAT` setting.

```sql
-- Convert from UNIX to SQL DateTime (Nondeterministic - cannot be used in a computed column)
SELECT DATEADD(SECOND, @SecondsFromsUnixEpoch / 1000, '19700101')

-- Convert from SQL DateTime to UNIX, 5 hour offset from GMT time (Nondeterministic - cannot be used in a computed column)
SELECT CAST(DATEDIFF(SECOND, '19700101', DATEADD(HOUR, 5, CAST('2012-10-10 14:05:55.000' AS DATETIME))) AS BIGINT) * 1000 

-- Convert from UNIX to SQL DateTime (Deterministic - can be used in a computed column)
SELECT DATEADD(SECOND, @SecondsFromsUnixEpoch / 1000, CONVERT(DATE, '1970-01-01', 120))

-- Convert from SQL DateTime to UNIX, 5 hour offset from GMT time (Deterministic - can be used in a computed column)
SELECT CAST(DATEDIFF(SECOND, CONVERT(DATE, '1970-01-01', 120), DATEADD(HOUR, 5, CAST('2012-10-10 14:05:55.000' AS DATETIME))) AS BIGINT) * 1000 
```

Direct conversion from C# to TSQL:
```csharp
DateTimeOffset.TryParse("1915-12-31 06:00:00.0000000 +00:00", out var dt);
Console.WriteLine(dt.ToUnixTimeSeconds()); // -1704218400
```
```sql
DECLARE @DateTimeOS DATETIMEOFFSET(7) = CAST('1915-12-31 06:00:00.0000000 +00:00' AS DATETIMEOFFSET)
DECLARE @UnixDate BIGINT = CAST(DATEDIFF(SECOND, CONVERT(DATE, '1970-01-01', 120), DATEADD(HOUR, 0, CAST(@DateTimeOS AS DATETIME))) AS BIGINT)
SELECT @UnixDate -- -1704218400
```

# SQL Permissions with AD Groups

Be careful using AD Groups to define roles. See: https://docs.microsoft.com/en-us/sql/t-sql/statements/create-user-transact-sql?view=sql-server-2017 and also: https://docs.microsoft.com/en-us/sql/relational-databases/security/permissions-database-engine?view=sql-server-2017#_algorithm

> Beginning with SQL Server 2012, the default schema can also be set for user based on a group login. See http://msdn.microsoft.com/en-in/library/ms173463.aspx:
If the user has a default schema, that default schema will used. If the user does not have a default schema, but the user is a member of a group that has a default schema, the default schema of the group will be used. If the user does not have a default schema, and is a member of more than one group that has a default schema, the schema of the Windows group with the lowest principle_id will be used. (It is not possible to explicitly select one of the available default schemas as the preferred schema.) If no default schema can be determined for a user, the dbo schema will be used.

You can test effective permissions this way:
```sql
-- '<domain>\<username>' is a domain user in the group you wish to test
EXECUTE AS LOGIN = '<domain>\<username>';
SELECT * FROM fn_my_permissions('Database.Schema.Table', 'OBJECT');
REVERT;
```

# WINDOW Function ROWS and RANGE
https://sonra.io/2017/08/22/window-function-rows-and-range-on-redshift-and-bigquery/
1. Frame defined by ROWS
2. Frame defined by RANGE

|      | RANGE clause | numeric values | date values |
| ---- | ------------ | -------------- | ----------- |
|Redshift|✘|✘|✘|
|PostgreSQL|✓|✘|✘|
|BigQuery|✓|✓|✘|
|Oracle|✓|✓|✓|
