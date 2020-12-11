# EFCore 3 Interceptors

https://github.com/juunas11/managedidentity-filesharing/blob/master/Joonasw.ManagedIdentityFileSharingDemo/Data/ManagedIdentityConnectionInterceptor.cs

# Preparing Entity Framework Core for Static Analysis and Nullable Reference Types

https://www.infoq.com/articles/EF-Core-Nullable-Reference-Types/

# Opinions / Perspectives

1. Tim Corey on why he doesn't use Entity Framework
    - https://iamtimcorey.com/ask-tim-dont-use-entity-framework/
        1. > [Skill Acquistion] If you look at this simple getting started with EF example, you will see that you need to learn about DBSet, Data Context, Initializers, Seeds, Pluralization, and more. That’s before you take on the more complex example. That doesn’t seem simple to me. It seems like in order to avoid learning SQL, you ended up learning a whole new set of language tools. This isn’t reusing your skills, it is adding a new skill in C# for express purpose of avoiding learning a skill in SQL. Since you still need to know SQL, it doesn’t seem like a good trade-off.
        2. > Speed [...] Dapper wins hands down. [cf https://github.com/StackExchange/Dapper#performance]
        3. > Simplicity [...]  In four lines of [Dapper] code, I can get data out of a database and into a `List<T>`. Try doing that in EF.
            a. Note: this matches up with David Browne (Microsoft) and his description of how difficult it is to do basic logging with EFCore: https://blogs.msdn.microsoft.com/dbrowne/2017/09/22/simple-logging-for-ef-core/
        4. > [Maintainability ...] If I have a database developer on my team, they can work just in SQL. If I use EF, I would need to get a database developer who also knows C#. Either that or I don’t have a database developer on my team but then who optimizes the database? The C# developers?

## Perspectives

1. Ayende on NHibernate (for comparison)
    - https://ayende.com/blog/3983/nhibernate-unit-testing

# EFCore Gotchas

1. Forgetting to specify the storage type on an enum mapped to a column.
    ```
    System.InvalidCastException : Unable to cast object of type 'System.Int64' to type 'System.Int32'.
       at System.Data.SqlClient.SqlBuffer.get_Int32()
       at lambda_method(Closure , DbDataReader )
       at Microsoft.EntityFrameworkCore.Storage.Internal.TypedRelationalValueBufferFactory.Create(DbDataReader dataReader)
       at Microsoft.EntityFrameworkCore.Query.Internal.QueryingEnumerable`1.Enumerator.BufferlessMoveNext(DbContext _, Boolean buffer)
    ```
2. Mapping both ends of a one-to-one relationship is tricky, especially if you are mapping both sides.
    1. In the primary entity's EntityTypeBuilder, specify:
    ```csharp
    var builder = new EntityTypeBuilder<PrimaryEntity>();
    builder.HasOne(x => x.DependentEntity)
        .WithOne(x => x.PrimaryEntity)
        .IsRequired()
        .HasForeignKey<FollowOnWamInteraction>("PrimaryEntityId");
    ```
    2. In the dependent entity's EntityTypeBuilder, specify:
    ```csharp
    builder.HasOne(x => x.PrimaryEntity)
        .WithOne(x => x.DependentEntity); // you have to use the navigation syntax on the DependentEntity if you are mapping both sides
    ```
3. Corollary to previous item: If you completely forgot to configure the dependent entity on the PrimaryEntity's EntityTypeBuilder, you will get an identity insert exception in T-SQL.
    ```
    Microsoft.EntityFrameworkCore.DbUpdateException : An error occurred while updating the entries. See the inner exception for details.
    ---- System.Data.SqlClient.SqlException : Cannot insert the value NULL into column 'PrimatyEntityId', table 'UnitTest.dbo.DependentEntity'; column does not allow nulls. INSERT fails.
    The statement has been terminated.
       at Microsoft.EntityFrameworkCore.Update.ReaderModificationCommandBatch.Execute(IRelationalConnection connection)
       at Microsoft.EntityFrameworkCore.Update.Internal.BatchExecutor.Execute(DbContext _, ValueTuple`2 parameters)
    ```
4. `IDENTITY_INSERT is set to OFF` warnings may occur if you accidentally assigned a non-default (non-zero) value to an `Id` column.  For example, if you are configuring a SQL Server unit test's SUT with AutoFixture, make sure you specify `Without(y => y.Id);`
    a. This can happen with many-to-many mappings or one-to-one mappings or one-to-many mappings.  Anything, really.  For example, if you defined a one-to-one where you should have defined a one-to-many, then you might get this error.
    b. When defining a `HasOne(x => x.BadEntity).WithOne(x => x.OtherEntity).HasForeignKey("");` - if this is supposed to be a one-to-many, this will cause EFCore to generate a column for the `BadEntityId` insert statement.
    c. Check the order in which you register things in AutoFixture.
5. Cascade Delete doesn't work without help from the database ([Yes, REALLY!](https://docs.microsoft.com/en-us/ef/core/saving/cascade-delete))
    > The delete behavior configured in the EF Core model is only applied when the principal entity is deleted using EF Core and the dependent entities are loaded in memory (that is, for tracked dependents). A corresponding cascade behavior needs to be setup in the database to ensure data that is not being tracked by the context has the necessary action applied. If you use EF Core to create the database, this cascade behavior will be setup for you.

# EFCore Naming Conventions

https://www.meziantou.net/2017/06/26/entity-framework-core-naming-convention

# Things to Think about

[EntityFrameworkCore#15583 Make CLR members lookup for Metadata consistent](https://github.com/aspnet/EntityFrameworkCore/issues/15583): EFCore Metadata internally uses GetRuntimeProperties reflection extension method, which internally in turn calls GetProperties, which as Doug Bunting of the ASP.NET team points out, [guarantees no particular ordering](https://github.com/aspnet/Mvc/issues/1888).

# EFCore Query Generation Heuristics

1. https://github.com/aspnet/EntityFrameworkCore/issues/12098#issuecomment-440487200
    > A useful way to think about how EF Core decides whether to translate to one or multiple SQL queries is that it is **a heuristic that we apply to avoid the explosion of the cardinality of the root of the query that you are consuming**.

# EFCore Over Time

From: https://9-volt.github.io/bug-life/?repo=aspnet/EntityFrameworkCore


# EFCore Team Members

| Name | GitHub | Twitter | Blog | Notes |
| ---- | ------ | ------- | ---- | ----- |
| Diego Vega | [divega](https://github.com/divega) | [@divega](https://twitter.com/divega) | https://blogs.msdn.microsoft.com/diego/ | N/A |
| Arthur Vickers | [ajcvickers](https://github.com/ajcvickers) | [@ajcvickers](https://twitter.com/ajcvickers) | https://blog.oneunicorn.com/ | Program Manager |
| Brice Lambson | [bricelam](https://github.com/bricelam) | [@bricelambs](https://twitter.com/bricelambs) | https://www.bricelam.net/ | N/A |
| Rowan Miller | [rowanmiller](https://github.com/rowanmiller) | N/A | http://romiller.com/ | Former Program Manager of Entity Framework<br/> [Left team in 2017; still works on .NET](https://romiller.com/2017/03/06/im-leaving-the-ef-team/) <br />Appears to be [mind behind EF Code First Migrations](https://channel9.msdn.com/Blogs/EF/Migrations-Under-the-Hood) |
| Andriy Svyryd | [AndriySvyryd](https://github.com/AndriySvyryd) | [@andriysvyryd](https://twitter.com/andriysvyryd) | https://www.linkedin.com/in/andriy-svyryd-51364719/ | Entity Framework team member since November 2010. Has done work on model building and ensuring infinite recursion does not happen, and other sanity checks like [conflicting ForeignKeyAttributes](https://github.com/aspnet/EntityFrameworkCore/commit/3191ff3d1e4f1e14b2fd1a283af85ed6f60b3f4f). |
| Smit Patel | [smitpatel](https://github.com/smitpatel) | n/a | n/a |
| Scott Addie | [scottaddie](https://github.com/scottaddie) | n/a | Senior Content Developer for ASP.NET<br />Wrote the [ASP.NET Core 1.x to 2.0 migration](https://docs.microsoft.com/en-us/aspnet/core/migration/1x-to-2x/?view=aspnetcore-2.2) guide. |

Arthur has written to me on [how to write good exception messages](https://github.com/aspnet/EntityFrameworkCore/pull/15538).

# EF Stuff To Figure out / keep in mind

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

# EF Mapping Scenarios

1. Reference a TPH twice in the same entity: https://github.com/aspnet/EntityFrameworkCore/issues/5001
2. Using an Enum as a Discriminator https://github.com/aspnet/EntityFrameworkCore/issues/11454 - fixed, but test coverage lacking


# Question (work in progress)

In the following source code: https://github.com/aspnet/EntityFrameworkCore/blob/f0c5d1f09df25e60ac6f2ad8e46b1e285a386bac/test/EFCore.Tests/ChangeTracking/Internal/ShadowFkFixupTest.cs

It appears to latently be testing table-per-type mapping. I'm not @ajcvickers  so I don't know if this is an unaccounted for test case, or if the test cases latently cover both table-per-type mapping and table-per-hierarchy mapping.  However, since EFCore does not support any abstract class mappings, it stands to reason this could be missing test coverage and explain the problem I am running into.

I am trying to get table-per-hierarchy one-to-one mapping where I have a table-per-hierarchy and that hierarchy then maps one-to-one with a child table.

```csharp
public enum PersonType
{
  Nurse = 1,
  Doctor = 2
}
public class PersonBase
{
  public virtual long Id {get; set;}
  protected virtual PersonType PersonType {get; set;}
}

public class Doctor : PersonBase
{
  Doctor()
  {
    PersonType = PersonType.Doctor;
  }
  public virtual DoctorResidencyLocation ResidencyLocation {get; set;}
}

public class Nurse : PersonBase
{
  Nurse()
  {
    PersonType = PersonType.Nurse;
  }
  public virtual NurseResidencyLocation ResidencyLocation {get; set;}
}

public class ResidencyLocationBase
{
  public virtual PersonBase Person { get; set; }
  protected virtual PersonType PersonType {get; set;}
  public virtual string FacilityName {get; set;}
}

public class NurseResidencyLocation : ResidencyLocationBase
{
  public virtual 
}
```

Various issues I get when doing this:
- If you use HasPrincipalKey, it tries to insert an id and an error raised that IDENTITY_INSERT is set to off.
- If you use HasForeignKey, it tries to 

```csharp
var builder = new EntityTypeBuilder<NurseResidencyLocation>();
builder
  .HasBaseType(typeof(ResidenyLocationBase));

builder
  .HasOne(x => x.

```


