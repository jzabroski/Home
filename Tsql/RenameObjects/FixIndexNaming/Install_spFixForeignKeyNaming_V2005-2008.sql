IF SCHEMA_ID('dbautils') IS NULL EXECUTE ('CREATE SCHEMA dbautils AUTHORIZATION dbo')
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

SET ARITHABORT ON
GO      


IF OBJECT_ID('dbautils.AliasRules') IS NULL
BEGIN
  CREATE TABLE dbautils.AliasRules
  (
    DatabaseName sysname NOT NULL CONSTRAINT DF_AliasRules_DatabaseName DEFAULT '',
    SchemaName sysname NOT NULL CONSTRAINT DF_AliasRules_SchemaName DEFAULT '',
    TableName sysname NOT NULL CONSTRAINT DF_AliasRules_TableName DEFAULT '',
    ColumnName sysname NOT NULL CONSTRAINT DF_AliasRules_ColumnName DEFAULT '',
    AliasName sysname NOT NULL,
    RuleType AS 
    (
      CASE 
        WHEN DatabaseName != '' AND SchemaName != '%' AND SchemaName != '' AND TableName = '' AND ColumnName = '' THEN 'S'
        WHEN DatabaseName != '' AND SchemaName != '' AND TableName != '%' AND TableName != '' AND ColumnName = '' THEN 'T'
        WHEN DatabaseName != '' AND SchemaName != '' AND TableName != '' AND ColumnName != '%' AND ColumnName != '' THEN 'C'
      ELSE
        '?'
      END
    ) PERSISTED,
    RuleDescription AS 
    (
      CASE 
        WHEN DatabaseName != '' AND SchemaName != '%' AND SchemaName != '' AND TableName = '' AND ColumnName = '' THEN 'Schema alias rule'
        WHEN DatabaseName != '' AND SchemaName != '' AND TableName != '%' AND TableName != '' AND ColumnName = '' THEN 'Table alias rule'
        WHEN DatabaseName != '' AND SchemaName != '' AND TableName != '' AND ColumnName != '%' AND ColumnName != '' THEN 'Column alias rule'
      ELSE
        'Invalid alias rule'
      END
    ) PERSISTED,
    CONSTRAINT CK_AliasRules_RuleType CHECK 
    (
      RuleType IN ('S', 'T', 'C')
    ),
    CONSTRAINT PK_AliasRules PRIMARY KEY CLUSTERED (RuleType, DatabaseName, SchemaName, TableName, ColumnName)
  )
END
GO

SET QUOTED_IDENTIFIER ON
GO

IF (OBJECT_ID('dbautils.AliasRulesSynonym', N'SN') IS NULL)
  CREATE SYNONYM dbautils.AliasRulesSynonym FOR dbautils.AliasRules 
GO
IF SCHEMA_ID('dbautils') IS NULL EXECUTE ('CREATE SCHEMA dbautils AUTHORIZATION dbo')

IF (OBJECT_ID('dbautils.fnStringList2Table', N'TF') IS NOT NULL)
  DROP FUNCTION dbautils.fnStringList2Table
GO

CREATE FUNCTION dbautils.fnStringList2Table
( 
  @List NVARCHAR(MAX), -- The string list, which should be splitted into table rows
  @ListSeparator NCHAR = ',' -- The separator char for splitting the string values
) 
RETURNS @ReturnTable TABLE 
(
  Item NVARCHAR(MAX)
)
WITH SCHEMABINDING
/*********************************************************************************

  File:         fnStringList2Table.sql
  Author:       Michael Søndergaard
  Date:         May 2009
  Build Date:   20 March 2011
  Homepage:     http://sql.soendergaard.info
  Version:      1.0.0
  Supported / 
  Tested on:    Microsoft SQL Server 2005 & 2008
  
  Description:  This table value function can be used for splitting a string list
                into rows. The string list is splitted into rows based the 
                specified list separator character.
                
                If elements contains the list separator character you can escape 
                the character in the element with a double separator characters.
                This way the function will search for the next single separator
                
                NB. This function does not remove any leading or trailing whitespace.
                If you need to remove surplus whitespace, the calling sql statement 
                should do it.
                
  Usage:        See test cases

  -----------------------------------------------------------------------------------

  THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF
  ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
  TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
  PARTICULAR PURPOSE. YOU MAY USE AND MODIFY THIS CODE FREELY FOR
  YOUR OWN PURPOSE, IF YOU REMEMBER TO CREDIT MY WORK. HOWEVER YOU 
  MAY NOT REPUBLISH IT, AND CLAIM IT AS YOUR OWN WORK 


  -----------------------------------------------------------------------------------

  Revision History:

    Version 1.0.0 - May 9, 2009 
    - This version support splitting a string list and returning a result table 
      containing item rows with string values. 
      
    - Support for escaping list separators, if elements contains list separators
      
   
 
**********************************************************************************/

AS 
BEGIN
  -- ###############################################################################
  -- ###### If the @ListSeparator is null or empty, when return an empty table, 
  -- ###### because nothing can be split
  -- ###############################################################################
  IF ISNULL(@ListSeparator + '#', '') = '#' RETURN


  -- ###############################################################################
  -- ###### If the @List is null or empty, when return an empty table. For this
  -- ###### check we need to handle trailing whitespace specially. Thats the reason
  -- ###### for appending a char in the comparison
  -- ###############################################################################
  IF ISNULL(@List + '#', '') = '#' RETURN

  DECLARE @StrValue NVARCHAR(MAX)
  DECLARE @NextSeparatorPos INT
  DECLARE @CurrentPos INT
  DECLARE @ValueStartPos INT
  DECLARE @SeparatorInLoop INT
  DECLARE @IsRemaining BIT
  
  SET @ValueStartPos = 0 
  SET @CurrentPos = 0
  SET @IsRemaining = 0
  
  -- ###############################################################################
  -- ###### Loop through the list in search of elements to separate
  -- ###############################################################################
  WHILE 1 = 1
  BEGIN
    SET @SeparatorInLoop = 0

    -- ###############################################################################
    -- ###### This loop are for handling escaped list separators. Because the list
    -- ###### can contain multiple occurances of escaped list separators. We need 
    -- ###### to iterate until, we find an unescaped list separator or the end of the
    -- ###### list
    -- ###############################################################################
    WHILE 1 = 1
    BEGIN
      SET @NextSeparatorPos = CHARINDEX(@ListSeparator, @List, @CurrentPos)


      -- ###############################################################################
      -- ###### We need to keep track of how many times a list separator was found,
      -- ###### while looping the inner loop
      -- ###############################################################################
      IF @NextSeparatorPos != 0 
        SET @SeparatorInLoop = @SeparatorInLoop + 1

      --RAISERROR ('@NextSeparatorPos = %-10d @CurrentPos = %-10d @SeparatorInLoop = %-10d @ValueStartPos = %-10d', 10, 1, @NextSeparatorPos, @CurrentPos, @SeparatorInLoop, @ValueStartPos) WITH NOWAIT
      
      -- ###############################################################################
      -- ###### In order for us to know, when we have an unescaped list separator after
      -- ###### some already escaped list separators, is to let it loop one time extra,
      -- ###### and check if the distance between the previous found separator and the 
      -- ###### current is greater that zero. This should only be checked, when the 
      -- ###### number of separators found in the inner loop is even
      -- ###############################################################################
      IF (@SeparatorInLoop > 1) AND (@SeparatorInLoop % 2 = 0) AND (@NextSeparatorPos - @CurrentPos > 0)
      BEGIN
        --PRINT 'NEW ELEMENT'
        BREAK
      END
      ELSE
      -- ###############################################################################
      -- ###### We found a list separator, check for another one
      -- ###############################################################################
      IF (@NextSeparatorPos > 0) 
      BEGIN
        SET @CurrentPos = @NextSeparatorPos + 1
        SET @NextSeparatorPos = 0
        -- PRINT 'NEXT TRY'
        CONTINUE
      END
      ELSE
      -- ###############################################################################
      -- ###### An unescaped list separator was found, and no separators exist afterwards
      -- ###############################################################################
      IF (@NextSeparatorPos = 0) AND (@SeparatorInLoop % 2 = 1)
      BEGIN
        --PRINT 'NEW ELEMENT - UNESCAPED SEPARATOR FOUND'
        BREAK
      END
      -- ###############################################################################
      -- ###### No more list separators is present, this means the remaining text is
      -- ###### the last element value
      -- ###############################################################################
      BEGIN
        SET @IsRemaining = 1
        --PRINT 'NEW ELEMENT - NO MORE SEPARATORS'
        BREAK
      END
    END
        
    IF (@IsRemaining = 1) 
    BEGIN
      -- ###############################################################################
      -- ###### Extract the element from the remaining text and replace all escaped 
      -- ###### list separators with a single list separator. Add the element to the 
      -- ###### return table. No more elements are present in the list, so break the 
      -- ###### loop, when finish
      -- ###############################################################################
      SET @StrValue = REPLACE(SUBSTRING(@List, @ValueStartPos, 2147483647), @ListSeparator + @ListSeparator, @ListSeparator)
      --RAISERROR ('Value is the remaining = #%s#', 10, 1, @StrValue) WITH NOWAIT
      
      -- ###############################################################################
      -- ###### Because of trailing whitespace handling in sql server, we need to handle
      -- ###### this situation specially
      -- ###############################################################################
      IF @StrValue + '#' != '#'
      BEGIN
        INSERT INTO @ReturnTable (Item) 
        VALUES(@StrValue)
      END

      BREAK
    END
    ELSE
    BEGIN
      -- ###############################################################################
      -- ###### Extract the element from the text and replace all escaped 
      -- ###### list separators with a single list separator. Add the element to the 
      -- ###### return table. More elements can be present in the list, so continue the 
      -- ###### loop for finding more elements
      -- ###############################################################################
      SET @StrValue = REPLACE(SUBSTRING(@List, @ValueStartPos, @CurrentPos - @ValueStartPos - 1), @ListSeparator + @ListSeparator, @ListSeparator)      
      -- RAISERROR ('Value element found = #%s#', 10, 1, @StrValue) WITH NOWAIT

      -- ###############################################################################
      -- ###### Because of trailing whitespace handling in sql server, we need to handle
      -- ###### this situation specially
      -- ###############################################################################
      IF @StrValue + '#' != '#'
      BEGIN
        INSERT INTO @ReturnTable (Item) 
        VALUES(@StrValue)
      END

      -- ###############################################################################
      -- ###### Initialize the variables to start from the end of the last found element
      -- ###############################################################################
      SET @ValueStartPos = @CurrentPos 
      SET @CurrentPos = @CurrentPos + 1
    END
  END
  
  RETURN 
