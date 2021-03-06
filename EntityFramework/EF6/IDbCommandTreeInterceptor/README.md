The original user story demonstrated by Rowan Miller at [TechEd North America 2014](http://channel9.msdn.com/Events/TechEd/NorthAmerica/2014/DEV-B417#fbid=) was to implement [SoftDeleteInterceptor](https://github.com/rowanmiller/Demo-TechEd2014/blob/master/FakeEstate.ListingManager/Models/EFHelpers/SoftDeleteInterceptor.cs), 
whereby a `DELETE` is transformed into an `UPDATE` of an `IsDeleted` property on the entity.

[Entity Framework 6.0 - Intercepting SQL produced by EF](https://www.skylinetechnologies.com/Blog/Skyline-Blog/December-2013/Entity-Framework-6-Intercepting-SQL-produced) by Dan Lorenz

> First, you need to create the Inteceptor class.  There are two interfaces that you can use: `IDbCommandTreeInterceptor` and `IDbCommandInterceptor`.  `IDbCommandTreeInterceptor` allows you to intercept the tree model that was created.  Currently, you can only modify the SELECT queries.  If EF creates a query that does not perform well, you can use this interceptor to modify the tree.  However, this will get cached, so the event will only fire the first time.  `IDbCommandInterceptor` allows you to manipulate the `DbCommand` object before and after Entity Framework makes the call to the database.  You have full access to everything on that command, including `CommandText` and `Parameters`.  You can log the SQL and the parameters.  You can modify the `CommandText` and/or the `Parameters` however you want.  Need to add SQL Server specific calls in the SQL being sent?  No problem!


The following StackOverflow answers use idential code:
1. [using IDbCommandTreeInterceptor for querying temporal tables](https://stackoverflow.com/a/56829230/1040437)
2. [Entity Framework not working with temporal table](https://stackoverflow.com/questions/40742142/entity-framework-not-working-with-temporal-table):


```c#
using System.Data.Entity.Infrastructure.Interception;
using System.Data.Entity.Core.Common.CommandTrees;
using System.Data.Entity.Core.Metadata.Edm;
using System.Collections.ObjectModel;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;

namespace Ubiquité.Clases
{

    /// <summary>
    /// Evita que EFF se haga cargo de ciertos campos que no debe tocar Ej: StartTime y EndTime
    ///     de las tablas versionadas o bien los row_version por ejemplo
    ///     https://stackoverflow.com/questions/40742142/entity-framework-not-working-with-temporal-table
    ///     https://stackoverflow.com/questions/44253965/insert-record-in-temporal-table-using-c-sharp-entity-framework
    ///     https://stackoverflow.com/questions/30987806/dbset-attachentity-vs-dbcontext-entryentity-state-entitystate-modified
    /// </summary>
    /// <remarks>
    /// "Cannot insert an explicit value into a GENERATED ALWAYS column in table 'xxx.dbo.xxxx'.
    /// Use INSERT with a column list to exclude the GENERATED ALWAYS column, or insert a DEFAULT
    /// into GENERATED ALWAYS column."
    /// </remarks>
    internal class TemporalTableCommandTreeInterceptor : IDbCommandTreeInterceptor
    {
        private static readonly List<string> _namesToIgnore = new List<string> { "StartTime", "EndTime" };

        public void TreeCreated(DbCommandTreeInterceptionContext interceptionContext)
        {
            if (interceptionContext.OriginalResult.DataSpace == DataSpace.SSpace)
            {
                var insertCommand = interceptionContext.Result as DbInsertCommandTree;
                if (insertCommand != null)
                {
                    var newSetClauses = GenerateSetClauses(insertCommand.SetClauses);

                    var newCommand = new DbInsertCommandTree(
                        insertCommand.MetadataWorkspace,
                        insertCommand.DataSpace,
                        insertCommand.Target,
                        newSetClauses,
                        insertCommand.Returning);

                    interceptionContext.Result = newCommand;
                }

                var updateCommand = interceptionContext.Result as DbUpdateCommandTree;
                if (updateCommand != null)
                {
                    var newSetClauses = GenerateSetClauses(updateCommand.SetClauses);

                    var newCommand = new DbUpdateCommandTree(
                        updateCommand.MetadataWorkspace,
                        updateCommand.DataSpace,
                        updateCommand.Target,
                        updateCommand.Predicate,
                        newSetClauses,
                        updateCommand.Returning);

                    interceptionContext.Result = newCommand;
                }
            }
        }

        private static ReadOnlyCollection<DbModificationClause> GenerateSetClauses(IList<DbModificationClause> modificationClauses)
        {
            var props = new List<DbModificationClause>(modificationClauses);
            props = props.Where(_ => !_namesToIgnore.Contains((((_ as DbSetClause)?.Property as DbPropertyExpression)?.Property as EdmProperty)?.Name)).ToList();

            var newSetClauses = new ReadOnlyCollection<DbModificationClause>(props);
            return newSetClauses;
        }
    }

    /// <summary>
    /// registra TemporalTableCommandTreeInterceptor con EFF
    /// </summary>
    public class MyDBConfiguration : DbConfiguration
    {
        public MyDBConfiguration()
        {
            DbInterception.Add(new TemporalTableCommandTreeInterceptor());
        }
    }
}
```
