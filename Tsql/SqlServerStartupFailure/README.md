https://blogs.msdn.microsoft.com/sqlserverfaq/2011/05/11/inf-hey-my-sql-server-service-is-not-starting-what-do-i-do/

> | Sr.no | Parameter | Description |
> | ----- | --------- | ----------- |
> | 1.    | -c        | Start as a console application, not as a service. |
> | 2.    | -m        | Tries to start the SQL service in single user mode, i.e. only a single user can connect. This single user connection can be either  a sysadmin or a regular user connection |
> | 3.    | -f        | Tries to start the SQL service in Minimal configuration mode. This implicitly puts SQL Server in single-user mode and this also means only the system databases master, model, tempdb & mssqlsystemresource are recovered and started. |
> | 4.    | -T XXXX   | Tries to start the SQL Server should be started with the specified trace flag which follows after -T. Again this is case sensitive. |
> | 5.    | -g        | Specifies the number of megabytes (MB) of memory that SQL Server leaves available for memory allocations within the SQL Server process, but outside the SQL Server buffer pool. The default value for this is 256MB. |
> | 6.    | -m"ClientApp Name" | You can limit the connections to the specified client application. For example, -m"SQLCMD" limits connections to a single connection and that connection must identify itself as the SQLCMD client program. You can use this option when you are starting SQL Server in single-user mode and an unknown client application is taking the only available connection. Cool option J |
> | 7.    | -k  123 | Limits the number of checkpoint I/O requests per second to the value specified e.g. 123 MB/sec. Refer http://support.microsoft.com/kb/929240 for more info. |

