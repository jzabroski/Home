1. Custom reports https://thwack.solarwinds.com/t5/DPA-Documents/tkb-p/dpa-documents/label-name/sql%20server%20custom%20reports
2. How to get metrics over time [Solved: Re: How to query DPA to get same metrics as PerfStack through dpaim](https://thwack.solarwinds.com/t5/DPA-Discussions/How-to-query-DPA-database-to-get-same-metrics-as-Perfstack/m-p/226610#M1216)

```sql
SET @instanceName := 'PRD-SQL-03';
SET @metricName := 'Memory Utilization (%)';
SET @startDate = CAST(DATE_ADD(CAST(NOW() AS DATE), INTERVAL -DAY(NOW()) + 1 DAY) AS DATETIME);
SET @endDate = CAST(LAST_DAY(@startDate) AS DATETIME);
SET @dbid := (SELECT ID FROM dpa_remotedbarepo.cond WHERE name = @instanceName);

SET @sql := CONCAT(
    'SELECT MN.NAME AS "Metric Name", MD.D AS "Timestamp", MD.V_AVG AS "Metric Avg Value", MD.V_MAX AS "Metric Max Value"',
    'FROM dpa_remotedbarepo.CON_METRICS_DAY_', @dbid, ' AS MD',
    '    INNER JOIN dpa_remotedbarepo.CON_METRICS_', @dbid, ' AS M',
    '        ON MD.METRICS_ID = M.ID',
    '    INNER JOIN dpa_remotedbarepo.CON_METRICS_NAMES_', @dbid, ' AS MN',
    '        ON M.METRIC_NAME_ID = MN.ID ',
    'WHERE MN.NAME = ''', @metricName, ''' ',
    'AND MD.D >= ''', @startDate, ''' ',
    'AND MD.D < ''', @endDate, ''' '
    'ORDER BY MD.D'
);

SELECT @sql;
```
