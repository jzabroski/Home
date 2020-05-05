1. [AddWithValue is Evil](https://www.dbdelta.com/addwithvalue-is-evil/) by SQL Server MVP, Dan Guzman

    > The Problem with Addwithvalue
    > 
    > The nastiness with AddWithValue is that ADO.NET infers the parameter definition from the supplied object value. Parameters in SQL Server are inherently strongly-typed, including the SQL Server data type, length, precision, and scale. Types in .NET don’t always map precisely to SQL Server types, and are sometimes ambiguous, so AddWithValue has to makes guesses about the intended parameter type.
    > 
    > The guesses AddWithValue makes can have huge implications when wrong because SQL Server uses well-defined data type precedence rules when expressions involve unlike data types; the value with the lower precedence is implicitly converted to the higher type. The implicit conversion itself isn’t particularly costly but is a major performance concern when it is the column value rather than the parameter value must be converted, especially in a WHERE or JOIN clause predicate. The implicit column value conversion can prevent indexes on the column from being used with an index seek (i.e. non-sargable expression), resulting in a full scan of every row in the table or index.
    > 
    > Below are some of the most common pitfalls with AddWithValue.
    > 
    > 1. .NET Strings
    > 
    > ...
    > 
    > 2. .NET DateTime
    > 
    > ...
    > 
    > 3. .NET Decimal
