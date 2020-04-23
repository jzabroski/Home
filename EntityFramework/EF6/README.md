# Date And Time Functions

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
