# Ayende on NHibernate (for comparison)

https://ayende.com/blog/3983/nhibernate-unit-testing

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
| Smit Patel | [smitpatel](https://github.com/smitpatel) | 

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

# Issue Work In Progress

We have a bunch of AutoFixture integration tests that automatically generate deep object graphs, and Microsoft.EntityFrameworkCore SaveChanges was blowing up on Discriminator field.  I am trying to figure out the exact problem today, and taking the code in `ShadowFkFixupTest.cs` as a starting point for trying to re-create the issue, but the code is incredibly terse and uses abbreviations I do not understand, hence why I created #15529 to decrypt some of the abbreviations and help improve the code.

I _do think_ that you will run into another issue I am running into, which is I can't get one-to-many child relations to work on TPH entities.  Consider the following object graph:

Here is the SQL schema for the domain model:

```
.--------------------------------.
|  Parent                        |
+--------------------------------+
| ParentID       : bigint        |
| Discriminator  : bigint        |
| GoodParentData : varchar       |
| BadParentData  : varchar       |
'--------------------------------'
                | 1
                |
                | 0..1
.--------------------------------.
|  Child                         |
+--------------------------------+
| ChildId        : bigint        |
| ParentId       : bigint        |
| Discriminator  : bigint        |
| GoodChildData  : varchar       |
| BadChildData   : varchar       |
'--------------------------------'                                                         
```

Here is the C# class diagram:

```
    .--------------------------------------------.     .----------------------------------------------.
    |  ParentBase <abstract>                     |     | ChildBase <abstract>                         |
    +--------------------------------------------+     +----------------------------------------------+
    | Id : long                                  |     | Id : long                                    |
    '--------------------------------------------'     '----------------------------------------------'
        |                                     |            |                                      |
       \|/                                   \|/          \|/                                    \|/
.-------------------------. .------------------------. .------------------------. .-----------------------.
| GoodParent              | | BadParent              | | GoodChild              | | BadChild              |
+-------------------------+ +------------------------+ +------------------------+ +-----------------------+
| Child : GoodChild       | | Child : BadChild       | | Parent : GoodParent    | | Parent : BadParent    |
| GoodParentData : string | | BadParentData : string | | GoodChildData : string | | BadChildData : string |
'-------------------------' '------------------------' '------------------------' '-----------------------'
```
