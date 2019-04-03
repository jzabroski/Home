1. [Red Gate's SQL Server Backup and Restore Guide](https://assets.red-gate.com/community/books/sql-server-backup-and-restore.pdf)
2. [What happens to transaction log backups during full backups?](https://www.brentozar.com/archive/2015/12/what-happens-to-transaction-log-backups-during-full-backups/)

```sql
-- Find the duration for each backup in the backup media family
SELECT
	s.database_name,
	m.physical_device_name,
	CAST(CAST(s.backup_size / 1000000 AS BIGINT) AS VARCHAR(14))
		+ ' ' + 'MB' AS bkSize,
	CAST(DATEDIFF(second, s.backup_start_date, s.backup_finish_date) AS VARCHAR(30))
		+ ' ' + 'Seconds' TimeTaken,
	s.backup_start_date,
	s.backup_finish_date,
	CAST(s.first_lsn AS VARCHAR(50)) AS first_lsn,
	CAST(s.last_lsn AS VARCHAR(50)) AS last_lsn,
	CASE s.[type]
		WHEN 'D' THEN 'Full'
		WHEN 'I' THEN 'Differential'
		WHEN 'L' THEN 'Transaction Log'
	END AS BackupType,
	s.server_name,
	s.recovery_model
FROM msdb.dbo.backupset s
INNER JOIN msdb.dbo.backupmediafamily m ON s.media_set_id = m.media_set_id
WHERE s.database_name = DB_NAME()
ORDER BY
	backup_start_date DESC,
	backup_finish_date
```

```sql
--Find how big were the logs when backed up.

SELECT
  database_name,
  CONVERT(varchar, CAST ((backup_size/1024/1024) AS MONEY), 1) as 'BackUpSizeMB',
  user_name as 'BackUpBy',
  backup_start_date,
  backup_finish_date,
  recovery_model,
  CONVERT(varchar, CAST ((compressed_backup_size/1024/1024) AS MONEY), 1) as 'compressed_backup_sizeMB'
FROM msdb..backupset
WHERE backup_finish_date > DATEADD(MONTH, -12, CURRENT_TIMESTAMP) -- If want month(s)
--WHERE backup_finish_date > DATEADD(DAY, -1, CURRENT_TIMESTAMP)  -- or only day(s)
AND type = 'L' --Log
AND database_name = DB_NAME()
ORDER BY backup_start_date desc
--order by backup_size desc

```
