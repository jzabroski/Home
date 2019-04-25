https://www.itprotoday.com/performance-tip-find-your-most-expensive-queries
> With that said, there’s still a way to ‘frame’ these costs – to provide an idea of what costs roughly mean in the ‘real’ world.
> 
> * .003. Costs of .003 are about as optimized as you’re going to get when interacting with the storage engine (executing some functions or operations can/will come in at cheaper costs, but I’m talking here about full-blown data-retrieval operations).
> * .03. Obviously, costs of .03 are a full order of magnitude greater than something with a cost of .003 – but even these queries are typically going to be VERY efficient and quick – executing in less than a second in the vast majority of cases.
> * 1. Queries with a cost of 1 aren’t exactly ugly or painfull (necessarily) and will typically take a second or less to execute. They’re not burning up lots of resources, but they’re also typically not as optimized as they could be (or they are optimized – but they’re pulling back huge amounts of data or filtering against very large tables).
> * 5. Queries with a cost greater than 5, by default, will be executed with a parallel plan – meaning that SQL Server sees these queries as being large enough to throw multiple processors/cores/theads-of-execution at – in order to speed up execution. And, if you’ve got a web site that’s firing off a query with a cost of 5 or more per every page load, for example, you’ll probably notice that the page ‘feels’ a bit sluggish loading – maybe by a second or two – as compared to a page that would ‘spring up’ if it was running a query with a cost of, say, .2 or lower. So, in other words, queries up in this range start having a noticeable or appreciable ‘cost’.
> * 20. Queries in this range are TYPICALLY going to be something you can notice taking a second or so. (Though, on decent hardware, they can still end up being instantaneous as well – so even at this point, things still depend on a lot of factors).
> * 200. Queries with this kind of cost should really only be for larger reports and infrequently executed operations. Or, they might be serious candidates for the use of additional tuning and tweaking (in terms of code and/or indexes).
> * 1000. Queries up in this range are what DBAs start to lovingly call ‘queries from hell’ – though it’s possible to bump into queries with costs in the 10s of thousands or even more – depending upon the operations being executed and the amount of data being poured over.

https://www.red-gate.com/simple-talk/sql/t-sql-programming/how-to-get-sql-server-dates-and-times-horribly-wrong/

https://blogs.msdn.microsoft.com/robinlester/2016/08/10/improving-query-performance-with-option-recompile-constant-folding-and-avoiding-parameter-sniffing-issues/

https://www.itprotoday.com/sql-server/new-solution-packing-intervals-problem
> Packing intervals is a classic T-SQL problem that involves packing groups of intersecting intervals into their respective continuous intervals. I covered the problem and two solutions in the past in this article. The two older solutions are quite elegant and efficient but they do require you to create two supporting indexes and to perform two scans of the data. I set a challenge to myself to try and find an elegant solution that can achieve the task by using only one supporting index and a single scan of the data, and I found one. In this article I present the new solution and compare it to the two older ones.

