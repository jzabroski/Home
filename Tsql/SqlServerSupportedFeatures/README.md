# SQL Server OEM
1. [Features Supported by the Editions of SQL Server 2012](https://docs.microsoft.com/en-us/previous-versions/sql/sql-server-2012/cc645993(v=sql.110))
2. [Features Supported by the Editions of SQL Server 2014](https://docs.microsoft.com/en-us/sql/getting-started/features-supported-by-the-editions-of-sql-server-2014?view=sql-server-2014)
3. [SQL Server 2016 - Scale Limits](https://docs.microsoft.com/en-us/sql/sql-server/editions-and-components-of-sql-server-2016?view=sql-server-2017#Cross-BoxScaleLimits)
4. [SQL Server 2017 - Scale Limits](https://docs.microsoft.com/en-us/sql/sql-server/editions-and-components-of-sql-server-2017?view=sql-server-2017#Cross-BoxScaleLimits)
5. [MSSQL Tiger Team: SQL Server 2016 SP1: Know your limits](https://blogs.msdn.microsoft.com/sql_server_team/sql-server-2016-sp1-know-your-limits/)

# Amazon RDS

https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_SQLServer.html#SQLServer.Concepts.General.FeatureNonSupport

> The following Microsoft SQL Server features are not supported on Amazon RDS:
>
> Stretch database
> Backing up to Microsoft Azure Blob Storage
> Buffer pool extension
> BULK INSERT and OPENROWSET(BULK...) features
> Data Quality Services
> Database Log Shipping
> Database Mail
> Distributed Queries (i.e., Linked Servers)
> Distribution Transaction Coordinator (MSDTC)
> File tables
> FILESTREAM support
> Maintenance Plans
> Performance Data Collector
> Policy-Based Management
> PolyBase
> R
> Replication
> Resource Governor
> SQL Server Audit
> Server-level triggers
> Service Broker endpoints
> T-SQL endpoints (all operations using CREATE ENDPOINT are unavailable)
> WCF Data Services