END

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF SCHEMA_ID('dbautils') IS NULL EXECUTE ('CREATE SCHEMA dbautils AUTHORIZATION dbo')

IF (OBJECT_ID('dbautils.fnGetFilteredObjects', N'TF') IS NOT NULL)
  DROP FUNCTION dbautils.fnGetFilteredObjects
GO

CREATE FUNCTION dbautils.fnGetFilteredObjects 
(
  @FilterExpression NVARCHAR(MAX),
  @PartMode TINYINT,
  @ValuesList XML,
  @QuickLists XML
)
RETURNS @ReturnTable TABLE
(
    PrimaryId INT,
    SecondaryId INT,
    PRIMARY KEY CLUSTERED(PrimaryId, SecondaryId)
)
/*********************************************************************************

  File:         fnGetFilteredObjects.sql
  Author:       Michael Søndergaard
  Date:         June 2010
  Build Date:   20 March 2011
  Homepage:     http://sql.soendergaard.info
  Version:      1.0.0
  Supported / 
  Tested on:    Microsoft SQL Server 2005 & 2008
  
  Description:  This functions returns a table containing objects, which matches 
                the filter expression. 

                You can have multiple filter expression, both inclusions and
                exclusions at the same time, but it needs to be comma separated. 
                
                The filter expression is basically a like expression. So the same
                rules applies. If your filter expressions contains Like special 
                characters, when you must surround the characters with square 
                brackets.
                
                Null or empty filter expression means % basically all objects,
                which is included in the @ValueList parameter
                
                Do not surround the object names with quotes nor square brackets. 
                Quotes will be considered as part of the object name. Square 
                brackets will be considered part of the like expression
                            
                The following filter options are supported.
                
                - as prefix means the filter is an exclusion
                + as prefix means the filter is an inclusion. You may omit this character.

  Usage:        See test cases for functions, which uses this one. e.g
                  - dbautils.fnGetFilteredDatabases
                  - dbautils.fnGetFilteredTables
                  - dbautils.fnGetFilteredColumns
                  
  INPUTS:       

    @FilterExpression:
      The FilterExpression can be used for limitting the number for objects, which should be 
      returned. The default is empty, which means all objects in the @ValueList parameter.

    @PartMode:
      This parameter handles if the filter expression should be used as single or two
      part object filters. A one part filter could be databases or table columns, 
      a two part filter could be tables there the first part would be schema filter and 
      the second part table filter.                   

    @ValuesList:
      This Xml document should contains all values for the object type. From this 
      document the function would do it's inclusions and exclusions
      
    @QuickLists
      This Xml document should contain a list of common object groups. All values for 
      a particular group, should be present in the Xml document. A Quick List group
      could be Computed columns, Primary Key Columns, Online or Offline Databases,
      User or System databases. If you want your own Quick List, it is easy to 
      add it 
       
  -----------------------------------------------------------------------------------

  THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF
  ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
  TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
  PARTICULAR PURPOSE. YOU MAY USE AND MODIFY THIS CODE FREELY FOR
  YOUR OWN PURPOSE, IF YOU REMEMBER TO CREDIT MY WORK. HOWEVER YOU 
  MAY NOT REPUBLISH IT, AND CLAIM IT AS YOUR OWN WORK 


  -----------------------------------------------------------------------------------

  Revision History:

    Version 1.0.0 - Jun 02 2010 
      - Initial version with support for handling one or two part objects filters    
 
**********************************************************************************/

BEGIN
  -- #########################################################################################
  -- ###### This table contains all values, which matches all the include filter expressions
  -- #########################################################################################
  DECLARE @IncludeTable AS TABLE 
  (
    PrimaryId INT,
    PrimaryName sysname,
    SecondaryId INT,
    SecondaryName sysname,
    PRIMARY KEY CLUSTERED(PrimaryName, SecondaryName)
  )

  -- #########################################################################################
  -- ###### This table contains all values, which matches all the exclude filter expressions
  -- #########################################################################################
  DECLARE @ExcludeTable AS TABLE 
  (
    PrimaryId INT,
    PrimaryName sysname,
    SecondaryId INT,
    SecondaryName sysname,
    PRIMARY KEY CLUSTERED(PrimaryName, SecondaryName)
  )

  -- #########################################################################################
  -- ###### This table contains all values feed into the function
  -- #########################################################################################
  DECLARE @ValuesTable AS TABLE 
  (
    PrimaryId INT,
    PrimaryName sysname,
    SecondaryId INT,
    SecondaryName sysname,
    PRIMARY KEY CLUSTERED(PrimaryName, SecondaryName)
  )

  -- ###############################################################################
  -- ###### This table contains all filter expression from the filter string
  -- ###############################################################################
  DECLARE @FiltersTable AS TABLE 
  (
    Number INT,
    IncludeExclude CHAR(1),
    PrimaryName sysname,
    SecondaryName sysname
    PRIMARY KEY CLUSTERED(IncludeExclude, PrimaryName, SecondaryName)
  )

  -- ###############################################################################
  -- ###### This table contains all objects on the server, which makes up
  -- ###### a special group
  -- ###############################################################################
  DECLARE @QuickFilterTables AS TABLE 
  (
    QuickGroupName sysname,
    PrimaryId INT,
    PrimaryName sysname,
    SecondaryId INT,
    SecondaryName sysname,
    PRIMARY KEY CLUSTERED(QuickGroupName, PrimaryId, PrimaryName, SecondaryId, SecondaryName)
  )
  
  INSERT @ValuesTable
  SELECT  
    PrimaryId = x.row.value('@PrimaryId[1]', 'INT'),
    PrimaryName = x.row.value('@PrimaryName[1]', 'sysname'),
    SecondaryId = x.row.value('@SecondaryId[1]', 'INT'),
    SecondaryName = x.row.value('@SecondaryName[1]', 'sysname')
  FROM 
    @ValuesList.nodes('/row') AS x(row)

  INSERT @QuickFilterTables
  SELECT
    QuickGroupName = x.row.value('@QuickGroupName[1]', 'sysname'),  
    PrimaryId = x.row.value('@PrimaryId[1]', 'INT'),
    PrimaryName = x.row.value('@PrimaryName[1]', 'sysname'),
    SecondaryId = x.row.value('@SecondaryId[1]', 'INT'),
    SecondaryName = x.row.value('@SecondaryName[1]', 'sysname')
  FROM 
    @QuickLists.nodes('/row') AS x(row)


  -- ###############################################################################
  -- ###### Transform all string filter expressions into table filter rows
  -- ###############################################################################
  INSERT INTO @FiltersTable
  SELECT
    Number = ROW_NUMBER() OVER (ORDER BY IncludeExclude, SecondaryName, PrimaryName), -- Number is used for prioritization, so that the most generics ones have the lower numbers
    X.IncludeExclude,
    PrimaryName = X.PrimaryName,
    SecondaryName = X.SecondaryName
  FROM
    (
      -- #######################################################################################
      -- ###### Determinate if the expression is an inclusion or exclusion expression and
      -- ###### remove leading and trailing whitespace
      -- #######################################################################################
      SELECT
        IncludeExclude = CASE WHEN '-' IN (LEFT(PrimaryName, 1), LEFT(SecondaryName, 1)) THEN 'E' ELSE 'I' END, 
        PrimaryName = CASE WHEN LEFT(PrimaryName, 1) IN ('-', '+') THEN RIGHT(PrimaryName, LEN(PrimaryName) - 1) ELSE PrimaryName END,
        SecondaryName = CASE WHEN LEFT(SecondaryName, 1) IN ('-', '+') THEN RIGHT(SecondaryName, LEN(SecondaryName) - 1) ELSE SecondaryName END
       FROM
        (
          -- #######################################################################################
          -- ###### If the primary or secondary name is empty, when it is basically a wildcard. So 
          -- ###### add the wildcard operator 
          -- #######################################################################################
          SELECT
            PrimaryName = CASE WHEN PrimaryName = '' THEN '%' ELSE RTRIM(LTRIM(PrimaryName)) END,
            SecondaryName = CASE WHEN SecondaryName = '' THEN '%' ELSE RTRIM(LTRIM(SecondaryName)) END
          FROM
            (
              -- #######################################################################################
              -- ###### Extract the primary and secondary name from the filteret expression
              -- #######################################################################################
              SELECT
                PrimaryName =  CASE WHEN @PartMode = 2 THEN SUBSTRING(Item, 1, DotPos - 1) ELSE Item END,
                SecondaryName = CASE WHEN @PartMode = 2 THEN SUBSTRING(Item, DotPos + 1, 500) ELSE Item END
              FROM
                (  
                  -- #######################################################################################
                  -- ###### If a dot doesn't exists, add a primary wildcard to the filter expression
                  -- #######################################################################################
                  SELECT 
                    Item = CASE WHEN DotPos = 0 AND @PartMode = 2 THEN '%.' + Item ELSE Item END,
                    DotPos = CASE WHEN DotPos = 0 AND @PartMode = 2 THEN 2 ELSE DotPos END
                  FROM 
                    (
                      -- #######################################################################################
                      -- ###### Find the first dot position in the filter expression
                      -- #######################################################################################
                      SELECT 
                        Item,
                        DotPos = CHARINDEX('.', Item, 1) 
                      FROM
                        dbautils.fnStringList2Table(@FilterExpression, ',')
                    ) DotPositions
                ) HandleUnknownPrimary
            ) ExtractTwoPart
        ) WhitespaceHandling
      UNION
      -- #######################################################################################
      -- ###### Add an include all objects filter expression, if the @FilterExpression is empty
      -- #######################################################################################
      SELECT 
        IncludeExclude = 'I',
        PrimaryName = '%',
        SecondaryName = '%'
      WHERE
        ISNULL(@FilterExpression,'') = ''
    ) X
    
  DECLARE @IncludeExclude CHAR(1) 
  DECLARE @PrimaryName sysname
  DECLARE @SecondaryName sysname
  DECLARE @IncludeAll BIT
  DECLARE @ExcludeAll BIT
  DECLARE @I INT

  SET @IncludeAll = 0
  SET @ExcludeAll = 0
  SET @I = 1

  -- #######################################################################################
  -- ###### Go through all objects filter expression and add matching objects for the include/
  -- ###### exclude table
  -- #######################################################################################
  WHILE (1 = 1)
  BEGIN
    SELECT @IncludeExclude = IncludeExclude, @PrimaryName = PrimaryName, @SecondaryName = SecondaryName FROM @FiltersTable WHERE Number = @I
    IF @@ROWCOUNT = 0 BREAK
    -- #######################################################################################
    -- ###### If the current filter expression is an inclusion, then add all matching objects
    -- ###### to the inclusion table
    -- #######################################################################################
    IF (@IncludeExclude = 'I') AND @IncludeAll = 0
    BEGIN
      -- #######################################################################################
      -- ###### If we have already included all objects, bait out, there are no need to check 
      -- ###### other filters
      -- #######################################################################################
      IF @PrimaryName = '%' AND @SecondaryName = '%' 
        SET @IncludeAll = 1
        
      -- #######################################################################################
      -- ###### Check if the column name matches a standard column group and if it does add
      -- ###### the column groups columns to the includelist
      -- #######################################################################################
      INSERT @IncludeTable (PrimaryId, PrimaryName, SecondaryId, SecondaryName)
      SELECT 
        PrimaryId, 
        PrimaryName, 
        SecondaryId, 
        SecondaryName
      FROM 
        @QuickFilterTables
      WHERE 
        QuickGroupName = @PrimaryName
      EXCEPT
      -- #######################################################################################
      -- ###### Exclude all columns, which are already in the includelist
      -- #######################################################################################
      SELECT 
        PrimaryId, 
        PrimaryName, 
        SecondaryId, 
        SecondaryName
      FROM
        @IncludeTable

      -- #######################################################################################
      -- ###### if @@Rowcount <> 0 it means that the filter expression matched a standard 
      -- ###### column group, we need to skip like column matching
      -- #######################################################################################
      IF @@ROWCOUNT = 0
      BEGIN
        INSERT @IncludeTable (PrimaryId, PrimaryName, SecondaryId, SecondaryName)
        -- #######################################################################################
        -- ###### Find all objects, which matches the include filter expression
        -- #######################################################################################
        SELECT
          PrimaryId, 
          PrimaryName, 
          SecondaryId, 
          SecondaryName
        FROM 
          @ValuesTable
        WHERE 
          PrimaryName LIKE @PrimaryName AND
          SecondaryName LIKE @SecondaryName
        EXCEPT
        -- #######################################################################################
        -- ###### exclude all objects, which are already in the includelist
        -- #######################################################################################
        SELECT 
          PrimaryId, 
          PrimaryName, 
          SecondaryId, 
          SecondaryName
        FROM
          @IncludeTable
      END
    END
    
    -- #######################################################################################
    -- ###### If the current filter expression is an exclusion, then add all matching objects
    -- ###### to the exclusion table
    -- #######################################################################################
    IF (@IncludeExclude = 'E') AND @ExcludeAll = 0
    BEGIN
      -- #######################################################################################
      -- ###### If we have already excluded all objects, bait out, there are no need to check 
      -- ###### other filters
      -- #######################################################################################
      IF @PrimaryName = '%' AND @SecondaryName = '%' 
        SET @ExcludeAll = 1
        
      -- #######################################################################################
      -- ###### Check if the column name matches a standard column group and if it does add
      -- ###### the column groups columns to the ExcludeList
      -- #######################################################################################
      INSERT @ExcludeTable (PrimaryId, PrimaryName, SecondaryId, SecondaryName)
      SELECT 
        PrimaryId, 
        PrimaryName, 
        SecondaryId, 
        SecondaryName
      FROM 
        @QuickFilterTables
      WHERE 
        QuickGroupName = @PrimaryName
      EXCEPT
      -- #######################################################################################
      -- ###### Exclude all columns, which are already in the excludeList
      -- #######################################################################################
      SELECT 
        PrimaryId, 
        PrimaryName, 
        SecondaryId, 
        SecondaryName
      FROM
        @ExcludeTable
        
        
      -- #######################################################################################
      -- ###### if @@Rowcount <> 0 it means that the filter expression matched a standard 
      -- ###### column group, we need to skip like column matching
      -- #######################################################################################
      IF @@ROWCOUNT = 0
      BEGIN
        -- #######################################################################################
        -- ###### Find all objects, which matches the exclude filter expression
        -- #######################################################################################
        INSERT @ExcludeTable (PrimaryId, PrimaryName, SecondaryId, SecondaryName)
        SELECT
          PrimaryId, 
          PrimaryName, 
          SecondaryId, 
          SecondaryName
        FROM 
          @ValuesTable
        WHERE 
          PrimaryName LIKE @PrimaryName AND
          SecondaryName LIKE @SecondaryName
        EXCEPT
        -- #######################################################################################
        -- ###### exclude all objects, which are already in the excludelist
        -- #######################################################################################
        SELECT 
          PrimaryId, 
          PrimaryName, 
          SecondaryId, 
          SecondaryName
        FROM
          @ExcludeTable
      END
    END
  
    SET @I = @I + 1  
  END
    
    
  -- #######################################################################################
  -- ###### Returns a list of table which matches the inclusion filters, except if the 
  -- ###### objects matches an exclusion filter
  -- #######################################################################################
  INSERT INTO @ReturnTable (PrimaryId, SecondaryId)
  SELECT 
    PrimaryId, 
    SecondaryId 
  FROM 
    @IncludeTable
  EXCEPT
  SELECT 
    PrimaryId, 
    SecondaryId 
  FROM 
    @ExcludeTable

  RETURN
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF SCHEMA_ID('dbautils') IS NULL EXECUTE ('CREATE SCHEMA dbautils AUTHORIZATION dbo')

