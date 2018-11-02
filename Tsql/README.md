# Dynamic Range Queries
https://gertjans.home.xs4all.nl/sql/date-range-scans.html

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
