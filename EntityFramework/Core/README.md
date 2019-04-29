1. You can't map many-to-many without an intermediary class, and that class cannot be abstract.
    - See EFCore team member Arthur Vickers' blog post: https://blog.oneunicorn.com/2017/09/25/many-to-many-relationships-in-ef-core-2-0-part-1-the-basics/

2. https://github.com/aspnet/EntityFrameworkCore/issues/5377
    > System.InvalidOperationException: You are configuring a relationship between 'Offer' and 'Item' but have specified a foreign key on 'Offer'. The foreign key must be defined on a type that is part of the relationship.
3. Client-side eval https://itnext.io/entity-framework-core-client-side-evaluation-473077eee5d
    > Running this query with no change to the application will actually give you the following warning in the Debug Window.
    > 
    > > Microsoft.EntityFrameworkCore.Query:Warning: The LINQ expression ‘where (Compare([c].FirstName, “D”, Ordinal) > 0)’ could not be translated and will be evaluated locally.

# EF Fluent Mapping

If you only map from one side, it might work, but it could be the wrong side.

HasDiscriminator is finicky.  `HasDiscriminator<TEntity>(x => x.EnumId)` will blow up.  `HasDiscriminator(x => x.EnumId)` won't.
   
