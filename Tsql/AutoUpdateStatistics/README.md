# Overview
Rolling back all database connections in SQL Server is tricky when `AUTO_UPDATE_STATISTICS_ASYNC` ON is configured.

# Step 1: Turn it off
```tsql
ALTER DATABASE [{databaseName}] SET AUTO_UPDATE_STATISTICS_ASYNC OFF;
```

# Step 2: Kill the stats job
```tsql
/*
From: https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-exec-background-job-queue-transact-sql?view=sql-server-2017#remarks
Quote: This view returns information only for asynchronous update statistics jobs. For more information about asynchronous update statistics.
*/

SET XACT_ABORT ON;
SET NOCOUNT ON;

DECLARE @DatabaseName SYSNAME; -- Database on which the job is to execute.
DECLARE @job_id INT; -- 	Job identifier.

DECLARE StatsJobsCursor CURSOR FAST_FORWARD LOCAL
FOR
SELECT DB_NAME(database_id) AS DatabaseName, job_id
FROM sys.dm_exec_background_job_queue
WHERE DB_NAME(database_id) = DB_NAME();

OPEN StatsJobsCursor
FETCH NEXT FROM StatsJobsCursor INTO @DatabaseName, @job_id
WHILE @@FETCH_STATUS = 0
BEGIN

	DECLARE @SqlCmd VARCHAR(MAX) = 'KILL STATS JOB ' + CAST(@job_id AS VARCHAR);

	BEGIN TRY
		RAISERROR(@SqlCmd, 16, 1) WITH NOWAIT;
		EXEC sys.sp_executesql @stmt = @SqlCmd;
	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(MAX) =
			'Error: ERROR_MESSAGE[' + ERROR_MESSAGE()
			+ '] ERROR_NUMBER[' + CAST(ERROR_NUMBER() AS NVARCHAR)
			+ '] ERROR_SEVERITY[' + CAST(ERROR_SEVERITY() AS NVARCHAR)
			+ '] ERROR_STATE[' + CAST(ERROR_STATE() AS VARCHAR) + ']'
		RAISERROR(@SqlCmd, 16, 1) WITH NOWAIT;
	END CATCH

	FETCH NEXT FROM StatsJobsCursor INTO @DatabaseName, @job_id
END

/* Clean up our work */
CLOSE StatsJobsCursor;
DEALLOCATE StatsJobsCursor;
```
