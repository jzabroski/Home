# Overview

What follows are some issues we submitted to the Entity Framework CodePlex repository back in 2011-2013 time frame.

# Issue 826: Projection not working with null check

I would use AutoMapper to make a projection using the extension method Project.To<TDestination>.

With the expression parser of the current version of Entity Framework is not possible to write this:
  
```c#
.Select(
    customer =>
    new CustomerDto
        {
            Id = customer.Id,
            FirstName = customer.FirstName,
            Address =
                            (customer.Address != null) ?
                                new AddressDto { Street = customer.Address.Street } :
                                null
        })
```
  
I obtain the error:
System.NotSupportedException: Unable to create a null constant value of type 'AddressDto'. Only entity types, enumeration types or primitive types are supported in this context.

# Issue 2196: Projection With Null Check Causing Too Many Joins


I am attempting to use Projection with Null Check (Added in regards to https://entityframework.codeplex.com/workitem/826)

Expanding upon the example given in the issue, adding multiple properties to the address DTO object gives the following select:

```c#
.Select(
    customer =>
    new CustomerDto
        {
            Id = customer.Id,
            FirstName = customer.FirstName,
            Address =
                            (customer.Address != null) ?
                                new AddressDto { 
                                     AddressLine1 = customer.Address.AddressLine1,
                                     AddressLine2= customer.Address.AddressLine2,
                                     City= customer.Address.City,
                                     State = customer.Address.State,
                                     Zip = customer.Address.Zip } :
                                null
        })
```

This works fine and generates a query with a single join on the addresses table.

If we assume for the sake of this post that there is another navigation property on customer, called Location,
that you first have to navigate through to get to Address, the query now looks like:

```c#
.Select(
    customer =>
    new CustomerDto
        {
            Id = customer.Id,
            FirstName = customer.FirstName,
            Address =
                            (customer.Address != null) ?
                                new AddressDto { 
                                     AddressLine1 = customer.Location.Address.AddressLine1,
                                     AddressLine2= customer.Location.Address.AddressLine2,
                                     City= customer.Location.Address.City,
                                     State = customer.Location.Address.State,
                                     Zip = customer.Location.Address.Zip } :
                                null
        })
```

This is generating a query with a LEFT OUTER JOIN for each property on the AddressDto object. Each join only pulls back a single property from the Address table.

So, instead of having a select from the customers table with one left outer join to the Locations table and one left outer join to the Address table, we instead get a query with a single left outer join to the Locations table and 5 left outer joins to the Address table, one for each property in the DTO.
  
  
# Issue 2397: 
  

Hi,

A problem that was present in 6.0 and was then fixed in 6.1 is now back in 6.1.1

I have a relationship between 2 objects (one-many) with required on the "one side".

When querying on that, EF5 and EF 6.1 produce the correct inner join. However, EF 6.0 and EF 6.1.1 produce a wrong LEFT JOIN causing my query to run in about 1 minute instead of some milliseconds.

In the anonimized examples below the related entities are "TableO" and "TableOr" where 1 "TableO" -> Many "TableOr"

Example of the wrong query (anonimized):

```sql
DECLARE @p__linq__0 VARCHAR(8000)

SET @p__linq__0 = '16311206'


SELECT [Extent1].[Id] AS [Id]
FROM [TableB] AS [Extent1]
INNER JOIN [TableS] AS [Extent2] ON [Extent1].[IdS] = [Extent2].[Id]
WHERE ( [Extent1].[Foo] IN ( CAST(1 AS TINYINT) ) )
AND ( [Extent2].[IsAnnullato] <> CAST(1 AS BIT) )
AND ( EXISTS ( SELECT 1 AS [C1]
FROM [TableBr] AS [Extent3]
LEFT OUTER JOIN [TableOr] AS [Extent4] ON [Extent3].[IdOr] = [Extent4].[Id]
LEFT OUTER JOIN [TableO] AS [Extent5] ON [Extent4].[IdO] = [Extent5].[Id]
WHERE ( [Extent1].[Id] = [Extent3].[IdB] )
AND ( ( [Extent5].[Numero] = @p__linq__0 )
OR ( [Extent5].[Numero] IS NULL
AND @p__linq__0 IS NULL
)
) ) )
AND ( [Extent1].[IdE] IN ( 4791 ) )

```

And the correct query (anonimized)

```sql
DECLARE @p__linq__0 VARCHAR(8000)
SET @p__linq__0 = '16721994'

SELECT [Extent1].[Id] AS [Id]
FROM [TableB] AS [Extent1]
INNER JOIN [TableS] AS [Extent2] ON [Extent1].[IdS] = [Extent2].[Id]
WHERE ( [Extent1].[Foo] IN ( CAST(1 AS TINYINT) ) )
AND ( [Extent2].[IsAnnullato] <> CAST(1 AS BIT) )
AND ( EXISTS ( SELECT 1 AS [C1]
FROM [TableBr] AS [Extent3]
LEFT OUTER JOIN [TableOr] AS [Extent4] ON [Extent3].[IdOr] = [Extent4].[Id]
INNER JOIN [TableO] AS [Extent5] ON [Extent4].[IdO] = [Extent5].[Id]
WHERE ( [Extent1].[Id] = [Extent3].[IdB] )
AND ( [Extent5].[Numero] = @p__linq__0 ) ) )
AND ( [Extent1].[IdE] IN ( 6464 ) )
```

You can clearly see the LEFT OUTER join in the first query and in the same spot the INNER JOIN in the second query.

This is causing a huge performance problem in many queries and I was forced to rollback to EF 6.1 until this is fixed.

What sounds strange is that this problem was already present and was already fixed, don't you have regression tests to prevent this from happening?

Thanks.
Comments: Thank you! Were you able to try the nightly build? This week we put-in a couple more fixes around join simplification/elimination and it would be great to know if this is working as expected.

  
# Issue 2413: Outer apply and duplicate left outer joins in query.

This has been reported by the user fsoikin as part of issue [2196](https://entityframework.codeplex.com/workitem/2196) but seems to be caused by a different problem.

## Model:

```c#
public class A
{
  public int Id { get; set; }
  public string Name { get; set; }
}

public class B
{
  public int Id { get; set; }
  public virtual ICollection<A> As { get; set; }
  public virtual C C { get; set; }
}

public class C
{
  public int Id { get; set; }
  public string X { get; set; }
  public int Y { get; set; }
}

public class Db : DbContext
{
  public DbSet<A> As { get; set; }
  public DbSet<B> Bs { get; set; }
  public DbSet<C> Cs { get; set; }

  public Db() : base( "server=.;database=xx;integrated security=true" ) {}
}

static class Program
{
  static void Main() {
    var db = new Db();
    var q = from c in db.Bs
            let i = c.As.FirstOrDefault().Id
            let j = db.As.FirstOrDefault( a => a.Id == i ).Name
            select new {
              c.Id,
              z = new { c.C.X, c.C.Y }
            };
    var qs = q.ToString();
}

```

## SQL query:

```sql
SELECT
[Project2].[Id] AS [Id],
[Extent4].[X] AS [X],
[Extent5].[Y] AS [Y]
FROM (SELECT
[Extent1].[Id] AS [Id],
[Extent1].[C_Id] AS [C_Id],
(SELECT TOP (1)
[Extent2].[Id] AS [Id]
FROM [dbo].[A] AS [Extent2]
WHERE [Extent1].[Id] = [Extent2].[B_Id]) AS [C1]
FROM [dbo].[B] AS [Extent1] ) AS [Project2]
OUTER APPLY (SELECT TOP (1) [Extent3].[Id] AS [Id]
FROM [dbo].[A] AS [Extent3]
WHERE [Extent3].[Id] = [Project2].[C1] ) AS [Limit2]
LEFT OUTER JOIN [dbo].[C] AS [Extent4] ON [Project2].[C_Id] = [Extent4].[Id]
LEFT OUTER JOIN [dbo].[C] AS [Extent5] ON [Project2].[C_Id] = [Extent5].[Id]
```

## Workarounds:

```c#
var q = from b in db.Bs
        let i = b.As.FirstOrDefault().Id
        let j = db.As.FirstOrDefault( a => a.Id == i ).Name
        join c in db.Cs on b.C.Id equals c.Id
        select new {
          b.Id,
          z = new { c.X, c.Y }
        };
```

or

```c#
var q = from c in db.Bs
        let i = c.As.FirstOrDefault().Id
        let j = db.As.FirstOrDefault(a => a.Id == i).Name
        let k = c.C
        select new
        {
          c.Id,
          z = new {k.X, k.Y}
        };
```
  
Comments: The workarounds solve the join duplication issue but outer apply remains.

