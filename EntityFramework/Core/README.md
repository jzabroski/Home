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
