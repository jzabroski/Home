# Date And Time Functions

## Overview

* Avoid `DATETIME` where possible; use `DATETIME2(3)` instead.
* When converting from `DATETIME` to `DATETIME2`:
    * add a new column and copy the data in that column.
    * drop the old column.
    * rename the new column to the old column's name.
* In brownfield software development, use the following query to report on distribution of column data types:
    ```sql
    SELECT isc.DATA_TYPE, COUNT(*)
    FROM INFORMATION_SCHEMA.COLUMNS isc
    WHERE isc.DATA_TYPE IN ('datetime', 'date', 'datetime2', 'datetimeoffset', 'time')
    GROUP BY isc.DATA_TYPE
    ```

## Differences Between DATETIME and DATETIME2

See [Iman's summary on StackOverflow](https://stackoverflow.com/a/12364243/1040437)

> * Syntax
>     * datetime2[(fractional seconds precision=> Look Below Storage Size)]
> 
> * Precision, scale
>     * 0 to 7 digits, with an accuracy of 100ns.
>     * The default precision is 7 digits.
> * Storage Size
>     * 6 bytes for precision less than 3;
>     * 7 bytes for precision 3 and 4.
>     * All other precision *require 8 bytes*.
> * `DateTime2(3)` have the same number of digits as DateTime but uses 7 bytes of storage instead of 8 byte (SQLHINTS- `DateTime` Vs `DateTime2`)
> Find more on [datetime2 (Transact-SQL) - SQL Server 
 Microsoft Docs](https://docs.microsoft.com/en-us/sql/t-sql/data-types/datetime2-transact-sql?redirectedfrom=MSDN&view=sql-server-ver15)

In general, if you want to use EF6 with a legacy database that has `DATETIME` column types, you're best off converting all those column types to `DATETIME2`, due to various rounding/truncation issues round-tripping `DATETIME`.  In particular, you can use `DATETIME2(3)` if all you need is milliseconds-level precision, and you can avoid the following rounding error:

### Example of T-SQL `DATETIME` Rounding Error
```sql
SELECT CAST('5/5/2020 12:30:59.129' AS DATETIME)

SELECT CAST('5/5/2020 12:30:59.129' AS DATETIME2(3))
```

## Bugs

EF6 DateTime math is a disaster if your database uses T-SQL `datetime` data type.

1. SQL Server `datetime` data type only supports [~3.33 ms of accuracy](https://stackoverflow.com/questions/41668677/linq-to-entities-compare-datetime-with-milliseconds-precision#comment70537602_41668677), because of [Rounding of datetime Fractional Second Precision](https://docs.microsoft.com/en-us/sql/t-sql/data-types/datetime-transact-sql?view=sql-server-ver15#rounding-of-datetime-fractional-second-precision).
    1. What this means in practice is that if you write an integration test in C#, using a framework like Effort, the following code will be implicitly coerced on save because it can't be represented as a `DateTime` value:
    ```c#
    var cutOffTime = new TimeSpan(hours: 16, minutes: 30, seconds: 0);
    entity.PublishedDateTime = DateTime.Today.Add(cutOffTime.Subtract(TimeSpan.FromTicks(1)));
    Repository.Save(entity);
    Repository.GetAllPublishedTodayAfter(cutOffTime);
    ```
2. [Queries involving `DATETIME` behave differently on SQL Server 2014 and 2016](https://github.com/dotnet/ef6/issues/325):
    > Here's the breaking changes list provided by Microsoft:
    > 
    > https://docs.microsoft.com/en-us/sql/database-engine/breaking-changes-to-database-engine-features-in-sql-server-2016
    > 
    > In that we read the following with respect to the `DATETIME` and `DATETIME2` types:
    > 
    > > Under database compatibility level 130, implicit conversions from datetime to datetime2 data types show improved accuracy by accounting for the fractional milliseconds, resulting in different converted values. Use explicit casting to datetime2 datatype whenever a mixed comparison scenario between `datetime` and `datetime2` datatypes exists.
    See also the following KB4010261: [SQL Server and Azure SQL Database improvements in handling some data types and uncommon operations](https://support.microsoft.com/en-us/help/4010261/sql-server-and-azure-sql-database-improvements-in-handling-data-types)
3. [values on a .NET DateTime are truncated when stored in a SQL Server DATETIME column, regardless of the database compatibility level](https://github.com/dotnet/ef6/issues/49#issuecomment-265885625):
    > Note that values on a .NET DateTime are truncated when stored in a SQL Server DATETIME column, regardless of the database compatibility level.
    Diego then goes on to explain database compatibility level 130 implicit conversions.
4. Where this gets even trickier is when you write a LINQ query that filters by DateTime values:
    1. Rounding error introduced by .NET DateTime truncated when stored in a SQL Server DATETIME column
    2. Rounding error introduced by database compatibility level 130
    3. Rounding error when compared stored DATETIME column to a .NET DateTime object due to error introduced by database compatibility level 130. See: https://github.com/dotnet/ef6/issues/578 - EF6 assumes .NET DateTime datatype maps to DateTime2 on SQL Server 2008 or Greater.
5. Microsoft considered a [workaround by Microsoft engineer Andrew Vickers](https://github.com/dotnet/ef6/pull/1147#issue-307843286) based on a [user @stasones contribution](https://github.com/dotnet/ef6/issues/578#issuecomment-435438457), but it only works if your whole database uses columns of type `DATETIME` and not `DATETIME2`.  You cannot mix the two column types.   Thus, Microsoft [decided not to accept the PR](https://github.com/dotnet/ef6/pull/1147#pullrequestreview-276892291), and instead document the workaround (the documentation task is still not done).  Another user, @dbrownems, used a more advanced workaround that [uses sp_describe_undeclared_parameters to infer the correct data type, whether it be datetime, datetime2 or date](https://github.com/dotnet/ef6/issues/578#issuecomment-482901998).
    @stasones solution - requires db be all `DATETIME` or all `DATETIME2`
    ```c#
    /// <summary>
    /// DateTimeInterceptor fixes the incorrect behavior of Entity Framework library when for datetime columns it's generating datetime2(7) parameters 
    /// when using SQL Server 2016 and greater.
    /// Because of that, there were date comparison issues.
    /// Links:
    /// https://github.com/aspnet/EntityFramework6/issues/49
    /// https://github.com/aspnet/EntityFramework6/issues/578
    /// Notes:
    /// Disable it if:
    /// 1) Database DateTime types will be migrating to DateTime2
    /// 2) Entity Framework team will fix the problem in a future version
    /// </summary>
    public class DateTimeInterceptor : IDbCommandInterceptor
    {
        public void ReaderExecuting(DbCommand command, DbCommandInterceptionContext<DbDataReader> interceptionContext)
        {
            ChangeDateTime2ToDateTime(command);
        }

        public void NonQueryExecuting(DbCommand command, DbCommandInterceptionContext<int> interceptionContext)
        {
        }

        public void NonQueryExecuted(DbCommand command, DbCommandInterceptionContext<int> interceptionContext)
        {
        }

        public void ReaderExecuted(DbCommand command, DbCommandInterceptionContext<DbDataReader> interceptionContext)
        {
        }

        public void ScalarExecuting(DbCommand command, DbCommandInterceptionContext<object> interceptionContext)
        {
        }

        public void ScalarExecuted(DbCommand command, DbCommandInterceptionContext<object> interceptionContext)
        {
        }

        private static void ChangeDateTime2ToDateTime(DbCommand command)
        {
            command.Parameters
                .OfType<SqlParameter>()
                .Where(p => p.SqlDbType == SqlDbType.DateTime2)
                .Where(p => p.Value != DBNull.Value)
                .Where(p => p.Value is DateTime)
                .Where(p => p.Value as DateTime? != DateTime.MinValue)
                .ToList()
                .ForEach(p => p.SqlDbType = SqlDbType.DateTime);
        }
    }
    ```
    @dbrownems solution : uses sp_describe_undeclared_parameters to infer the correct data type, whether it be datetime, datetime2 or date
    ```c#
    public class DateTimeParameterFixer : IDbCommandInterceptor
    {
        public void ReaderExecuting(DbCommand command, DbCommandInterceptionContext<DbDataReader> interceptionContext)
        {
            var dbContexts = interceptionContext.DbContexts.ToList();

            if (dbContexts.Count == 1)
            {
                FixDatetimeParameters(dbContexts[0], command);
            }

        }

        public void NonQueryExecuting(DbCommand command, DbCommandInterceptionContext<int> interceptionContext)
        {
        }

        public void NonQueryExecuted(DbCommand command, DbCommandInterceptionContext<int> interceptionContext)
        {
        }

        public void ReaderExecuted(DbCommand command, DbCommandInterceptionContext<DbDataReader> interceptionContext)
        {
        }

        public void ScalarExecuting(DbCommand command, DbCommandInterceptionContext<object> interceptionContext)
        {
        }

        public void ScalarExecuted(DbCommand command, DbCommandInterceptionContext<object> interceptionContext)
        {
        }

        private class SuggestedParameterType
        {
            public int parameter_ordinal { get; set; }
            public string name { get; set; }
            public int suggested_system_type_id { get; set; }
            public string suggested_system_type_name { get; set; }
            public Int16 suggested_max_length { get; set; }
            public byte suggested_precision { get; set; }
            public byte suggested_scale { get; set; }

        }

        private static ConcurrentDictionary<string, List<SuggestedParameterType>> batchCache = new ConcurrentDictionary<string, List<SuggestedParameterType>>();

        enum SqlTypeId
        {
            date = 40,
            datetime = 61,
            datetime2 = 42,
        }

        private static List<SuggestedParameterType> GetSuggestedParameterTypes(DbContext db, string batch, int parameterCount)
        {
            if (parameterCount == 0)
            {
                return new List<SuggestedParameterType>();
            }
            var con = (SqlConnection)db.Database.Connection;
            var conState = con.State;

            if (conState != ConnectionState.Open)
            {
                db.Database.Connection.Open();
            }
            var results = batchCache.GetOrAdd(batch, (sqlBatch) =>
            {
                var pBatch = new SqlParameter("@batch", SqlDbType.NVarChar, -1);
                pBatch.Value = batch;

                var rd = new List<SuggestedParameterType>();
                var cmd = new SqlCommand("exec sp_describe_undeclared_parameters @batch; ", con);
                cmd.Transaction = (SqlTransaction)db.Database.CurrentTransaction?.UnderlyingTransaction;

                cmd.Parameters.Add(pBatch);

                //sp_describe_undeclared_parameters does not support batches that contain multiple instances of the same parameter
                //
                //to workaround a common cause loop and transform on error expressions like:
                //
                // WHERE ([Extent1].[Date_Modified] = @p__linq__0) OR (([Extent1].[Date_Modified] IS NULL) AND (@p__linq__0 IS NULL))'
                //into
                // WHERE ([Extent1].[Date_Modified] = @p__linq__0) OR (([Extent1].[Date_Modified] IS NULL) AND (1=1))'
                // 
                // this works because the @param is null expression is irrelevant to the parameter type discovery.
                while (true)
                {
                    try
                    {
                        using (var rdr = cmd.ExecuteReader())
                        {
                            while (rdr.Read())
                            {
                                var sp = new SuggestedParameterType()
                                {
                                    //https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-describe-undeclared-parameters-transact-sql
                                    parameter_ordinal = rdr.GetInt32(0),
                                    name = rdr.GetString(1),
                                    suggested_system_type_id = rdr.GetInt32(2),
                                    suggested_system_type_name = rdr.GetString(3),
                                    suggested_max_length = rdr.GetInt16(4),
                                    suggested_precision = rdr.GetByte(5),
                                    suggested_scale = rdr.GetByte(6),
                                };


                                if (sp.suggested_system_type_id == (int)SqlTypeId.date || sp.suggested_system_type_id == (int)SqlTypeId.datetime2 || sp.suggested_system_type_id == (int)SqlTypeId.datetime)
                                {
                                    if (!sp.name.EndsWith("IgNoRe"))
                                    {
                                      rd.Add(sp);
                                    }
                                }
                            }
                            break;
                        }
                    }
                    catch (SqlException ex) when (ex.Errors[0].Number == 11508)
                    {
                        //Msg 11508, Level 16, State 1, Line 14
                        //The undeclared parameter '@p__linq__0' is used more than once in the batch being analyzed.
                        var paramName = System.Text.RegularExpressions.Regex.Match(ex.Errors[0].Message, "The undeclared parameter '(?<paramName>.*)' is used more than once in the batch being analyzed.").Groups["paramName"].Value;

                        string sql = (string)pBatch.Value;
                        if (sql.Contains($"{paramName} IS NULL"))
                        {
                            sql = sql.Replace($"{paramName} IS NULL", "1=1");
                            pBatch.Value = sql;
                            continue;
                        }
                        else
                        {
                            throw;
                        }
                       
                    }
                
                }
                return rd;


            });

            if (conState == ConnectionState.Closed)
            {
                con.Close();
            }
            return results;

        }

        private static void FixDatetimeParameters(DbContext db, DbCommand command)
        {
            if (!command.Parameters.OfType<SqlParameter>().Any(p => p.SqlDbType == SqlDbType.DateTime2 || p.SqlDbType == SqlDbType.DateTime))
            {
                return;
            }
            var suggestions = GetSuggestedParameterTypes(db, command.CommandText, command.Parameters.Count);

            if (suggestions.Count == 0)
            {
                return;
            }

            Dictionary<string, SqlParameter> paramLookup = new Dictionary<string, SqlParameter>();
            foreach (var param in command.Parameters.OfType<SqlParameter>())
            {
                if (param.ParameterName[0] == '@')
                {
                    paramLookup.Add(param.ParameterName, param);
                }
                else
                {
                    paramLookup.Add("@" + param.ParameterName, param);
                }
            }
            foreach (var suggestion in suggestions)
            {
                var param = paramLookup[suggestion.name];

                if (suggestion.suggested_system_type_id == (int)SqlTypeId.datetime2)
                {
                    param.SqlDbType = SqlDbType.DateTime2;
                    param.Scale = suggestion.suggested_scale;
                }
                else if (suggestion.suggested_system_type_id == (int)SqlTypeId.datetime)
                {
                    param.SqlDbType = SqlDbType.DateTime;
                }
                else if (suggestion.suggested_system_type_id == (int)SqlTypeId.date)
                {
                    param.SqlDbType = SqlDbType.Date;
                }

            }
        }
    ```

## Pre-EF6 (EntityFunctions)
1. [Date and Time Canonical Functions](https://docs.microsoft.com/en-us/previous-versions/dotnet/netframework-4.0/bb738563(v=vs.100)?redirectedfrom=MSDN)
2. [How to: Call Canonical Functions](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/ef/language-reference/how-to-call-canonical-functions?redirectedfrom=MSDN)

## EF6 (DbFunctions)

As the documentation states [EntityFunctions](http://msdn.microsoft.com/en-us/library/system.data.objects.entityfunctions.aspx)

> Provides common language runtime (CLR) methods that expose conceptual model canonical functions in LINQ to Entities queries. For information about canonical functions, see Canonical Functions (Entity SQL).

where [Canonical functions](http://msdn.microsoft.com/en-us/library/bb738626.aspx)

> are supported by all data providers, and can be used by all querying technologies. Canonical functions cannot be extended by a provider. These canonical functions will be translated to the corresponding data source functionality for the provider. This allows for function invocations expressed in a common form across data sources.

Whereas [SQLFunctions](http://msdn.microsoft.com/en-us/library/system.data.objects.sqlclient.sqlfunctions.aspx)

> Provides common language runtime (CLR) methods that call functions in the database in LINQ to Entities queries.

Therefore although both sets of functions are translated into native SQL, SQLFunctions are SQL Server specific, whereas EntityFunctions aren't.

# Run-time Exceptions

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
    - This can happen when the table name of one of the entities is misspelled, or the primary key is wrong.
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
