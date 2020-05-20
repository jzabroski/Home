Niels Kunel devised a scheme for eager loading entitis in NHibernate.

Google Groups post: https://groups.google.com/forum/#!msg/nhibernate-development/S-w5R_j1SKQ/w48a5w9_MjYJ

> I like the power in making general expressions as:
> "I want to show these companies in my list, and for all of them I need these relations for what I'm going to show. Please give me them as fast as possible, but I don't really care how"
> 
> ```c#
> _session.QueryOver<Company>().Skip(20).Take(20).OrderBy(x=>x.Name).Asc)
>                 .EagerFetchMany(x => x.PushReportInfos)
>                 .EagerFetch(x => x.AgreementStatus)                
>                 .EagerFetchMany(x => x.SecurityTokens)
>                 .EagerFetchMany(x => x.NaceEntries)
>                 .EagerFetchMany(x => x.NaceEntries.First().NaceEntry)
>                 .Where "some really complicated stuff with EXISTS and stuff"
> ```
> 
> You can get that with subselects too, but in that case "some really complicated stuff" will be repeated for each sub select.
> In my approach filtering is only done once, and the database engine simply joins the tables on the resulting root entities
> 
> If you follow an approach whith a query for only the root entities and then get the rest by using some kind of " WHERE IN (root ids)" approach
> you're essentially doing the same as me, except that your need more code and you are sending a lot of ids to and fro.
> You are especially likely to get into trouble if you need nested relations or if you for some reason need to consider thousands of entities.

and, later, he wrote:

> All right. I underestimated the penalty from the increased size of the result set.
> When not paging subselects are faster than my idea unless you have some really complicated where clauses
> When paging batching is faster unless you have big pages.
> This means that it is not worth the effort.
> 
> Thanks for your input.
> 
> Now, subselects would be faster in all cases if the where clause could be reused. 
> 
> ```sql
> DECLARE @IDs TABLE (ID bigint primary key);
> INSERT @IDs select TOP 100 ID FROM [Person] WHERE {tricky stuff}
>
> SELECT {all fields} FROM [Person] WHERE ID IN (SELECT ID FROM @IDs)
> SELECT {all fields} FROM [Tag] tags0_ WHERE tags0_.Person_id in (select ID FROM @IDs)
> SELECT {all fields} FROM [Phonenumber] phonenumbe0_ WHERE phonenumbe0_.Person_id in (select ID FROM @IDs)
> ```
>
> What do you think is the best way to make queries like this?

Blog post: https://kuhnel.wordpress.com/2010/10/15/the-eager-fork-%E2%80%93-taming-cartesian-explosions-in-databases/

> As it can be seen, the multiplication between the number of Bs and Cs is now a simple addition instead.
> In this limited example it only reduces the number of rows from 11 to 10, but if each A had 30 Bs and 30
> Cs (as before) the 2,700 rows would be reduced to 180(!) which is actually less than the 183 entities
> needed to be extracted. More specifically, the upper bound for the row count in the result set is the
> number of As times the number of forks plus the number of each A’s Bs and Cs minus one for each (the first
> B or C are included in a row that would otherwise have NULLs in its place).