# SQL Server Samples and Sample Databases by Release
[SQL Server 2005 Samples and Sample Databases](https://www.microsoft.com/en-us/download/details.aspx?id=10679) ([alternative link](http://www.microsoft.com/downloads/details.aspx?FamilyId=E719ECF7-9F46-4312-AF89-6AD8702E4E6E&displaylang=en))
  - This includes various samples including the Hierarchical Triangular Mesh solution by Jim Gray for implementing spatial queries using table-valued functions

# Bitmap Filters and Hash Joins
1. https://www.sqlshack.com/hash-join-execution-internals/
2. https://www.researchgate.net/publication/4330987_Optimizing_Star_Join_Queries_for_Data_Warehousing_in_Microsoft_SQL_Server
3. Bitmap Filter (Star Join Query Optimization)(https://dwbi1.wordpress.com/2010/03/15/bitmap-filter-star-join-query-optimisation/)
4. [How Much Can One Row Change A Plan, Part 4](https://www.brentozar.com/archive/2018/01/much-can-one-row-change-plan-part-4/)
5. [Columnstore Bitmap Filters](https://orderbyselectnull.com/2017/12/12/columnstore-bitmap-filters/)
6. [Bitmap Magic (or… how SQL Server uses bitmap filters)](http://sqlblog.com/blogs/paul_white/archive/2011/07/07/bitmap-magic.aspx)
    > Geoff Patterson wrote: Great article, thanks (several years late, I know)! My whole team has learned a lot about the importance of constructing queries to benefit from the in-row bitmap filter optimization (pushing down to the storage engine) especially.
    >
    > Here is a new Connect issue I filed that might also be of interest; it seems that using a partitioned view (or otherwise hitting two or more fact tables via UNION ALL) is a situation in which the query optimizer cannot apply the optimization.
    >
    > https://connect.microsoft.com/SQLServer/feedbackdetail/view/974909/push-bitmap-filters-into-storage-engine-through-a-concatentation-operator
    >
    > It's hard to be "frustrated" when a new release of SQL Server (new since our data model was constructed, at least) provides such a powerful new benefit, but it certainly would be useful to allow the optimization to be pushed through a concatenation as well!
7. [StarJoinInfo in Execution Plans](https://sqlperformance.com/2014/01/sql-plan/starjoininfo-in-execution-plans)
8. [Optimizing Data Warehouse Query Performance Through Bitmap Filtering](https://docs.microsoft.com/en-us/previous-versions/sql/sql-server-2008-r2/bb522541(v=sql.105))
    > Bitmap filtering and optimized bitmap filtering are implemented in the query plan by using the bitmap showplan operator. Bitmap filtering is applied only in parallel query plans in which hash or merge joins are used. **Optimized bitmap filtering is applicable only to parallel query plans in which hash joins are used.**
9. [Improves the query performance when an optimized bitmap filter is applied to a query plan in SQL Server 2016 and 2017](https://support.microsoft.com/en-us/help/4089276/improve-query-performance-when-optimized-bitmap-filter-used-in-query)
    > When a query plan uses a batch-mode hash join where one of the inputs is an optimized bitmap filter with an underlying bookmark lookup or key lookup in Microsoft SQL Server 2016 and SQL Server 2017, inaccurate estimations are produced. This update improves the query performance for the scenario.
    > 
    > Applies to:
    > 
    > * Cumulative Update 6 for SQL Server 2017
    > * Cumulative update 8 for SQL Server 2016 SP1  
10. https://sqlkiwi.blogspot.com/2011/07/bitmap-magic.html?m=1
    > In many cases, the bitmap filter can be pushed all the way down to a scan or seek. 
When this happens, the bitmap filter check appears as a residual predicate  [...] 
    > 
    > As a residual, it is applied to all rows that pass any seek predicates (for an index seek), or to all rows in the case of an index or table scan. 
    > 
    > If the bitmap filter is built on a single column or expression of the integer or bigint types, and if the bitmap is to be applied to a single column of integer or bigint type, it might be pushed down the plan even further than the seek or scan operator.
    > 
    > The predicate is still shown in the seek or scan as above, but it is annotated with the INROWattribute — meaning the filter is pushed into the Storage Engine, and applied to rows as they are being read.
    > 
    > When this optimization occurs, rows are eliminated before the Query Processor sees the row at all. Only rows that might match the hash match join are passed up from the Storage Engine.
11. https://sqlperformance.com/2015/11/sql-plan/hash-joins-on-nullable-columns
    > This exchange, like the one on the probe side of the hash join, needs to ensure that rows with the same join key values end up at the same instance of the hash join. At DOP 4, there are four hash joins, each with its own hash table. For correct results, build-side rows and probe-side rows with the same join keys must arrive at the same hash join; otherwise we might check a probe-side row against the wrong hash table.
    > In a row-mode parallel plan, SQL Server achieves this by repartitioning both inputs using the same hash function on the join columns. In the present case, the join is on column c1, so the inputs are distributed across threads by applying a hash function (partitioning type: hash) to the join key column (c1). The issue here is that column c1 contains only a single value – null – in table T2, so all 32,000 rows are given the same hash value, as so all end up on the same thread.
    > The good news is that none of this really matters for this query. The post-optimization rewrite Filter eliminates all rows before very much work is done. On my laptop, the query above executes (producing no results, as expected) in around 70ms.

# Rowgroup Elimination
https://blogs.msdn.microsoft.com/sql_server_team/columnstore-index-performance-rowgroup-elimination/
> You may wonder why it says ‘segment’ skipped and not ‘rowgroups’ skipped? Unfortunately, this is a carryover from SQL Server 2012 with some mix-up of terms. When running analytics queries on large tables, if you find no or only a small percentage of rowgroups were skipped, you should look into why and explore opportunities to address if possible.
https://orderbyselectnull.com/2017/08/07/rowgroup-elimination/
https://www.brentozar.com/archive/2017/08/columnstore-indexes-rowgroup-elimination-parameter-sniffing-stored-procedures/
https://orderbyselectnull.com/2017/12/12/columnstore-bitmap-filters/
> A few interesting things happen. The first is that we get rowgroup elimination even though the dates in the dimension table are spread very far apart:
> 
> > Table ‘FactCCINoPart’. Segment reads 2, segment skipped 10.
>
> The following simple query doesn’t get rowgroup elimination:
> 
> ```
> SELECT *
> FROM dbo.FactCCINoPart f
> WHERE f.factDate IN ('20170101', '20171231')
> ```
> You can read more about that limitation [here](https://orderbyselectnull.com/2017/08/07/rowgroup-elimination/). It’s fair to say that the bitmap filter does a better job than expected with rowgroup elimination. According to extended events this is known as an expression filter bitmap. The extended event has a few undocumented properties about the bitmap:

# Dynamic Range Queries
C# approach: https://www.codeproject.com/Articles/168662/Time-Period-Library-for-NET

1. https://gertjans.home.xs4all.nl/sql/date-range-scans.html
2. Itzik Ben-Gan:
    1. https://www.itprotoday.com/sql-server/interval-queries-sql-server
3. Series by Laurent Martin (2013):
    1. https://blogs.solidq.com/en/sqlserver/static-relational-interval-tree/
    2. https://blogs.solidq.com/en/businessanalytics/advanced-interval-queries-static-relational-interval-tree/
    3. http://blogs.solidq.com/en/businessanalytics/using-static-relational-interval-tree-time-intervals/
4. Series by Dejan Sarka (2013):
    1. https://blogs.solidq.com/en/businessanalytics/interval-queries-in-sql-server-part-1/ - suggests using geometry data type - this approach DOES NOT WORK!
    2. https://blogs.solidq.com/en/businessanalytics/interval-queries-in-sql-server-part-2/
    3. https://blogs.solidq.com/en/businessanalytics/interval-queries-in-sql-server-part-3/
    4. https://blogs.solidq.com/en/businessanalytics/interval-queries-in-sql-server-part-4/
    5. https://blogs.solidq.com/en/businessanalytics/interval-queries-in-sql-server-wrap-up/
    6. https://blogs.solidq.com/en/businessanalytics/interval-queries-in-sql-server-part-5/ - suggests NOT using XML data type - this approach DOES NOT WORK! (Why would the author think it would ever work?)
5. Series by Dejan Sarka (2017):
    1. https://codingsight.com/optimizing-overlapping-queries-part-1-introduction-enhanced-t-sql-solution/
    2. ? there does not seem to be a follow-up article
6. Video lecture by Dejan Sarka:
    1. https://www.pluralsight.com/courses/working-with-temporal-data-sql-server
    > So to remind you, we have work done by Hans-Peter Kriegel, Marco Pötke, and Thomas Seidl from the Munich University, and these guys defined the Relational Interval Tree model for optimizing temporal queries. However, building this tree was too expensive based on their algorithm. So Laurent Martin found a nice mathematics for fast computation of Relational Interval Tree nodes. And, finally, Itzik Ben-Gan created the Transact-SQL solution for the Relational Interval Tree. So in this module, I'm going to introduce this Transact-SQL solution, and while introducing it, I will also explain the Relational Interval Tree. All of these performance solutions focus on the Overlaps operator. This is probably the most complex Allen's operator. And if you solve problems with this operator, you can solve problems and performance issues with other operators as well.
    John's note: Overlaps is the second most complex operator.  Intersects operator includes points that touch the start and end, therefore it is slightly more complex.
7. https://www.itprotoday.com/software-development/interval-queries-sql-server
8. https://github.com/icomefromthenet/mysqlfastintervallookup
9. https://pdfs.semanticscholar.org/b473/3096c909ec0f8059bb8ee0e8d4324f635615.pdf
10. Unrelated but useful trick: https://dwbi1.wordpress.com/2010/03/15/bitmap-filter-star-join-query-optimisation/

See also:
1. https://github.com/Breinify/brein-time-utilities

# Spatial Indexes
1. [How to ensure your spatial index is being used - Bob Beauchemin](http://sqlskills.com/BLOGS/BOBB/post/How-to-ensure-your-spatial-index-is-being-used.aspx)
2. [Is my spatial index being used? - Isaac Kunen](https://blogs.msdn.microsoft.com/isaac/2008/08/29/is-my-spatial-index-being-used/)
3. [Spatial Index Diagnostic Procs – Intro - Bob Beauchemin](https://www.sqlskills.com/blogs/bobb/spatial-index-diagnostic-procs-intro/)
4. [MSR-TR-2005-122 - Using Table Valued Functions in SQL Server 2005 To Implement a Spatial Data Library](https://www.microsoft.com/en-us/research/wp-content/uploads/2005/09/tr-2005-122.doc) See also the [pdf](https://www.microsoft.com/en-us/research/publication/using-table-valued-functions-in-sql-server-2005-to-implement-a-spatial-data-library/) format
    > This article explains how to add spatial search functions (point-near-point and point in polygon) to Microsoft SQL Server™ 2005 using C# and table-valued functions. It is possible to use this library to add spatial search to your application without writing any special code. The library implements the public-domain C# Hierarchical Triangular Mesh (HTM) algorithms from Johns Hopkins University.  That C# library is connected to SQL Server 2005 via a set of scalar-valued and table-valued functions. These functions act as a spatial index.
See also:
1. https://www.red-gate.com/simple-talk/sql/t-sql-programming/sql-server-spatial-indexes/
> SQL Server 2012 has added support for the auto grid spatial index, available for both the geography and geometry data types. An auto grid uses eight levels instead of the usual four levels. The advantage of using an auto grid is that when creating an index we can get good index support without studying the queries that will run against the table. In addition, you do not need to add a GRIDS clause to your CREATE SPATIAL INDEX statement because the database engine determines the best strategy to use to maximize performance.

# Working With Partitions
## Partition Build Progress
```sql
SELECT
p.partition_id,
a.used_pages AS IndexSizeInPages
FROM sys.indexes i (NOLOCK)
INNER JOIN sys.partitions p (NOLOCK)
ON p.object_id = i.object_id AND p.index_id = i.index_id
INNER JOIN sys.allocation_units a (NOLOCK)
ON a.container_id = p.partition_id
WHERE i.name = '<INDEX_NAME>'
```
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

See also my StackOverflow answer to: [Receiving “The SELECT permission was denied on the object” even though it's been granted](https://dba.stackexchange.com/a/234046/35450)

See also: https://sqlity.net/en/1783/changing-security-context-execute-revert/

# Parameter Sniffing
1. https://www.brentozar.com/archive/2018/09/sql-server-2019-faster-table-variables-and-new-parameter-sniffing-issues/
2. https://channel9.msdn.com/Events/SQLDay/SQLDay-2017/Identifying-and-Fixing-Parameter-Sniffing

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

https://dba.stackexchange.com/questions/39589/optimizing-queries-on-a-range-of-timestamps-two-columns

# RedShift
http://www.47lining.com/index.php/2016/05/31/improving-redshift-query-performance-through-effective-use-of-zone-maps/
> *The 3 Major Reasons for Slow Redshift Queries*
> There are three primary reasons for poorly performing queries in Amazon Redshift:
> 1. Ineffective zone maps
> 2. Excessive network traffic
> 3. Too many query steps
