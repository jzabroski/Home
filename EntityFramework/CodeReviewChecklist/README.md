1. Entity Configuration
  1. Are all properties of type `String` mapped as `nvarchar`?  If no, does the column have to be `varchar`?  If yes, then map with `HasColumnType("varchar")`.
  2. Are all properties of type `Decimal` mapped with `HasPrecision(precision, scale)`?  If no, add `HasPrecision(precision, scale)`, as without it in EF6, this can cause silent truncation issues.
  3. Are all properties of type `DateTime` mapped with `datetime2(7)`?  If no, add 
  4. Is the entity using [Code First Data Annotations](https://docs.microsoft.com/en-us/ef/ef6/modeling/code-first/data-annotations) syntax for configuring entity mapping?  If yes, convert to fluent syntax, as it's generally more expressive.
2. Raw Queries / Executing Stored Procedures
  1. If you're using parameters, make sure:
      1. You also specify in the sql text the `@ParameterName1` .. `@ParameterNameN`
      2. Each `@ParameterName1` .. `@ParameterNameN` matches the `params object[] parameters` collection.
