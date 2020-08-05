# Database Scaffolding Scripts

## Entity generator
```sql
DECLARE @TableSchema VARCHAR(MAX) = 'dbo', @TableName VARCHAR(MAX) = 'Foo';

SELECT 'public '
	+ CASE isc.DATA_TYPE
		WHEN 'int' THEN 'int'
		WHEN 'bigint' THEN 'long'
		WHEN 'datetime' THEN 'DateTime'
		WHEN 'datetime2' THEN 'DateTime'
		WHEN 'char' THEN 'string'
		WHEN 'nchar' THEN 'string'
		WHEN 'varchar' THEN 'string'
		WHEN 'nvarchar' THEN 'string'
		WHEN 'decimal' THEN 'decimal'
		ELSE '------------------'
	END + ' '
	+ CAST(isc.COLUMN_NAME AS VARCHAR(MAX))
	+ ' {get; set;}'
FROM INFORMATION_SCHEMA.COLUMNS isc
WHERE isc.TABLE_SCHEMA = @TableSchema isc.TABLE_NAME = @TableName;
GO
```

## IValildator<T> constructor script
```sql
DECLARE @TableSchema VARCHAR(MAX) = 'dbo', @TableName VARCHAR(MAX) = 'Foo';

SELECT isc.TABLE_NAME,
	'RuleFor(x => x.' + isc.COLUMN_NAME + ')'
	+ CHAR(13) + CHAR(10)
	+ '.MaximumLength(' + CAST(isc.CHARACTER_MAXIMUM_LENGTH AS VARCHAR) + ')'
	+ CASE WHEN isc.IS_NULLABLE = 'No' THEN '.NotEmpty()' ELSE '' END
	+ ';'
FROM INFORMATION_SCHEMA.COLUMNS isc
WHERE isc.DATA_TYPE IN ('varchar', 'nvarchar', 'char', 'nchar') AND isc.TABLE_SCHEMA = @TableSchema AND isc.TABLE_NAME = @TableName
UNION ALL
SELECT isc.TABLE_NAME, 'RuleFor(x => x.' + isc.COLUMN_NAME + ')' + CHAR(13) + CHAR(10) + '.ScalePrecision(' + CAST(isc.NUMERIC_SCALE AS VARCHAR) + ', ' + CAST(isc.NUMERIC_PRECISION AS VARCHAR) + ');'
FROM INFORMATION_SCHEMA.COLUMNS isc
WHERE isc.DATA_TYPE = 'decimal' AND isc.TABLE_SCHEMA = @TableSchema AND isc.TABLE_NAME = @TableName;
```

## FluentValidation.TestHelper script generator

```sql
DECLARE @TableSchema VARCHAR(MAX) = 'dbo', @TableName VARCHAR(MAX) = 'Foo';

SELECT
	isc.TABLE_NAME,
	'Validator.ShouldHaveMinAndMaxLength(x => x.'
	+ isc.COLUMN_NAME
	+ ', 0, '
	+ CAST(isc.CHARACTER_MAXIMUM_LENGTH AS VARCHAR)
	+ CASE WHEN isc.IS_NULLABLE = 'Yes' THEN ', true' ELSE '' END + ');'
FROM INFORMATION_SCHEMA.COLUMNS isc
WHERE isc.DATA_TYPE IN ('varchar', 'nvarchar', 'char', 'nchar') AND isc.TABLE_SCHEMA = @TableSchema AND isc.TABLE_NAME = @TableName
UNION
SELECT isc.TABLE_NAME, 'Validator.ShouldHavePrecisionAndScale(x => x.' + isc.COLUMN_NAME + ', ' + CAST(isc.NUMERIC_PRECISION AS VARCHAR) + ', ' + CAST(isc.NUMERIC_SCALE AS VARCHAR) + ');'
FROM INFORMATION_SCHEMA.COLUMNS isc
WHERE isc.DATA_TYPE = 'decimal' AND isc.TABLE_SCHEMA = @TableSchema AND isc.TABLE_NAME = @TableName
```