IF (OBJECT_ID('dbautils.fnGetFilteredTables', N'TF') IS NOT NULL)
  DROP FUNCTION dbautils.fnGetFilteredTables
GO

CREATE FUNCTION dbautils.fnGetFilteredTables
(
  @FilterExpression NVARCHAR(MAX)
)
RETURNS @ReturnTable TABLE 
(
  SchemaId INT,
  ObjectId INT,
  SchemaName sysname,
  TableName sysname
)
/*********************************************************************************

  File:         fnGetFilteredTables.sql
  Author:       Michael Søndergaard
  Date:         May 2009
  Build Date:   20 March 2011
  Homepage:     http://sql.soendergaard.info
  Version:      1.0.0
  Supported / 
  Tested on:    Microsoft SQL Server 2005 & 2008
  
  Description:  This functions returns a table containing tables from
                the current database, which matches the filter expression. 

                You can have multiple filter expression, both inclusions and
                exclusions at the same time, but it needs to be comma separated. 
                
                The filter expression is basicly a like expression. So the same
                rules applies. If your filter expressions contains Like special  
                characters, when you must surround the characters with square 
                brackets.
                
                Always specify tables in 2 part names, if you want to hit exact 
                table names. if a dot is omittet, it is consider the table name in
                any schema.

                Null or empty filter expression means %.% basically all tables in
                all schemas
                
                Do not surround the objects with quotes nor square brackets. Qoutes 
                will be considered as part of the table name. Square brackets will 
                be considered part of the like expression.
                
                Leading and trailing whitespace in filter expression is removed, so
                if your tables contains leading or trailing whitespace, use some
                of the like wildcards for matching
                                
                The first dot, will always be preceived as the schema separator. in
                case you have a dot in the schema name. you must specify the schema 
                name using wildcards or placeholders
                
                The following options are supported.
                
                - as prefix means the filter is an exclusion
                + as prefix means the filter is an inclusion. You may
                  omit this character.
                  
                NB. exclusion always overrules inclusions.

  Usage:      See test cases

  -----------------------------------------------------------------------------------

  THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF
  ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
  TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
  PARTICULAR PURPOSE. YOU MAY USE AND MODIFY THIS CODE FREELY FOR
  YOUR OWN PURPOSE, IF YOU REMEMBER TO CREDIT MY WORK. HOWEVER YOU 
  MAY NOT REPUBLISH IT, AND CLAIM IT AS YOUR OWN WORK 


  -----------------------------------------------------------------------------------

  Revision History:

    Version 1.0.0 - May 10, 2009 
      - Support for inclusions / exclusion expressions
   
 
**********************************************************************************/

AS
BEGIN
  DECLARE @ValuesXml XML
  SET @ValuesXml = 
    (
      SELECT 
        PrimaryId = t.schema_id, 
        PrimaryName = s.name, 
        SecondaryId = object_id, 
        SecondaryName = t.name 
      FROM 
        sys.tables t
          JOIN sys.schemas s ON
            t.schema_id = s.schema_id
      FOR XML RAW
    )

  INSERT  @ReturnTable
  (
    SchemaId,
    ObjectId,
    SchemaName,
    TableName
  )
  SELECT
    SchemaId = PrimaryId,
    ObjectId = SecondaryId,
    SchemaName = s.name,
    TableName = t.name
  FROM 
    dbautils.fnGetFilteredObjects(@FilterExpression, 2, @ValuesXml, null) f
      JOIN sys.tables t ON
        f.SecondaryId = t.object_id
      JOIN sys.schemas s ON
          t.schema_id = s.schema_id
  
  RETURN
END

go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF SCHEMA_ID('dbautils') IS NULL EXECUTE ('CREATE SCHEMA dbautils AUTHORIZATION dbo')
  
IF (OBJECT_ID('dbautils.fnGetObjectAliases', N'TF') IS NOT NULL)
  DROP FUNCTION dbautils.fnGetObjectAliases
GO

