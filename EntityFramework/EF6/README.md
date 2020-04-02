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
