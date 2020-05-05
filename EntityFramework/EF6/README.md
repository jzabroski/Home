# Date And Time Functions

## Bugs

EF6 DateTime math is a disaster if your database uses T-SQL `datetime` data type.

1. SQL Server `datetime` data type only supports [~3.33 ms of accuracy](https://stackoverflow.com/questions/41668677/linq-to-entities-compare-datetime-with-milliseconds-precision#comment70537602_41668677), because of [Rounding of datetime Fractional Second Precision](https://docs.microsoft.com/en-us/sql/t-sql/data-types/datetime-transact-sql?view=sql-server-ver15#rounding-of-datetime-fractional-second-precision).
    1. What this means in practice is that if you write an integration test in C#, using a framework like Effort, the following code will be implicitly coerced on save because it can't be represented as a `DateTime` value:
    ```c#
    var cutOffTime = new TimeSpan(hours: 16, minutes: 30, seconds: 0);
    entity.PublishedDateTime = DateTime.Today.Add(cutOffTime.Subtract(TimeSpan.FromTicks(1)));
    Repository.Save(entity);
    Repository.GetAllPublishedTodayAfter(cutOffTime);
    ```
2. [Queries involving `DATETIME` behave differently on SQL Server 2014 and 2016](https://github.com/dotnet/ef6/issues/325):
    > Here's the breaking changes list provided by Microsoft:
    > 
    > https://docs.microsoft.com/en-us/sql/database-engine/breaking-changes-to-database-engine-features-in-sql-server-2016
    > 
    > In that we read the following with respect to the `DATETIME` and `DATETIME2` types:
    > 
    > > Under database compatibility level 130, implicit conversions from datetime to datetime2 data types show improved accuracy by accounting for the fractional milliseconds, resulting in different converted values. Use explicit casting to datetime2 datatype whenever a mixed comparison scenario between `datetime` and `datetime2` datatypes exists.
    See also the following KB4010261: [SQL Server and Azure SQL Database improvements in handling some data types and uncommon operations](https://support.microsoft.com/en-us/help/4010261/sql-server-and-azure-sql-database-improvements-in-handling-data-types)
3. [values on a .NET DateTime are truncated when stored in a SQL Server DATETIME column, regardless of the database compatibility level](https://github.com/dotnet/ef6/issues/49#issuecomment-265885625):
    > Note that values on a .NET DateTime are truncated when stored in a SQL Server DATETIME column, regardless of the database compatibility level.
    Diego then goes on to explain database compatibility level 130 implicit conversions.
4. Where this gets even trickier is when you write a LINQ query that filters by DateTime values:
    1. Rounding error introduced by .NET DateTime truncated when stored in a SQL Server DATETIME column
    2. Rounding error introduced by database compatibility level 130
    3. Rounding error when compared stored DATETIME column to a .NET DateTime object due to error introduced by database compatibility level 130
5. Microsoft considered a workaround, but it only works if your whole database uses columns of type `DATETIME` and not `DATETIME2`.  You cannot mix the two column types.
    
## Pre-EF6 (EntityFunctions)
1. [Date and Time Canonical Functions](https://docs.microsoft.com/en-us/previous-versions/dotnet/netframework-4.0/bb738563(v=vs.100)?redirectedfrom=MSDN)
2. [How to: Call Canonical Functions](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/ef/language-reference/how-to-call-canonical-functions?redirectedfrom=MSDN)

## EF6 (DbFunctions)

As the documentation states [EntityFunctions](http://msdn.microsoft.com/en-us/library/system.data.objects.entityfunctions.aspx)

> Provides common language runtime (CLR) methods that expose conceptual model canonical functions in LINQ to Entities queries. For information about canonical functions, see Canonical Functions (Entity SQL).

where [Canonical functions](http://msdn.microsoft.com/en-us/library/bb738626.aspx)

> are supported by all data providers, and can be used by all querying technologies. Canonical functions cannot be extended by a provider. These canonical functions will be translated to the corresponding data source functionality for the provider. This allows for function invocations expressed in a common form across data sources.

Whereas [SQLFunctions](http://msdn.microsoft.com/en-us/library/system.data.objects.sqlclient.sqlfunctions.aspx)

> Provides common language runtime (CLR) methods that call functions in the database in LINQ to Entities queries.

Therefore although both sets of functions are translated into native SQL, SQLFunctions are SQL Server specific, whereas EntityFunctions aren't.

# Run-time Exceptions

1. The navigation property '' has been configured with conflicting multiplicities.
    - This can happen because `.Map(s => s.MapKey("CaseSensitiveColumnName");` due to the fact EF uses CLR properties which are case sensitive.
    - See: https://stackoverflow.com/questions/32224102/entity-framework-varchar-foreign-key-case-insensitive

2. System.Data.Entity.Infrastructure.DbUpdateException
Entities in 'YourDbContext.ChildEntity' participate in the 'ParentEntity_ChildEntityPropertyNameOnParentEntity' relationship. 0 related 'ParentEntity_ChildEntityPropertyNameOnParentEntity_Source' were found. 1 'ParentEntity_ChildEntityPropertyNameOnParentEntity_Source' is expected.
    - See: https://stackoverflow.com/questions/24733689/entities-in-y-participate-in-the-fk-y-x-relationship-0-related-x-were-fou
    - This can happen when you're using AutoFixture to create an object graph and don't want to initialize a circular reference.
    - The solution is to create the test instances of the parent entity.
    - Alternatively, you can use LazyEntityGraph to allow circular references.

3. System.Data.Entity.Infrastructure.DbUpdateException
Entities in 'YourDbContext.ChildEntity' participate in the 'ChildEntity_ChildEntityNavigationPropertyName' relationship. 0 related 'ChildEntity_ChildEntityNavigationPropertyName_Target' were found. 1 'ChildEntity_ChildEntityNavigationPropertyName_Target' is expected.
    - This can happen when the table name of one of the entities is misspelled, or the primary key is wrong.
    - This can happen when you'reusing AutoFixture to create an object graph and don't want to initialize a circular reference.
    - The solution is to create the test instances of the parent entity on the child.
    - However, if didn't `.Map(p => p.MapKey("YourTableForeignKeyName")` then you will get a different error message:
        ```
        System.Data.Entity.Infrastructure.DbUpdateException
        An error occurred while saving entities that do not expose foreign key properties for their relationships. The EntityEntries property will return null because a single entity cannot be identified as the source of the exception. Handling of exceptions while saving can be made easier by exposing foreign key properties in your entity types. See the InnerException for details.
            at System.Data.Entity.Internal.InternalContext.SaveChanges()
        ```
        and the innermost exception will be:
        ```
        System.Data.SqlClient.SqlException
        Invalid column name 'ChildEntityNavigationPropertyName_Id'.
        Invalid column name 'NavigationPropertyTypeName_Id'.
            at System.Data.SqlClient.SqlConnection.OnError(SqlException exception, Boolean breakConnection, Action`1 wrapCloseInAction)
        ```
        The solution here is to go from code that looks like the following:
        ```c#
        HasRequired(x => x.NavigationPropertyName)
          .WithMany();
        ```
        to this:
        ```c#
          .Map(m => m.MapKey("YourNavigationPropertysKeyColumnNameInTheDatabase")
        ```
        HOWEVER, you might then get a DIFFERENT error IF you only mapped one side of the entity relationship AND you mapped the other side's primary key to something other than the CLR Property Name (case-sensitive)!  The following error is what you'll approximately see:
        
        The ONLY workaround in this situation is to map both ends of the relationship, unfortunately.