CREATE FUNCTION dbautils.fnGetObjectAliases
(
  @AliasRuleType CHAR(1),
  @IncludeNonAliasedObjects BIT
)
RETURNS @ReturnTable TABLE 
(
  SchemaId INT NOT NULL,
  ObjectId INT NULL,
  ColumnId INT NULL,
  SchemaName sysname NOT NULL,
  TableName sysname NULL,
  ColumnName sysname NULL,
  AliasName sysname NOT NULL
)
/*********************************************************************************

  File:         fnGetObjectAliases.sql
  Author:       Michael Søndergaard
  Date:         April 2009
  Build Date:   20 March 2011
  Homepage:     http://sql.soendergaard.info
  Version:      1.0.0
  Supported / 
  Tested on:    Microsoft SQL Server 2005 & 2008
  
  Description:  This table value functions can be used to get an alias instead
                of the objects real name. The only supported objects types are Schemas, 
                Tables and Columns. 
                
                The alias chosen is based on rules 
                
                It is possible to have 3 different types wildcard rules, but there are
                a fixed precedence between the wildcard rules. Here are all the supported 
                wildcard rules. 

                Server global rules:  The DatabaseName is set to %, meaning that the
                                      rule applies to all databases on the server.
                                      This is supported for schemas, tables and 
                                      column aliases
                                      
                Schema global rules:  The SchemaName is set to %, meaning that the
                                      rule applies to all schema's. This is supported for 
                                      tables and column aliases
                                        
                Table global rules:   The TableName is set to %, meaning that the
                                      rule applies to all tables. This is only supported
                                      for column aliases
                
                It shouldn't be allowed for the function to have multiple rules covering 
                the same object with the same precedence. This would lead to random column 
                alias being chosen, and this is against the design
                 
                The more specific rules have higher precedence than the more generic rules.
                The precedence are as following, the higher the precedence the better
                
                Column Alias Rules
                
                0. %.%.%
                1  Database.%.%
                2. %.SchemaName.%
                3. Database.SchemaName.%
                4. %.%.TableName
                5. Database.%.TableName
                6. %.SchemaName.TableName                                                                              
                7. Database.SchemaName.TableName                                                                              

                Table Alias Rules

                0. %.%
                1  Database.%
                2. %.SchemaName
                3. Database.SchemaName

                Schema Alias Rules

                0. %.%
                1  Database.%
                
                This function uses like expressions, so all rules containing like 
                wildcard characters will be escaped, otherwise it would be impossible to 
                match tables, containing like wildcard characters in their name.  
                
                The function uses a synonym called AliasRulesSynonym, this is used 
                for ensuring that the code in the function is stable, but allows the 
                user of the function to choose there the real AliasRules table 
                should be located, without modifying the function accordingly. 
                
                The AliasRules table should have the following table structure.
                The name may be changed, but the AliasRulesSynonym should point 
                to table.

                CREATE TABLE dbautils.AliasRules
                (
                  DatabaseName sysname NOT NULL DEFAULT '',
                  SchemaName sysname NOT NULL DEFAULT '',
                  TableName sysname NOT NULL DEFAULT '',
                  ColumnName sysname NOT NULL DEFAULT '',
                  AliasName sysname NOT NULL,
                  RuleType AS 
                  (
                    CASE 
                      WHEN DatabaseName != '' AND SchemaName != '%' AND SchemaName != '' AND TableName = '' AND ColumnName = '' THEN 'S'
                      WHEN DatabaseName != '' AND SchemaName != '' AND TableName != '%' AND TableName != '' AND ColumnName = '' THEN 'T'
                      WHEN DatabaseName != '' AND SchemaName != '' AND TableName != '' AND ColumnName != '%' AND ColumnName != '' THEN 'C'
                    ELSE
                      '?'
                    END
                  ) PERSISTED,
                  RuleDescription AS 
                  (
                    CASE 
                      WHEN DatabaseName != '' AND SchemaName != '%' AND SchemaName != '' AND TableName = '' AND ColumnName = '' THEN 'Schema alias rule'
                      WHEN DatabaseName != '' AND SchemaName != '' AND TableName != '%' AND TableName != '' AND ColumnName = '' THEN 'Table alias rule'
                      WHEN DatabaseName != '' AND SchemaName != '' AND TableName != '' AND ColumnName != '%' AND ColumnName != '' THEN 'Column alias rule'
                    ELSE
                      'Invalid alias rule'
                    END
                  ) PERSISTED,
                  CONSTRAINT CHK_AliasRules CHECK 
                  (
                    RuleType IN ('S', 'T', 'C')
                  ),
                  CONSTRAINT PK_AliasRules PRIMARY KEY CLUSTERED (RuleType, DatabaseName, SchemaName, TableName, ColumnName)
                )
                
  Requirements: This function is depended on the dbautils.AliasRulesSynonym synonym 
                

  Usage:        See also Test cases in fnGetObjectAliases - Test Cases.sql

                Example 1 - Get all columns name with or without column aliases
                  
                SELECT * FROM dbautils.fnGetObjectAliases('C', 1)


                Example 2 - Get all columns name with column aliases 
                  
                SELECT * FROM dbautils.fnGetObjectAliases('C', 0)


                Example 3 - Get all columns name for table Production.WorkOrder with or without column aliases 
                  
                SELECT * FROM dbautils.fnGetObjectAliases('C', 1) WHERE TableName = 'WorkOrder' AND SchemaName = 'Production'


                Example 4 - Get all columns name for table Production.WorkOrder with or without column aliases 
                  
                SELECT * FROM dbautils.fnGetObjectAliases('C', 1) WHERE ObjectId = OBJECT_ID('Production.WorkOrder', 'U')
                

                Example 5 - Get all table name with or without table aliases
                  
                SELECT * FROM dbautils.fnGetObjectAliases('T', 1)


                Example 6 - Get all table names with table aliases 
                  
                SELECT * FROM dbautils.fnGetObjectAliases('T', 0)


                Example 7 - Get all table names for table Production.WorkOrder with or without table aliases 
                  
                SELECT * FROM dbautils.fnGetObjectAliases('T', 1) WHERE TableName = 'WorkOrder' AND SchemaName = 'Production'


                Example 8 - Get all table names for table Production.WorkOrder with or without table aliases 
                  
                SELECT * FROM dbautils.fnGetObjectAliases('T', 1) WHERE ObjectId = OBJECT_ID('Production.WorkOrder', 'U')


                Example 9 - Get all schema names with or without schema aliases
                  
                SELECT * FROM dbautils.fnGetObjectAliases('S', 1)


                Example 10 - Get all schema names with schema aliases 
                  
                SELECT * FROM dbautils.fnGetObjectAliases('S', 0)


                Example 11 - Get all schema names for schema Production with or without schema aliases 
                  
                SELECT * FROM dbautils.fnGetObjectAliases('S', 1) WHERE SchemaName = 'Production'


                Example 12 - Get all schema names for schema Production with or without schema aliases 
                  
                SELECT * FROM dbautils.fnGetObjectAliases('S', 1) WHERE SchemaId = SCHEMA_ID('Production')
                
                
  -----------------------------------------------------------------------------------

  THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF
  ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
  TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
  PARTICULAR PURPOSE. YOU MAY USE AND MODIFY THIS CODE FREELY FOR
  YOUR OWN PURPOSE, IF YOU REMEMBER TO CREDIT MY WORK. HOWEVER YOU 
  MAY NOT REPUBLISH IT, AND CLAIM IT AS YOUR OWN WORK 


  -----------------------------------------------------------------------------------

  Revision History:

    Version 1.0.0 - April 4, 2010 
      - Support for wildcard rules for Database, Schema and Table names
   
 
**********************************************************************************/

