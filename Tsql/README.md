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

# SQL Permissions with AD Groups

Be careful using AD Groups to define roles. See: https://docs.microsoft.com/en-us/sql/t-sql/statements/create-user-transact-sql?view=sql-server-2017

> Beginning with SQL Server 2012, the default schema can also be set for user based on a group login. See http://msdn.microsoft.com/en-in/library/ms173463.aspx:
If the user has a default schema, that default schema will used. If the user does not have a default schema, but the user is a member of a group that has a default schema, the default schema of the group will be used. If the user does not have a default schema, and is a member of more than one group that has a default schema, the schema of the Windows group with the lowest principle_id will be used. (It is not possible to explicitly select one of the available default schemas as the preferred schema.) If no default schema can be determined for a user, the dbo schema will be used.

You can test effective permissions this way:
```sql
-- '<domain>\<username>'
EXECUTE AS LOGIN = '<domain>\<username>';
SELECT * FROM fn_my_permissions('Edgar.Report13F.ConvertsQuarterOverQuarter', 'OBJECT');
REVERT;
```
