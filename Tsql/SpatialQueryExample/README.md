```sql
;WITH Periods AS (
	SELECT
		CAST('2018-12-31 06:00:00.0000000 +00:00' AS DATETIMEOFFSET) AS StartDate,
		CAST('2018-12-31 07:00:00.0000000 +00:00' AS DATETIMEOFFSET) AS EndDate
),
TestIntervals AS (
	SELECT
		'Before Start' AS TestDescription,
		CAST('2018-12-31 05:00:00.0000000 +00:00' AS DATETIMEOFFSET) AS TestIntervalsStartDate,
		CAST('2018-12-31 05:59:00.0000000 +00:00' AS DATETIMEOFFSET) AS TestIntervalsEndDate,
		CAST(0 AS BIT) AS ExpectedResult
	UNION ALL
	SELECT
		'Stabs Start' AS TestDescription,
		CAST('2018-12-31 06:00:00.0000000 +00:00' AS DATETIMEOFFSET) AS TestIntervalsStartDate,
		CAST('2018-12-31 06:00:00.0000000 +00:00' AS DATETIMEOFFSET) AS TestIntervalsEndDate,
		CAST(0 AS BIT) AS ExpectedResult
	UNION ALL
	SELECT
		'Touches Start' AS TestDescription,
		CAST('2018-12-31 05:00:00.0000000 +00:00' AS DATETIMEOFFSET) AS TestIntervalsStartDate,
		CAST('2018-12-31 06:00:00.0000000 +00:00' AS DATETIMEOFFSET) AS TestIntervalsEndDate,
		CAST(1 AS BIT) AS ExpectedResult
	UNION ALL
	SELECT
		'Overlaps Start' AS TestDescription,
		CAST('2018-12-31 05:00:00.0000000 +00:00' AS DATETIMEOFFSET) AS TestIntervalsStartDate,
		CAST('2018-12-31 06:30:00.0000000 +00:00' AS DATETIMEOFFSET) AS TestIntervalsEndDate,
		CAST(1 AS BIT) AS ExpectedResult
	UNION ALL
	SELECT
		'Between Start&End' AS TestDescription,
		CAST('2018-12-31 06:30:00.0000000 +00:00' AS DATETIMEOFFSET) AS TestIntervalsStartDate,
		CAST('2018-12-31 07:30:00.0000000 +00:00' AS DATETIMEOFFSET) AS TestIntervalsEndDate,
		CAST(1 AS BIT) AS ExpectedResult
	UNION ALL
	SELECT
		'Touches End' AS TestDescription,
		CAST('2018-12-31 07:00:00.0000000 +00:00' AS DATETIMEOFFSET) AS TestIntervalsStartDate,
		CAST('2018-12-31 08:00:00.0000000 +00:00' AS DATETIMEOFFSET) AS TestIntervalsEndDate,
		CAST(1 AS BIT) AS ExpectedResult
	UNION ALL
	SELECT
		'Stabs End' AS TestDescription,
		CAST('2018-12-31 07:00:00.0000000 +00:00' AS DATETIMEOFFSET) AS TestIntervalsStartDate,
		CAST('2018-12-31 07:00:00.0000000 +00:00' AS DATETIMEOFFSET) AS TestIntervalsEndDate,
		CAST(1 AS BIT) AS ExpectedResult
	UNION ALL
	SELECT
		'After End' AS TestDescription,
		CAST('2018-12-31 07:01:00.0000000 +00:00' AS DATETIMEOFFSET) AS TestIntervalsStartDate,
		CAST('2018-12-31 08:00:00.0000000 +00:00' AS DATETIMEOFFSET) AS TestIntervalsEndDate,
		CAST(0 AS BIT) AS ExpectedResult
), PeriodsExpanded AS (
	SELECT
		p.StartDate,
		p.EndDate,
		CAST(CAST(DATEDIFF(SECOND, CONVERT(DATE, '1970-01-01', 120), CAST(p.StartDate AS DATETIME)) AS BIGINT) AS VARCHAR(30)) AS StartDateString,
		CAST(CAST(DATEDIFF(SECOND, CONVERT(DATE, '1970-01-01', 120), CAST(p.EndDate AS DATETIME)) AS BIGINT) AS VARCHAR(30)) AS EndDateString
	FROM Periods p
), PeriodsLineString AS (
	SELECT
		pe.StartDate,
		pe.EndDate,
		pe.StartDateString,
		pe.EndDateString,
		'LINESTRING (0 ' + CAST(pe.StartDateString AS VARCHAR(30)) + ', 0 ' + CAST(pe.EndDateString AS VARCHAR(30)) + ')' AS LineString
	FROM PeriodsExpanded pe
), PeriodsGeo AS (
	SELECT
		pls.StartDate,
		pls.EndDate,
		pls.StartDateString,
		pls.EndDateString,
		pls.LineString,
		geometry::STGeomFromText(pls.LineString, 0) AS PeriodGeoDataType
	FROM PeriodsLineString pls
), TestIntervalsExpanded AS (
	SELECT
		ti.TestDescription,
		ti.TestIntervalsStartDate,
		ti.TestIntervalsEndDate,
		ti.ExpectedResult,
		CAST(CAST(DATEDIFF(SECOND, CONVERT(DATE, '1970-01-01', 120), CAST(ti.TestIntervalsStartDate AS DATETIME)) AS BIGINT) AS VARCHAR(30)) AS TestIntervalsStartDateString,
		CAST(CAST(DATEDIFF(SECOND, CONVERT(DATE, '1970-01-01', 120), CAST(ti.TestIntervalsEndDate AS DATETIME)) AS BIGINT) AS VARCHAR(30)) AS TestIntervalsEndDateString
	FROM TestIntervals ti
), TestIntervalsLineString AS (
	SELECT
		tie.TestDescription,
		tie.TestIntervalsStartDate,
		tie.TestIntervalsEndDate,
		tie.ExpectedResult,
		tie.TestIntervalsStartDateString,
		tie.TestIntervalsEndDateString,
		CASE
			WHEN tie.TestIntervalsStartDate = tie.TestIntervalsEndDate THEN 'POINT (0 ' + tie.TestIntervalsStartDateString + ')'
			ELSE 'LINESTRING (0 ' + CAST(tie.TestIntervalsStartDateString AS VARCHAR(30)) + ', 0 ' + CAST(tie.TestIntervalsEndDateString AS VARCHAR(30)) + ')'
		END AS TestIntervalsGeoString
	FROM TestIntervalsExpanded tie
), TestIntervalsGeo AS (
	SELECT
		tils.TestIntervalsEndDateString,
		tils.TestIntervalsStartDateString,
		tils.ExpectedResult,
		tils.TestIntervalsEndDate,
		tils.TestIntervalsStartDate,
		tils.TestDescription,
		tils.TestIntervalsGeoString,
		geometry::STGeomFromText(tils.TestIntervalsGeoString, 0) AS TestIntervalGeoDataType
	FROM TestIntervalsLineString tils
), TestResultMap AS (
	SELECT
		pg.LineString,
		pg.StartDate,
		pg.EndDate,
		pg.StartDateString,
		pg.EndDateString,
		pg.PeriodGeoDataType,
		tig.TestIntervalsEndDateString,
		tig.TestIntervalsStartDateString,
		tig.ExpectedResult,
		tig.TestIntervalsEndDate,
		tig.TestIntervalsStartDate,
		tig.TestDescription,
		tig.TestIntervalsGeoString,
		tig.TestIntervalGeoDataType,
		pg.PeriodGeoDataType.STIntersects(tig.TestIntervalGeoDataType) AS TestOutcome
	FROM PeriodsGeo pg
		JOIN TestIntervalsGeo tig ON 1 = 1
)
SELECT
	trm.LineString,
	trm.StartDate,
	trm.EndDate,
	trm.StartDateString,
	trm.EndDateString,
	trm.PeriodGeoDataType,
	trm.TestIntervalsEndDateString,
	trm.TestIntervalsStartDateString,
	trm.ExpectedResult,
	trm.TestIntervalsEndDate,
	trm.TestIntervalsStartDate,
	trm.TestDescription,
	trm.TestIntervalsGeoString,
	trm.TestIntervalGeoDataType,
	trm.TestOutcome
FROM TestResultMap trm
```