AS
BEGIN
  SET @AliasRuleType = UPPER(@AliasRuleType)
  
  IF @AliasRuleType = 'C'
  BEGIN
    -- ###############################################################################
    -- ###### Return a table of all table columns and column aliases if they exists
    -- ###############################################################################
    INSERT INTO @ReturnTable
    (
      SchemaId,
      ObjectId,
      ColumnId,
      SchemaName,
      TableName,
      ColumnName,
      AliasName
    )
    SELECT
      SchemaId = S.schema_id,
      ObjectId = C.object_id,
      ColumnId = C.column_id,
      SchemaName = S.name,
      TableName = T.name,
      ColumnName = C.name,
      AliasName = ISNULL(Aliases.AliasName, C.name)
    FROM
      sys.columns C 
      JOIN sys.tables T ON 
        T.object_id = C.object_id
      JOIN sys.schemas S ON 
        S.schema_id = T.schema_id
      OUTER APPLY    
      (
        -- #######################################################################################
        -- ###### Only return the highest priority column alias for a specific column in a table 
        -- #######################################################################################
        SELECT
          TOP (1)  
          AliasName = AliasCandidates.AliasName
        FROM
          (
            -- ################################################################################
            -- ###### Generate a derived table of all Column aliases and their priority value
            -- ################################################################################
            SELECT
              -- ################################################################
              -- ###### The like expressions wild card characters should be
              -- ###### escaped otherwise tables or schema, which include these
              -- ###### characters wouldn't be matched
              -- ################################################################
              DatabaseId =
                CASE 
                  WHEN DatabaseName= '%' THEN DB_ID() 
                ELSE 
                  DB_ID(DatabaseName)
                END,
              SchemaPattern =
                CASE 
                  WHEN SchemaName = '%' THEN SchemaName 
                ELSE 
                  REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(SchemaName,  '[', '[[]'), '?', '[?]'), '*', '[*]'),'%', '[%]'), '_', '[_]'), '^', '^')
                END,
              TablePattern = 
                CASE 
                  WHEN TableName = '%' THEN TableName 
                ELSE 
                  REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(TableName,  '[', '[[]'), '?', '[?]'), '*', '[*]'),'%', '[%]'), '_', '[_]'), '^', '^')
                END,
              ColumnName,
              AliasName,
              -- ##############################################################
              -- ###### The more specific rules should have higher precedence
              -- ##############################################################
              Priority =  
                CASE
                  WHEN DatabaseName != '%' AND SchemaName != '%' AND TableName  != '%' THEN 7
                  WHEN DatabaseName  = '%' AND SchemaName != '%' AND TableName  != '%' THEN 6
                  WHEN DatabaseName != '%' AND SchemaName  = '%' AND TableName  != '%' THEN 5
                  WHEN DatabaseName  = '%' AND SchemaName  = '%' AND TableName  != '%' THEN 4
                  WHEN DatabaseName != '%' AND SchemaName != '%' AND TableName   = '%' THEN 3
                  WHEN DatabaseName  = '%' AND SchemaName != '%' AND TableName   = '%' THEN 2
                  WHEN DatabaseName != '%' AND SchemaName  = '%' AND TableName   = '%' THEN 1
                  WHEN DatabaseName  = '%' AND SchemaName  = '%' AND TableName   = '%' THEN 0
                END  
            FROM 
              dbautils.AliasRulesSynonym
            WHERE
              RuleType = @AliasRuleType        
          ) AliasCandidates 
        WHERE 
          DB_ID() = AliasCandidates.DatabaseId AND
          S.name LIKE AliasCandidates.SchemaPattern AND
          T.name LIKE AliasCandidates.TablePattern AND
          C.name = AliasCandidates.ColumnName 
        ORDER BY 
          AliasCandidates.Priority DESC
      ) Aliases 
    WHERE
      @IncludeNonAliasedObjects = 1 OR
      (@IncludeNonAliasedObjects = 0 AND Aliases.AliasName IS NOT NULL)
  END
  ELSE
  -- #######################################################################################
  -- ###### Table Aliases section
  -- #######################################################################################
  IF @AliasRuleType = 'T'
  BEGIN
    -- ###############################################################################
    -- ###### Return a table of all table and table aliases if they exists
    -- ###############################################################################
    INSERT INTO @ReturnTable
    (
      SchemaId,
      ObjectId,
      ColumnId,
      SchemaName,
      TableName,
      ColumnName,
      AliasName
    )
    SELECT
      SchemaId = S.schema_id,
      ObjectId = T.object_id,
      ColumnId = NULL,    
      SchemaName = S.name,
      TableName = T.name,
      ColumnName = NULL,
      AliasName = ISNULL(Aliases.AliasName, T.name)
    FROM
      sys.tables T 
      JOIN sys.schemas S ON 
        S.schema_id = T.schema_id
      OUTER APPLY    
      (
        -- #######################################################################################
        -- ###### Only return the highest priority table alias for a specific table
        -- #######################################################################################
        SELECT
          TOP (1)  
          AliasName = AliasCandidates.AliasName
        FROM
          (
            -- ################################################################################
            -- ###### Generate a derived table of all table aliases and their priority value
            -- ################################################################################
            SELECT
              -- ################################################################
              -- ###### The like expressions wild card characters should be
              -- ###### escaped otherwise tables or schema, which include these
              -- ###### characters wouldn't be matched
              -- ################################################################
              DatabaseId =
                CASE 
                  WHEN DatabaseName= '%' THEN DB_ID() 
                ELSE 
                  DB_ID(DatabaseName)
                END,
              SchemaPattern =
                CASE 
                  WHEN SchemaName = '%' THEN SchemaName 
                ELSE 
                  REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(SchemaName,  '[', '[[]'), '?', '[?]'), '*', '[*]'),'%', '[%]'), '_', '[_]'), '^', '^')
                END,
              TableName,
              AliasName,
              -- ##############################################################
              -- ###### The more specific rules should have higher precedence
              -- ##############################################################
              Priority =  
                CASE
                  WHEN DatabaseName != '%' AND SchemaName != '%' THEN 3
                  WHEN DatabaseName  = '%' AND SchemaName != '%' THEN 2
                  WHEN DatabaseName != '%' AND SchemaName  = '%' THEN 1
                  WHEN DatabaseName  = '%' AND SchemaName  = '%' THEN 0
                END  
            FROM 
              dbautils.AliasRulesSynonym
            WHERE
              RuleType = @AliasRuleType        
          ) AliasCandidates 
        WHERE 
          DB_ID() = AliasCandidates.DatabaseId AND
          S.name LIKE AliasCandidates.SchemaPattern AND
          T.name = AliasCandidates.TableName 
        ORDER BY 
          AliasCandidates.Priority DESC
      ) Aliases 
    WHERE
      @IncludeNonAliasedObjects = 1 OR
      (@IncludeNonAliasedObjects = 0 AND Aliases.AliasName IS NOT NULL)
  END  
  ELSE
  IF @AliasRuleType = 'S'
  BEGIN
    -- ###############################################################################
    -- ###### Return a table of all schemas and schema aliases if they exists
    -- ###############################################################################
    INSERT INTO @ReturnTable
    (
      SchemaId,
      ObjectId,
      ColumnId,
      SchemaName,
      TableName,
      ColumnName,
      AliasName
    )
    SELECT
      SchemaId = S.schema_id,
      ObjectId = NULL,
      ColumnId = NULL,    
      SchemaName = S.name,
      TableName = NULL,
      ColumnName = NULL,
      AliasName = ISNULL(Aliases.AliasName, S.name)
    FROM
      sys.schemas S  
      OUTER APPLY    
      (
        -- #######################################################################################
        -- ###### Only return the highest priority schema alias for a specific schema
        -- #######################################################################################
        SELECT
          TOP (1)  
          AliasName = AliasCandidates.AliasName
        FROM
          (
            -- ################################################################################
            -- ###### Generate a derived table of all schema aliases and their priority value
            -- ################################################################################
            SELECT
              -- ################################################################
              -- ###### The like expressions wild card characters should be
              -- ###### escaped otherwise tables or schema, which include these
              -- ###### characters wouldn't be matched
              -- ################################################################
              DatabaseId =
                CASE 
                  WHEN DatabaseName= '%' THEN DB_ID() 
                ELSE 
                  DB_ID(DatabaseName)
                END,
              SchemaName,
              AliasName,
              -- ##############################################################
              -- ###### The more specific rules should have higher precedence
              -- ##############################################################
              Priority =  
                CASE
                  WHEN DatabaseName != '%' AND SchemaName  = '%' THEN 1
                  WHEN DatabaseName  = '%' AND SchemaName  = '%' THEN 0
                END  
            FROM 
              dbautils.AliasRulesSynonym
            WHERE
               RuleType = 'S'        
          ) AliasCandidates 
        WHERE 
          DB_ID() = AliasCandidates.DatabaseId AND
          S.name = AliasCandidates.SchemaName 
        ORDER BY 
          AliasCandidates.Priority DESC
      ) Aliases 
    WHERE
      @IncludeNonAliasedObjects = 1 OR
      (@IncludeNonAliasedObjects = 0 AND Aliases.AliasName IS NOT NULL)
  END
    
  RETURN
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF SCHEMA_ID('dbautils') IS NULL EXECUTE ('CREATE SCHEMA dbautils AUTHORIZATION dbo')

IF (OBJECT_ID('dbautils.spFixForeignKeyNaming', N'P') IS NOT NULL)
  DROP PROCEDURE dbautils.spFixForeignKeyNaming
GO

