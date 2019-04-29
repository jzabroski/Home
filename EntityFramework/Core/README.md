1. You can't map many-to-many without an intermediary class, and that class cannot be abstract.
    - See EFCore team member Arthur Vickers' blog post: https://blog.oneunicorn.com/2017/09/25/many-to-many-relationships-in-ef-core-2-0-part-1-the-basics/

2. https://github.com/aspnet/EntityFrameworkCore/issues/5377
    > System.InvalidOperationException: You are configuring a relationship between 'Offer' and 'Item' but have specified a foreign key on 'Offer'. The foreign key must be defined on a type that is part of the relationship.
