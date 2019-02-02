# Bitmap Filters
1. https://www.researchgate.net/publication/4330987_Optimizing_Star_Join_Queries_for_Data_Warehousing_in_Microsoft_SQL_Server
2. Bitmap Filter (Star Join Query Optimization)(https://dwbi1.wordpress.com/2010/03/15/bitmap-filter-star-join-query-optimisation/)
3. [How Much Can One Row Change A Plan, Part 4](https://www.brentozar.com/archive/2018/01/much-can-one-row-change-plan-part-4/)
4. [Columnstore Bitmap Filters](https://orderbyselectnull.com/2017/12/12/columnstore-bitmap-filters/)
5. [Bitmap Magic (or… how SQL Server uses bitmap filters)](http://sqlblog.com/blogs/paul_white/archive/2011/07/07/bitmap-magic.aspx)
> Geoff Patterson wrote: Great article, thanks (several years late, I know)! My whole team has learned a lot about the importance of constructing queries to benefit from the in-row bitmap filter optimization (pushing down to the storage engine) especially.

> Here is a new Connect issue I filed that might also be of interest; it seems that using a partitioned view (or otherwise hitting two or more fact tables via UNION ALL) is a situation in which the query optimizer cannot apply the optimization.

> https://connect.microsoft.com/SQLServer/feedbackdetail/view/974909/push-bitmap-filters-into-storage-engine-through-a-concatentation-operator

> It's hard to be "frustrated" when a new release of SQL Server (new since our data model was constructed, at least) provides such a powerful new benefit, but it certainly would be useful to allow the optimization to be pushed through a concatenation as well!


6. [StarJoinInfo in Execution Plans](https://sqlperformance.com/2014/01/sql-plan/starjoininfo-in-execution-plans)
7. [Optimizing Data Warehouse Query Performance Through Bitmap Filtering](https://docs.microsoft.com/en-us/previous-versions/sql/sql-server-2008-r2/bb522541(v=sql.105))
   > Bitmap filtering and optimized bitmap filtering are implemented in the query plan by using the bitmap showplan operator. Bitmap filtering is applied only in parallel query plans in which hash or merge joins are used. **Optimized bitmap filtering is applicable only to parallel query plans in which hash joins are used.**
8. [Improves the query performance when an optimized bitmap filter is applied to a query plan in SQL Server 2016 and 2017](https://support.microsoft.com/en-us/help/4089276/improve-query-performance-when-optimized-bitmap-filter-used-in-query)
> When a query plan uses a batch-mode hash join where one of the inputs is an optimized bitmap filter with an underlying bookmark lookup or key lookup in Microsoft SQL Server 2016 and SQL Server 2017, inaccurate estimations are produced. This update improves the query performance for the scenario.
> 
> Applies to:
> 
> * Cumulative Update 6 for SQL Server 2017
> * Cumulative update 8 for SQL Server 2016 SP1  
9. https://sqlkiwi.blogspot.com/2011/07/bitmap-magic.html?m=1
> In many cases, the bitmap filter can be pushed all the way down to a scan or seek. 
When this happens, the bitmap filter check appears as a residual predicate  [...] 

> 
> As a residual, it is applied to all rows that pass any seek predicates (for an index seek), or to all rows in the case of an index or table scan. 
> 
> If the bitmap filter is built on a single column or expression of the integer or bigint types, and if the bitmap is to be applied to a single column of integer or bigint type, it might be pushed down the plan even further than the seek or scan operator.

> The predicate is still shown in the seek or scan as above, but it is annotated with the INROWattribute — meaning the filter is pushed into the Storage Engine, and applied to rows as they are being read.

> When this optimization occurs, rows are eliminated before the Query Processor sees the row at all. Only rows that might match the hash match join are passed up from the Storage Engine.



# Dynamic Range Queries
1. https://gertjans.home.xs4all.nl/sql/date-range-scans.html
2. http://blogs.solidq.com/en/businessanalytics/using-static-relational-interval-tree-time-intervals/
3. https://blogs.solidq.com/en/businessanalytics/interval-queries-in-sql-server-part-2/
4. https://www.itprotoday.com/software-development/interval-queries-sql-server
5. https://github.com/icomefromthenet/mysqlfastintervallookup
6. https://pdfs.semanticscholar.org/b473/3096c909ec0f8059bb8ee0e8d4324f635615.pdf
7. Unrelated but useful trick: https://dwbi1.wordpress.com/2010/03/15/bitmap-filter-star-join-query-optimisation/

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
## Partition Basics
1. https://www.cathrinewilhelmsen.net/2015/04/12/table-partitioning-in-sql-server/ - excellent tutorial to share with others
2. https://docs.microsoft.com/en-us/sql/t-sql/functions/partition-transact-sql?view=sql-server-2017 - use `SELECT $PARTITION.pfMyFunctionName(value)` to determine which partition a value would fall in.
3. [USING $PARTITION TO FIND THE LAST TIME AN EVENT OCCURED](https://simonlearningsqlserver.wordpress.com/2017/02/14/using-partition-to-find-the-last-time-an-event-occured/) - go sequentially through each partition seeing if the searchable object fits into the partition.
4. [MICROSOFT WHITEPAPER: Partitioned Table and Index Strategies Using SQL Server 2008](http://download.microsoft.com/download/D/B/D/DBDE7972-1EB9-470A-BA18-58849DB3EB3B/PartTableAndIndexStrat.docx)
   > See Page 51: Moving Older Partitions to Slower Disks
5. [Oops… I forgot to leave an empty SQL table partition, how can I split it with minimal IO impact?](https://blogs.msdn.microsoft.com/sql_pfe_blog/2013/08/13/oops-i-forgot-to-leave-an-empty-sql-table-partition-how-can-i-split-it-with-minimal-io-impact/)
   > the solution is to switch the data from [the last partition] into an empty table to make the last partition empty. You can then split the partition to add new boundary and then switch the data back into Partition 4.
   
   > ```
   > SELECT Operation, AllocUnitName, COUNT(*) as NumLogRecords
   > FROM fn_dblog(NULL, NULL)
   > WHERE AllocUnitName = 'dbo.TableName.IndexName'
   > GROUP BY Operation, AllocUnitName
   > ORDER BY COUNT(*) DESC
   > ```

## Partitions and Statistics

1. [UPDATEs to Statistics: From SQL Server 7.0 to SQL Server 2017](https://sqlperformance.com/2017/10/sql-statistics/updates-to-statistics)
> **SQL Server 2014** 
> * Incremental statistics are introduced for partitions, and can be viewed through the new DMF sys.dm_db_incremental_stats_properties. Incremental statistics provide a way to update statistics for a partition without updating them for the entire table. However, the additional statistics information from the incremental statistics is not used by the Query Optimizer, but it is folded into the main histogram for the table.

## Partition Management Utility
1. https://lucazav.github.io/SqlServerPartitionManagementUtility/

# Deleting Data in Batches
1. http://michaeljswart.com/2014/09/take-care-when-scripting-batches/

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

# Samples
[SQL Server 2005 Samples and Sample Databases](https://www.microsoft.com/en-us/download/details.aspx?id=10679)
[SqlServerSamples](https://archive.codeplex.com/?p=sqlserversamples)

# Trivia
[Authoritative source that <> and != are identical in performance in SQL Server](https://dba.stackexchange.com/questions/155650/authoritative-source-that-and-are-identical-in-performance-in-sql-server/155670#155670)
> * I use WinDbg; other debuggers are available. Public symbols are available via the usual Microsoft symbol server. For more information, see Looking deeper into SQL Server using Minidumps by the SQL Server Customer Advisory Team and SQL Server Debugging with WinDbg – an Introduction by Klaus Aschenbrenner. 
> 
> ** Using EAX on 32-bit Intel derivatives for return values from a function is common. Certainly the Win32 ABI does it that way, and I'm pretty sure it inherits that practice from back in the old MS-DOS days, where AX was used for the same purpose - Michael Kjörling

# WINDOW Function ROWS and RANGE
https://www.brentozar.com/archive/2017/09/indexing-windowing-functions-vs/
> Using Indexing for Windowing Functions: WHERE vs. OVER by Erik Darling, the following indexes helped us to reduce query time to about 200 ms:
> 
>    CREATE NONCLUSTERED INDEX entries_index 
>    ON dbo.entries (client_id, creation_date ASC) 
>    INCLUDE (status, uuid)
> 
>    CREATE NONCLUSTERED INDEX inverted_entries_index 
>    ON dbo.entries (status) 
>    INCLUDE (client_id, creation_date, uuid)

https://sonra.io/2017/08/22/window-function-rows-and-range-on-redshift-and-bigquery/
1. Frame defined by ROWS
2. Frame defined by RANGE

|      | RANGE clause | numeric values | date values |
| ---- | ------------ | -------------- | ----------- |
|Redshift|✘|✘|✘|
|PostgreSQL|✓|✘|✘|
|BigQuery|✓|✓|✘|
|Oracle|✓|✓|✓|

# PostgreSQL
https://www.citusdata.com/blog/2016/10/12/count-performance/

# RedShift
http://www.47lining.com/index.php/2016/05/31/improving-redshift-query-performance-through-effective-use-of-zone-maps/
> *The 3 Major Reasons for Slow Redshift Queries*
> There are three primary reasons for poorly performing queries in Amazon Redshift:
> 1. Ineffective zone maps
> 2. Excessive network traffic
> 3. Too many query steps