CREATE PROCEDURE dbautils.spFixForeignKeyNaming
(
  @NamingConvention NVARCHAR(MAX) = NULL,
  @FilterExpression NVARCHAR(MAX) = NULL,
  @UseAliases CHAR(3) = NULL,
  @ForceCaseSensitivity BIT = NULL,
  @OversizedMode CHAR = NULL,
  @MaxNameLength TINYINT = NULL,
  @UniquifyNames BIT = NULL,
  @IncludeRollback BIT = NULL,
  @PerformUpdate TINYINT = NULL,
  @ReportMode BIT = NULL,
  @EnabledStates NVARCHAR(MAX) = NULL,
  @ReplicationStates NVARCHAR(MAX) = NULL,
  @TrustedStates NVARCHAR(MAX) = NULL,
  @ColumnsSeparator NVARCHAR(50) = NULL,
  @DeleteRefActions NVARCHAR(MAX) = NULL,
  @UpdateRefActions NVARCHAR(MAX) = NULL,
  @MaxParentColumns TINYINT = NULL,
  @MaxReferencedColumns TINYINT = NULL
)
/*********************************************************************************

  File:         spFixForeignKeyNaming.sql
  Author:       Michael Søndergaard
  Date:         June 2010
  Build Date:   20 March 2011
  Homepage:     http://sql.soendergaard.info
  Version:      1.0.1
  Supported /
  Tested on:    Microsoft SQL Server 2005 & 2008

  Description:  This stored procedure can be used for creating SQL statement for
                renaming foreign key constraints, which doesn't comply with a
                specified naming convention.

                It is possible to limit the number of tables to check, with the
                filter expressions. For a more detailted description on using
                filter expressions, see the documentation for the table valued
                function "dbautils.fnGetFilteredTables" or look at some of the
                test cases.

                It is possible to use aliases instead of the original object names,
                this can be useful for shortening the generated names. For a more
                detailted description on using object aliases, see the documentation
                for the table valued function "dbautils.fnGetObjectAliases" or look
                at some of the test cases for that function

  Naming convention /
  Placeholders:

    %PARENT_SCHEMA_NAME%:
      Returns the schema name for the parent table, for which the foreign key belongs too

    %PARENT_TABLE_NAME%:
      Returns the parent table name without a schema part, for which the foreign key belongs too.

    %PARENT_COLUMNS%:
      Returns a list of parent columns in the foreign key constraint

    %REFERENCED_SCHEMA_NAME%:
      Returns the schema name for the referenced table, for which the foreign key points to

    %REFERENCED_TABLE_NAME%:
      Returns the table name without a schema part for the referenced table, for which the foreign key points to

    %REFERENCED_COLUMNS%:
      Returns a list of referenced columns in the foreign key constraint

    %COLUMNS_SEPARATOR%
      Returns the @ColumnsSeparator value

    %ENABLED_STATE%:  
      Returns the value corresponding to value in the @EnabledStates parameter.
      The value returned depends on, if the foreign key constraint are enabled or disabled

    %REPLICATION_STATE%:
      Returns the value corresponding to value in the @ReplicationStates parameter.
      The value returned depends on, if the foreign key constraint are enforce in replication scenarios

    %TRUSTED_STATE%
      Returns the value corresponding to value in the @TrustedStates parameter.
      The value returned depends on, if the foreign key constraint are trusted by sql server or not

    %DEL_REF_ACTION%
      Returns the value corresponding to value in the @DeleteRefStates parameter.
      The value returned depends on, the foreign key constraint delete referential action

    %UPD_REF_ACTION%
      Returns the value corresponding to value in the @UpdateRefStates parameter.
      The value returned depends on, the foreign key constraint update referential action

  Usage:  See test cases

  INPUTS:

    @NamingConvention: 
      This string contains the naming convention, which the foreign key constraints
      should comply with. The naming convention supports different placeholders tokens,
      which can be used for creating names. If the @NamingConvention isn't specified
      the SQL Standard convention is used.

    @FilterExpression:
      The FilterExpression can be used for limitting the number for tables, which should be
      checked. The default is empty, which means checking all tables in the database.

    @UseAliases:
      This parameter controls, if object aliasing should be applied, instead of the values in
      %COLUMN_NAME%, %SCHEMA_NAME% and %TABLE_NAME% aliases can help shortening the new name for the constraint
      The parameter is a char mask, where you can control, which type of objects should be aliased

      C = Use column aliases
      T = Use table aliases
      S = Use schema aliases

    @ForceCaseSensitivity:
      This parameter controls, if foreign key constraints, which only differs in casing, should be
      renamed or not

    @OversizedMode:
      This parameter can be used for controlling, what should happen, if the new generated
      foreign key constraint name is longer than the allowed @MaxNameLength characters.

        T:  The foreign key constraint name is truncted to fit into @MaxNameLength characters, meaning every characters
            after @MaxNameLength are cut off

        S:  If the foreign key constraint name exceeds @MaxNameLength characters, when the hole renaming of that
            foreign key constraint are ignored

    @MaxNameLength:
      This parameter can be used to control max length for foreign key constraint name. It also controls,
      when the oversize mode should step in

    @UniquifyNames
      This parameter controls, if steps should be taken for making sure, that the new names won't name crash, with
      another foreign key constraint name. The default behavior is on

    @IncludeRollback:
      This parameter control if a rollback script should be create, in case you want to undone the renaming cases.

    @PerformUpdate:
      This parameter controls whether the stored procedure should perform the renaming directly or
      just generate a renaming script.

      0 = Don't rename directly, only generate script
      1 = Rename foreign key constraints directly, and output script for progress
      2 = Rename foreign key constraints directly, and don't output script for progress

    @ReportMode:
      This mode can be used to return a result of foreign key constraints, which doesn't comply with the specified
      naming convention

    @EnabledStates:
      Comma separated name/value list for the foreign key constraint state. E.g. are the constraint enabled or disabled.
      The format should be as this 'ENABLED_STATE_YES=<VALUE IF ENABLED>,ENABLED_STATE_NO=<VALUE IF DISABLED>'

    @ReplicationStates:
      Comma separated name/value list for the foreign key constraint replicating state. E.g. are the constraint used in replication.
      The format should be as this 'REPLICATION_STATE_YES=<VALUE IF FOR REPLICATION>,REPLICATION_STATE_NO=<VALUE IF NOT FOR REPLICATION>'

    @TrustedStates:
      Comma separated name/value list for the foreign key constraint trusted state. E.g. are the constraint verified and trusted by SQL Server.
      The format should be as this 'TRUSTED_STATE_YES=<VALUE IF TRUSTED>,TRUSTED_STATE_NO=<VALUE IF NOT TRUSTED>'

    @ColumnsSeparator:
      The string value which should separate each foreign key columns

    @MaxParentColumns:
      This parameter can be used to control the maximum number of index columns, which should be part of the index name.
      Zero or null means all index columns 

    @MaxReferencedColumns:
      This parameter can be used to control the maximum number of index columns, which should be part of the index name.
      Zero or null means all index columns

    @DeleteRefStates:
      Comma separated name/value list for foreign key delete referential action state. The format should be as this
      (line breaks are only for read ability)

      'DEL_REF_NO_ACTION=<VALUE FOR NO DELETE ACTION>,
       DEL_REF_CASCADE=<VALUE FOR CASCADE DELETE ACTION>,
       DEL_REF_SET_NULL=<VALUE FOR SET NULL DELETE ACTION>,
       DEL_REF_SET_DEFAULT=<VALUE FOR SET DEFAULT DELETE ACTION>'

    @UpdateRefStates: 
      Comma separated name/value list for foreign key delete referential action state. The format should be as this
      (line breaks are only for read ability)

      'UPD_REF_NO_ACTION=<VALUE FOR NO UPDATE ACTION>,
       UPD_REF_CASCADE=<VALUE FOR CASCADE UPDATE ACTION>,
       UPD_REF_SET_NULL=<VALUE FOR SET NULL UPDATE ACTION>,
       UPD_REF_SET_DEFAULT=<VALUE FOR SET DEFAULT UPDATE ACTION>'

  -----------------------------------------------------------------------------------

  THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF
  ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
  TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
  PARTICULAR PURPOSE. YOU MAY USE AND MODIFY THIS CODE FREELY FOR
  YOUR OWN PURPOSE, IF YOU REMEMBER TO CREDIT MY WORK. HOWEVER YOU 
  MAY NOT REPUBLISH IT, AND CLAIM IT AS YOUR OWN WORK 


  -----------------------------------------------------------------------------------

  Revision History:

    Version 1.0.0 - June 19, 2010 
      - Inital version

    Version 1.0.1 - 19 Marts, 2011
      - Added support for creating rollback statements
      - Fixed bug where old and new names were equal, but reported as different
  -----------------------------------------------------------------------------------


**********************************************************************************/
AS
BEGIN
  SET NOCOUNT ON
  -- ###################################################################################
  -- ###### VARIABLES DECLARATION SECTION
  -- ###################################################################################
  DECLARE @SchemaName sysname
  DECLARE @OldName sysname
  DECLARE @NewName sysname
  DECLARE @SQL NVARCHAR(MAX)
  DECLARE @MSG NVARCHAR(MAX)
  DECLARE @InfoMSG NVARCHAR(MAX)
  DECLARE @I INT
  DECLARE @NewNameAlreadyExists BIT
  DECLARE @NoOfNonCompliantTables INT
  DECLARE @WarningNameClash NVARCHAR(200)
  DECLARE @IsDisabledDesc NVARCHAR(50)
  DECLARE @IsEnabledDesc NVARCHAR(50)
  DECLARE @IsNotForReplDesc NVARCHAR(50)
  DECLARE @IsForReplDesc NVARCHAR(50)
  DECLARE @IsNotTrustedDesc NVARCHAR(50)
  DECLARE @IsTrustedDesc NVARCHAR(50)
  DECLARE @TableName sysname
  DECLARE @DelRefNoActionDesc NVARCHAR(50)
  DECLARE @DelRefCascadeDesc NVARCHAR(50)
  DECLARE @DelRefSetNullDesc NVARCHAR(50)
  DECLARE @DelRefSetDefaultDesc NVARCHAR(50)
  DECLARE @UpdRefNoActionDesc NVARCHAR(50)
  DECLARE @UpdRefCascadeDesc NVARCHAR(50)
  DECLARE @UpdRefSetNullDesc NVARCHAR(50)
  DECLARE @UpdRefSetDefaultDesc NVARCHAR(50)


  -- ###############################################################################
  -- ###### This table contains the list of foreign key constraints, which 
  -- ###### doesn't comply with the specified naming.
  -- ###############################################################################
  DECLARE @FixList TABLE
  (
    Number INT NOT NULL PRIMARY KEY CLUSTERED,
    SchemaName sysname NOT NULL,
    TableName sysname NOT NULL,
    OldName sysname NOT NULL,
    NewName NVARCHAR(500) NOT NULL,
    SkipCode TINYINT NOT NULL,
    NewNameAlreadyExists BIT NOT NULL DEFAULT 0
  )

  -- ###############################################################################
  -- ###### This table contains the a list of name key / values
  -- ###############################################################################
  DECLARE @NameValueTable AS TABLE 
  (
    Name NVARCHAR(50) NOT NULL PRIMARY KEY,
    Value NVARCHAR(50) NOT NULL
  )

  -- ###################################################################################
  -- ###### VARIABLES INITIALIZATION SECTION
  -- ###################################################################################
  SET @NamingConvention = ISNULL(NULLIF(@NamingConvention, ''), 'FK_%PARENT_TABLE_NAME%_%REFERENCED_TABLE_NAME%')
  SET @FilterExpression = ISNULL(@FilterExpression, '')
  SET @UseAliases = ISNULL(UPPER(@UseAliases), '')
  SET @ForceCaseSensitivity = ISNULL(@ForceCaseSensitivity, 0)
  SET @OversizedMode = ISNULL(NULLIF(@OversizedMode, ''), 'T')
  SET @MaxNameLength = ISNULL(@MaxNameLength, 128)
  SET @UniquifyNames = ISNULL(@UniquifyNames, 1)
  SET @IncludeRollback = ISNULL(@IncludeRollback, 0)
  SET @PerformUpdate = ISNULL(@PerformUpdate, 0)
  SET @ReportMode = ISNULL(@ReportMode, 0)
  SET @WarningNameClash = 'Warning!!! the generated foreign key constraint name already exists in a different table. You might have a rename dependency order'  
  SET @EnabledStates = ISNULL(@EnabledStates, 'ENABLED_STATE_YES=,ENABLED_STATE_NO=_Disabled')
  SET @ReplicationStates = ISNULL(@ReplicationStates, 'REPLICATION_STATE_YES=,REPLICATION_STATE_NO=_NotForRepl')
  SET @TrustedStates = ISNULL(@TrustedStates, 'TRUSTED_STATE_YES=,TRUSTED_STATE_NO=_Untrusted')
  SET @DeleteRefActions = ISNULL(@DeleteRefActions, 'DEL_REF_NO_ACTION=,DEL_REF_CASCADE=_DelRefCascade,DEL_REF_SET_NULL=_DelRefSetNull,DEL_REF_SET_DEFAULT=_DelRefSetDefault')
  SET @UpdateRefActions = ISNULL(@UpdateRefActions, 'UPD_REF_NO_ACTION=,UPD_REF_CASCADE=_UpdRefCascade,UPD_REF_SET_NULL=_UpdRefSetNull,UPD_REF_SET_DEFAULT=_UpdRefSetDefault')
  SET @ColumnsSeparator = ISNULL(@ColumnsSeparator, '_')
  SET @MaxParentColumns = ISNULL(@MaxParentColumns, 0)
  SET @MaxReferencedColumns = ISNULL(@MaxReferencedColumns, 0)

  -- ###################################################################################
  -- ###### Generate one name / value list with unique name keys
  -- ###################################################################################
  DECLARE @NameValueList NVARCHAR(MAX)
  SET @NameValueList =
    @EnabledStates + CASE WHEN @EnabledStates = '' THEN '' ELSE ',' END +
    @ReplicationStates + CASE WHEN @ReplicationStates = '' THEN '' ELSE ',' END +
    @TrustedStates + CASE WHEN @TrustedStates = '' THEN '' ELSE ',' END +
    @DeleteRefActions + CASE WHEN @DeleteRefActions = '' THEN '' ELSE ',' END +
    @UpdateRefActions 

  -- ###################################################################################
  -- ###### Convert the name / value comma list to a name key / value table
  -- ###################################################################################
  INSERT @NameValueTable ( Name, Value ) 
  SELECT 
    [Name] = UPPER(SUBSTRING(Item, 1, EqualSignPos - 1)),
    [Value] = SUBSTRING(Item, EqualSignPos + 1, 9999)
  FROM
    (
      SELECT 
        Item,
        EqualSignPos = CHARINDEX('=', Item, 1)
      FROM
        dbautils.fnStringList2Table(@NameValueList, ',')
    ) ItemList
  WHERE
    EqualSignPos != 0

  -- ###################################################################################
  -- ###### Extract the values from the name key / value table to local variables
  -- ###################################################################################

  SET @IsDisabledDesc = ISNULL((SELECT Value FROM @NameValueTable WHERE Name = 'ENABLED_STATE_NO'), '')
  SET @IsEnabledDesc = ISNULL((SELECT Value FROM @NameValueTable WHERE Name = 'ENABLED_STATE_YES'), '')
  SET @IsTrustedDesc = ISNULL((SELECT Value FROM @NameValueTable WHERE Name = 'TRUSTED_STATE_YES'), '')
  SET @IsNotTrustedDesc = ISNULL((SELECT Value FROM @NameValueTable WHERE Name = 'TRUSTED_STATE_NO'), '')
  SET @IsForReplDesc = ISNULL((SELECT Value FROM @NameValueTable WHERE Name = 'REPLICATION_STATE_YES'), '')
  SET @IsNotForReplDesc = ISNULL((SELECT Value FROM @NameValueTable WHERE Name = 'REPLICATION_STATE_NO'), '')
  SET @DelRefNoActionDesc = ISNULL((SELECT Value FROM @NameValueTable WHERE Name = 'DEL_REF_NO_ACTION'), '')
  SET @DelRefCascadeDesc = ISNULL((SELECT Value FROM @NameValueTable WHERE Name = 'DEL_REF_CASCADE'), '')
  SET @DelRefSetNullDesc = ISNULL((SELECT Value FROM @NameValueTable WHERE Name = 'DEL_REF_SET_NULL'), '')
  SET @DelRefSetDefaultDesc = ISNULL((SELECT Value FROM @NameValueTable WHERE Name = 'DEL_REF_SET_DEFAULT'), '')
  SET @UpdRefNoActionDesc = ISNULL((SELECT Value FROM @NameValueTable WHERE Name = 'UPD_REF_NO_ACTION'), '')
  SET @UpdRefCascadeDesc = ISNULL((SELECT Value FROM @NameValueTable WHERE Name = 'UPD_REF_CASCADE'), '')
  SET @UpdRefSetNullDesc = ISNULL((SELECT Value FROM @NameValueTable WHERE Name = 'UPD_REF_SET_NULL'), '')
  SET @UpdRefSetDefaultDesc = ISNULL((SELECT Value FROM @NameValueTable WHERE Name = 'UPD_REF_SET_DEFAULT'), '')

  BEGIN TRY
    IF (@PerformUpdate > 0 AND @ReportMode = 1)
      RAISERROR ('Cannot perform updates while the report mode is on',16, 1)

    IF (@PerformUpdate > 0 AND @IncludeRollback = 1)
      RAISERROR ('The feature include rollback script is not supported while in perform update mode',16, 1)

    IF (@ReportMode = 1 AND @IncludeRollback = 1)
      RAISERROR ('The feature include rollback script is not supported while in report mode',16, 1)

    IF (@MaxNameLength < 1)
      RAISERROR ('The names must consist of atleast one character', 16, 1)

    IF (@MaxNameLength > 128)
      RAISERROR ('The names are not allowed to be more than 128 characters long', 16, 1)

    IF (@UseAliases != '' AND PATINDEX('[^STC]', @UseAliases) > 0)
      RAISERROR ('The @UseAliases only allow values in (''S'',''T'', ''C'')', 16, 1)

    -- ###############################################################################
    -- ###### Populate the table with foreign keys constraints, which doesn't comply
    -- ###### with the specified naming convention. 
    -- ######
    -- ###### The OldName column represents the current name of the foreign key constaint
    -- ###### The NewName column represents the new name the foreign key constaint
    -- ###### should have, based on the specified name convention
    -- ###############################################################################
    INSERT INTO @FixList
    (
      Number,
      SchemaName,
      TableName,
      OldName,
      NewName,
      SkipCode
    )
    SELECT 
      Number = ROW_NUMBER() OVER (ORDER BY SchemaName, NewName),
      SchemaName,
      TableName,
      OldName,
      NewName,
      SkipCode
    FROM
      (
        SELECT 
          SchemaName,
          TableName,
          OldName,
          NewName = CASE WHEN Uniquifier = 1 OR @UniquifyNames = 0 THEN NewName ELSE NewName + CAST(Uniquifier AS NVARCHAR(15)) END,
          SkipCode
        FROM
          (
            -- ###################################################################################
            -- ###### Calculate an uniquifier for assisting generating unique names
            -- ###################################################################################
            SELECT 
              SchemaName,
              TableName,
              OldName,
              NewName,
              SkipCode,
              Uniquifier = ROW_NUMBER() OVER (PARTITION BY NewName ORDER BY SchemaName, NewName)
            FROM
              (
                -- ###################################################################################
                -- ###### Handle the oversized mode, and skip or truncate, if the name is too long
                -- ###################################################################################
                SELECT
                  SchemaName,
                  TableName,
                  OldName,
                  NewName  = CASE WHEN LEN(NewName) > @MaxNameLength AND @OversizedMode = 'T' THEN SUBSTRING(NewName, 1, @MaxNameLength) ELSE NewName END,
                  SkipCode = CASE WHEN LEN(NewName) > @MaxNameLength AND @OversizedMode = 'S' THEN CAST(1 AS TINYINT) ELSE CAST(0 AS TINYINT) END
                FROM    
                  (
                    -- #################################################################################################
                    -- ###### Generate a new foreign key constraint name, based on the pattern in the naming convention
                    -- #################################################################################################
                    SELECT
                      SchemaName = ParentSchemaName,
                      TableName = ParentTableName,
                      OldName,
                      NewName = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@NamingConvention, 
                        '%PARENT_SCHEMA_NAME%', ISNULL(ParentSchemaAlias, ParentSchemaName)), 
                        '%PARENT_TABLE_NAME%', ISNULL(ParentTableAlias, ParentTableName)), 
                        '%PARENT_COLUMNS%', ParentColumns), 
                        '%REFERENCED_SCHEMA_NAME%', ISNULL(ReferencedSchemaAlias, ReferencedSchemaName)), 
                        '%REFERENCED_TABLE_NAME%', ISNULL(ReferencedTableAlias, ReferencedTableName)), 
                        '%REFERENCED_COLUMNS%', ReferencedColumns), 
                        '%COLUMNS_SEPARATOR%', @ColumnsSeparator),
                        '%ENABLED_STATE%', StateDesc),
                        '%REPLICATION_STATE%', ReplicateDesc),
                        '%TRUSTED_STATE%', TrustedDesc),
                        '%DEL_REF_ACTION%', DelRefActionDesc),
                        '%UPD_REF_ACTION%', UpdRefActionDesc)
                    FROM
                      (
                        -- ###################################################################################
                        -- ###### Find all index details used for pattern substitution
                        -- ###################################################################################
                        SELECT 
                          ParentSchemaName = ps.name,
                          ParentSchemaAlias = psa.AliasName,
                          ParentTableName = pt.name,
                          ParentTableAlias = pta.AliasName,

                          ReferencedSchemaName = rs.name,
                          ReferencedSchemaAlias = rsa.AliasName,
                          ReferencedTableName = rt.name,
                          ReferencedTableAlias = rta.AliasName,

                          OldName = fk.name,

                          ParentColumns = LEFT(ParentCols.ParentColumns, LEN(ParentCols.ParentColumns) - LEN(@ColumnsSeparator)),
                          ReferencedColumns = LEFT(ReferencedCols.ReferencedColumns, LEN(ReferencedCols.ReferencedColumns) - LEN(@ColumnsSeparator)),
                          StateDesc = CASE WHEN fk.is_disabled = 1 THEN @IsDisabledDesc ELSE @IsEnabledDesc END,
                          ReplicateDesc = CASE WHEN fk.is_not_for_replication = 1 THEN @IsNotForReplDesc ELSE @IsForReplDesc END,
                          TrustedDesc = CASE WHEN fk.is_not_trusted = 1 THEN @IsNotTrustedDesc ELSE @IsTrustedDesc END,
                          DelRefActionDesc = 
                            CASE 
                              fk.delete_referential_action_desc 
                              WHEN 'NO_ACTION' THEN @DelRefNoActionDesc 
                              WHEN 'CASCADE' THEN @DelRefCascadeDesc
                              WHEN 'SET_NULL' THEN @DelRefSetNullDesc
                              WHEN 'SET_DEFAULT' THEN @DelRefSetDefaultDesc 
                            END,
                          UpdRefActionDesc = 
                            CASE 
                              fk.update_referential_action_desc 
                              WHEN 'NO_ACTION' THEN @UpdRefNoActionDesc 
                              WHEN 'CASCADE' THEN @UpdRefCascadeDesc
                              WHEN 'SET_NULL' THEN @UpdRefSetNullDesc
                              WHEN 'SET_DEFAULT' THEN @UpdRefSetDefaultDesc 
                            END
                        FROM  
                          sys.foreign_keys fk
                            JOIN sys.tables pt ON
                              fk.parent_object_id = pt.object_id 
                            JOIN sys.schemas ps ON
                              pt.schema_id = ps.schema_id
                            JOIN sys.tables rt ON
                              fk.referenced_object_id = rt.object_id 
                            JOIN sys.schemas rs ON
                              rt.schema_id = rs.schema_id
                            
                            JOIN dbautils.fnGetFilteredTables(@FilterExpression) pft ON
                              ps.name = pft.SchemaName AND
                              pt.name = pft.TableName

                            LEFT JOIN dbautils.fnGetObjectAliases('S', 0) psa ON 
                              ps.schema_id = psa.SchemaId AND 
                              @UseAliases LIKE '%S%' 
                            LEFT JOIN dbautils.fnGetObjectAliases('T', 0) pta ON 
                              pt.object_id = pta.ObjectId AND
                              @UseAliases LIKE '%T%' 

                            LEFT JOIN dbautils.fnGetObjectAliases('S', 0) rsa ON 
                              rs.schema_id = rsa.SchemaId AND 
                              @UseAliases LIKE '%S%' 
                            LEFT JOIN dbautils.fnGetObjectAliases('T', 0) rta ON 
                              rt.object_id = rta.ObjectId AND
                              @UseAliases LIKE '%T%' 
                            -- ##################################################################
                            -- ###### Convert the parent columns to a concatinated string list 
                            -- ##################################################################
                            CROSS APPLY 
                            ( 
                              SELECT 
                                ParentColumnName + @ColumnsSeparator 
                              FROM 
                                (
                                  -- ##################################################################
                                  -- ###### Order the parent foreign key columns by key_ordinals
                                  -- ######  and generate an ordinal number used for max parent columns
                                  -- ##################################################################
                                  SELECT 
                                    TOP (100) PERCENT
                                    ParentColumnName = ISNULL(ca.AliasName, c.name),
                                    Ordinal = ROW_NUMBER() OVER (ORDER BY fkc.constraint_column_id) 
                                  FROM 
                                    sys.foreign_key_columns fkc
                                      JOIN sys.columns c ON
                                        fk.object_id = fkc.constraint_object_id AND
                                        fkc.parent_object_id = c.object_id AND
                                        fkc.parent_column_id = c.column_id
                                      LEFT JOIN dbautils.fnGetObjectAliases('C', 0) ca ON 
                                        fkc.parent_object_id = ca.ObjectId AND
                                        fkc.parent_column_id = ca.ColumnId AND 
                                        @UseAliases LIKE '%C%' 
                                  ORDER BY 
                                    fkc.constraint_column_id
                                ) AllParentCols
                              WHERE 
                                (AllParentCols.Ordinal <= @MaxParentColumns OR @MaxParentColumns = 0)
                              FOR XML PATH('') 
                            )  ParentCols ( ParentColumns)
                            -- ##################################################################
                            -- ###### Convert the referenced columns to a concatinated string list 
                            -- ##################################################################
                            OUTER APPLY 
                            ( 
                              SELECT 
                                ReferencedColumnName + @ColumnsSeparator 
                              FROM 
                                (
                                  -- ##################################################################
                                  -- ###### Order the referenced foreign key columns by key_ordinals and 
                                  -- ###### generate an ordinal number used for max referenced columns
                                  -- ##################################################################
                                  SELECT 
                                    TOP (100) PERCENT
                                    ReferencedColumnName = ISNULL(ca.AliasName, c.name),
                                    Ordinal = ROW_NUMBER() OVER (ORDER BY fkc.constraint_column_id) 
                                  FROM 
                                    sys.foreign_key_columns fkc
                                      JOIN sys.columns c ON
                                        fk.object_id = fkc.constraint_object_id AND
                                        fkc.referenced_object_id = c.object_id AND
                                        fkc.referenced_column_id = c.column_id
                                      LEFT JOIN dbautils.fnGetObjectAliases('C', 0) ca ON 
                                        fkc.parent_object_id = ca.ObjectId AND 
                                        fkc.parent_column_id = ca.ColumnId AND 
                                        @UseAliases LIKE '%C%' 
                                  ORDER BY 
                                    fkc.constraint_column_id
                                ) AllReferencedCols
                              WHERE 
                                (AllReferencedCols.Ordinal <= @MaxReferencedColumns OR @MaxReferencedColumns = 0)
                              FOR XML PATH('') 
                            )  ReferencedCols ( ReferencedColumns)
                      ) ForeignKeyInfo
                  ) Oversizing
              ) FinalNames
          ) Uniquifiers
      ) UniquifyNames
    WHERE  
      (SkipCode = 0 OR @ReportMode = 1) AND
      (
        (OldName <> NewName AND @ForceCaseSensitivity = 0) OR
        (OldName COLLATE Latin1_General_BIN <> NewName COLLATE Latin1_General_BIN  AND @ForceCaseSensitivity = 1) 
      )
    SET @NoOfNonCompliantTables = @@ROWCOUNT

    UPDATE FL
    SET FL.NewNameAlreadyExists = 1
    FROM
      @FixList FL
        JOIN sys.foreign_keys fk ON
          FL.NewName = fk.name
        JOIN sys.tables t ON  
          fk.object_id = t.object_id AND
          t.name = FL.TableName
        JOIN sys.schemas s ON  
          t.schema_id = s.schema_id AND
          s.name = FL.SchemaName

    IF @NoOfNonCompliantTables = 0
    BEGIN
      PRINT 'All tables matching the filter expression, have foreign key constraints names, that complies with the specified naming convention...'
      RETURN 
    END
    ELSE
    IF @ReportMode = 1
    BEGIN
      PRINT 'List of foreign keys constraints, which doens''t comply with the specified naming convention'
      SELECT 
        SchemaName, 
        TableName, 
        OldName, 
        NewName,
        NewNameAlreadyExists = CASE WHEN NewNameAlreadyExists = 1 THEN 'Y' ELSE 'N' END,
        InfoMessage = 
          CASE   
            WHEN SkipCode = 1 THEN 'Renaming skipped because the new name contains ' + CAST(LEN(NewName) AS NVARCHAR(10)) + ' characters and exceed the max name length of ' + CAST(@MaxNameLength AS NVARCHAR(3))
            WHEN NewNameAlreadyExists = 1 THEN @WarningNameClash
          ELSE
            ''
          END
      FROM 
        @FixList
      ORDER BY SchemaName, TableName, OldName
      RETURN   
    END

    -- #######################################################################################
    -- ###### Go through all foreign key constraints, which isn't in compliance with the 
    -- ###### specified naming convention
    -- #######################################################################################
    IF (@PerformUpdate = 0)
    BEGIN
      PRINT '-- #######################################################################################'
      PRINT '-- ###### Change script for renaming foreign key constraints'
      PRINT '-- #######################################################################################'
    END

    SET @I = 1
    WHILE (1 = 1)
    BEGIN
      SELECT @SchemaName = SchemaName, @TableName = TableName, @OldName = OldName, @NewName = NewName, @NewNameAlreadyExists = NewNameAlreadyExists FROM @FixList WHERE Number = @I
      IF @@ROWCOUNT = 0 BREAK

      -- #######################################################################################
      -- ###### Create a T-SQL command that can be executed dynamically to rename the 
      -- ###### foreign key constraints, which doesn't comply with the specified naming standard.
      -- ######
      -- ###### NB. '''' used because of lenght limitations in QUOTENAME function
      -- #######################################################################################
      SET @InfoMSG = CASE WHEN @NewNameAlreadyExists = 1 THEN '-- ' + @WarningNameClash ELSE '' END 
      SET @MSG = 'Renaming foreign key constraint %SCHEMA_NAME%.%TABLE_NAME%.%OLD_NAME% to %SCHEMA_NAME%.%NEW_NAME%'
      SET @MSG = REPLACE(REPLACE(REPLACE(REPLACE(@MSG, 
        '%SCHEMA_NAME%', QUOTENAME(@SchemaName)), 
        '%OLD_NAME%', QUOTENAME(@OldName)), 
        '%NEW_NAME%', QUOTENAME(@NewName)), 
        '%TABLE_NAME%', QUOTENAME(@TableName))

      SET @SQL = 'EXECUTE sp_rename ''%SCHEMA_NAME%.%OLD_NAME%'',''%NEW_NAME%'', ''object'' %INFO_MESSAGE%'
      SET @SQL = REPLACE(REPLACE(REPLACE(REPLACE(@SQL, 
        '%SCHEMA_NAME%', QUOTENAME(REPLACE(@SchemaName, '''', ''''''))), 
        '%OLD_NAME%', QUOTENAME(REPLACE(@OldName, '''', ''''''))), 
        '%NEW_NAME%', REPLACE(@NewName, '''', '''''')), 
        '%INFO_MESSAGE%', @InfoMSG)

      IF @PerformUpdate = 1
      BEGIN
        PRINT @MSG      
        PRINT @SQL
        EXECUTE (@SQL)
      END
      IF @PerformUpdate = 2
        EXECUTE (@SQL)
      ELSE
        PRINT @SQL 

      SET @I = @I + 1  
    END

    -- #######################################################################################
    -- ###### Go through all foreign key constraints, which isn't in compliance with the specified
    -- ###### naming convention
    -- #######################################################################################
    SET @I = 1
    IF (@IncludeRollback = 1)
    BEGIN
      PRINT '' PRINT '' PRINT ''
      PRINT '-- #######################################################################################'
      PRINT '-- ###### Rollback script for renaming foreign key constraints back to original value'
      PRINT '-- #######################################################################################'
      WHILE (1 = 1)
      BEGIN

        SELECT @SchemaName = SchemaName, @OldName = OldName, @NewName = NewName FROM @FixList WHERE Number = @I
        IF @@ROWCOUNT = 0 BREAK

        SET @MSG = 'Renaming column foreign key constraint %SCHEMA_NAME%.%NEW_NAME% to %SCHEMA_NAME%.%OLD_NAME%'
        SET @MSG = REPLACE(REPLACE(REPLACE(@MSG, 
          '%SCHEMA_NAME%', QUOTENAME(@SchemaName)), 
          '%OLD_NAME%', QUOTENAME(@OldName)), 
          '%NEW_NAME%', QUOTENAME(@NewName)) 

        -- #######################################################################################
        -- ###### Create a T-SQL command that can be executed dynamically to rename the column
        -- ###### foreign key constraints, which doesn't comply with the naming standard.
        -- ###### NB. '''' used because of lenght limitations in QUOTENAME function
        -- #######################################################################################
        SET @SQL = 'EXECUTE sp_rename ''%SCHEMA_NAME%.%NEW_NAME%'',''%OLD_NAME%'', ''object'''
        SET @SQL = REPLACE(REPLACE(REPLACE(@SQL, 
          '%SCHEMA_NAME%', QUOTENAME(REPLACE(@SchemaName, '''', ''''''))), 
          '%OLD_NAME%', REPLACE(@OldName, '''', '''''')), 
          '%NEW_NAME%', QUOTENAME(REPLACE(@NewName, '''', ''''''))) 

        PRINT @SQL 

        SET @I = @I + 1  
      END
  END

  END TRY
  -- ########################################################################
  -- ##### An unforseen error have occurred, report it
  -- ########################################################################
  BEGIN CATCH
    PRINT ''
    PRINT 'Error in line #' + Cast(ERROR_LINE() AS VARCHAR(10))
    PRINT 'Error messages: ' + ERROR_MESSAGE()
  END CATCH
END
GO
