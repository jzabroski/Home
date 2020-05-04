Sometimes, you have to port logic from Linq2Sql to EF, there are differences in how each handles DateTime math:

1. https://weblogs.asp.net/zeeshanhirani/comparing-dates-in-linq-to-sql

# Example 1
## Test
```c#
[TestMethod]
public void TestEventTiming()
{
  var date = Convert.ToDateTime("2008-08-11 10:00 AM");
  var db = CCReadDisplayDataContext();
  db.Log = new DebuggerWroter();
  var events = db.EventTimings.Where(ev => ev.EventDate == date);
  Debug.WriteLine(events.Count());
}
```

## Outputs
```sql
SELECT COUNT(*) AS [value]
FROM [dbo].[EventTimings] AS [t0]
WHERE [t0].[EventDate] = @p0
@p0: DateTime [8/11/2008 10:00:00 AM]
```

# Example 2:
```c#
[TestMethod]
public void TestEventTiming()
{
  var date = Convert.ToDateTime("2008-08-11 10:00 AM");
  var db = CCReadDisplayDataContext();
  db.Log = new DebuggerWriter();
  var events = db.EventTimings.Where(ev => ev.EventDate.Date == date.Date);
  Debug.WriteLine(events.Count());
}
```

```sql
SELECT COUNT(*) AS [value]
FROM [dbo].[EventTimings] as [t0]
WHERE CONVERT(DATE, [t0].[EventDate]) = @p0
-- @p0: DateTime [8/11/2008 12:00:00 AM]
```

