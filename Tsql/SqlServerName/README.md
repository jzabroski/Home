Based on: https://docs.microsoft.com/en-us/sql/database-engine/install-windows/rename-a-computer-that-hosts-a-stand-alone-instance-of-sql-server?view=sql-server-2017
```tsql
select @@SERVERNAME

SELECT SERVERPROPERTY('SERVERNAME')
GO
exec sp_dropserver @@SERVERNAME
Go
DECLARE @newname sysname = cAST(SERVERPROPERTY('SERVERNAME') as sysname);
exec sp_addserver @newname, local
GO
-- YOU MUST RESTART THE SQL SERVER PRIOR TO VERIFYING HTE CHANGES
select @@SERVERNAME

SELECT SERVERPROPERTY('SERVERNAME')
GO
```
