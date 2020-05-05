See: https://www.mssqltips.com/sqlservertip/4674/managing-temporal-table-history-in-sql-server-2016/

> ### Solution
> The MSDN article, [Manage Retention of Historical Data in System-Versioned Temporal Tables](https://msdn.microsoft.com/en-us/library/mt637341.aspx), provides a few options:
> 
> * Stretch Database
> * Table Partitioning (sliding window)
> * Custom cleanup script
> 
> The way these solutions are explained, though, lead you to make a blanket choice about retaining historical data only based on a specific point in time (say, archive everything from before January 1, 2017) or fixed windows (once a month, switch out the oldest month).
> This may be perfectly adequate for your requirements, and that's okay.
