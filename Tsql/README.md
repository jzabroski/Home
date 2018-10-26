# Common Date Routines

```sql
declare @ThisDate datetime;
set @ThisDate = getdate();

select dateadd(DAY, datediff(DAY, 0, @ThisDate), 0)     -- Beginning of this day
select dateadd(DAY, datediff(DAY, 0, @ThisDate) + 1, 0) -- Beginning of next day
select dateadd(DAY, datediff(DAY, 0, @ThisDate) - 1, 0) -- Beginning of previous day
select dateadd(WEEK, datediff(WEEK, 0, @ThisDate), 0)     -- Beginning of this week (Monday)
select dateadd(WEEK, datediff(WEEK, 0, @ThisDate) + 1, 0) -- Beginning of next week (Monday)
select dateadd(WEEK, datediff(WEEK, 0, @ThisDate) - 1, 0) -- Beginning of previous week (Monday)
select dateadd(MONTH, datediff(MONTH, 0, @ThisDate), 0)     -- Beginning of this month
select dateadd(MONTH, datediff(MONTH, 0, @ThisDate) + 1, 0) -- Beginning of next month
select dateadd(MONTH, datediff(MONTH, 0, @ThisDate) - 1, 0) -- Beginning of previous month
select dateadd(QUARTER, datediff(QUARTER, 0, @ThisDate), 0)     -- Beginning of this quarter (Calendar)
select dateadd(QUARTER, datediff(QUARTER, 0, @ThisDate) + 1, 0) -- Beginning of next quarter (Calendar)
select dateadd(QUARTER, datediff(QUARTER, 0, @ThisDate) - 1, 0) -- Beginning of previous quarter (Calendar)
select dateadd(YEAR, datediff(YEAR, 0, @ThisDate), 0)     -- Beginning of this year
select dateadd(YEAR, datediff(YEAR, 0, @ThisDate) + 1, 0) -- Beginning of next year
select dateadd(YEAR, datediff(YEAR, 0, @ThisDate) - 1, 0) -- Beginning of previous year
```
