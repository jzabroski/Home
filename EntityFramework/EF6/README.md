1. The navigation property '' has been configured with conflicting multiplicities.
    - This can happen because `.Map(s => s.MapKey("CaseSensitiveColumnName");` due to the fact EF uses CLR properties which are case sensitive.
    - See: https://stackoverflow.com/questions/32224102/entity-framework-varchar-foreign-key-case-insensitive

2. System.Data.Entity.Infrastructure.DbUpdateException
Entities in 'YourDbContext.ChildEntity' participate in the 'ParentEntity_ChildEntityPropertyNameOnParentEntity' relationship. 0 related 'ParentEntity_ChildEntityPropertyNameOnParentEntity_Source' were found. 1 'ParentEntity_ChildEntityPropertyNameOnParentEntity_Source' is expected.
    - See: https://stackoverflow.com/questions/24733689/entities-in-y-participate-in-the-fk-y-x-relationship-0-related-x-were-fou
    - This can happen when you're using AutoFixture to create an object graph and don't want to initialize a circular reference.
    - The solution is to create the test instances of the parent entity.
    - Alternatively, you can use LazyEntityGraph.
