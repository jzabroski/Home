1. [How to change foreign keys naming convention](https://github.com/fluentmigrator/fluentmigrator/issues/814)


# Scripts

## Convert `float`, `real` data types to specific `decimal(p,n)`
```sql
DECLARE @TableSchema VARCHAR(MAX) = 'dbo', @TableName VARCHAR(MAX) = 'Foo';
DECLARE @DecimalPrecision INT = 28;
DECLARE @DecimalScale INT = 10;

SELECT
	'Alter.Column("' + isc.COLUMN_NAME
	+ '").OnTable("' + isc.TABLE_NAME
	+ '").InSchema("' + isc.TABLE_SCHEMA
	+ '").' +
	CASE
		WHEN isc.DATA_TYPE = 'varchar' THEN 'AsAnsiString(' + CAST(isc.CHARACTER_MAXIMUM_LENGTH AS VARCHAR) + ')'
		WHEN isc.DATA_TYPE = 'nvarchar' THEN 'AsString(' + CAST(isc.CHARACTER_MAXIMUM_LENGTH AS VARCHAR) + ')'
		WHEN isc.DATA_TYPE = 'bigint' THEN 'AsInt64()'
		WHEN isc.DATA_TYPE = 'int' THEN 'AsInt32()'
		WHEN isc.DATA_TYPE = 'float' THEN 'AsDecimal(' + CAST(@DecimalPrecision AS VARCHAR) + ', ' + CAST(@DecimalScale AS VARCHAR) + ')'
		ELSE ''
	END + '.NotNullable()' +
	CASE WHEN isc.COLUMN_DEFAULT IS NULL THEN ';'
		ELSE '.WithDefaultValue(' + isc.COLUMN_DEFAULT +');'
	END
FROM INFORMATION_SCHEMA.COLUMNS isc
WHERE
  isc.TABLE_SCHEMA = @TableSchema
  AND isc.TABLE_NAME = @TableName
  AND isc.DATA_TYPE IN ('float', 'real')
```
