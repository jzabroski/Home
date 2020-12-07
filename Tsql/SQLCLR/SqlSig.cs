using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Text.RegularExpressions;
using Microsoft.SqlServer.Server;

public partial class UserDefinedFunctions
{
    /// <summary>
    /// From: https://technet.microsoft.com/en-us/library/cc293616.aspx
    /// </summary>
    /// <param name="querystring"></param>
    /// <returns></returns>
    /// <remarks>
    /// The results you get back from SQL Trace will include raw text data for each query, including whichever actual arguments were used.
    /// To analyze the results further, the data should be loaded into a table in a database, then aggregated, for example, to find
    /// average duration or number of logical reads.
    /// 
    /// The problem is doing this aggregation successfully on the raw text data returned by the SQL Trace results. The actual arguments
    /// are good to know—they’re useful for reproducing performance issues—but when trying to figure out which queries should be tackled
    /// first we find that it’s better to aggregate the results by query “form.” For example, the following two queries are of the same
    /// form—they use the same table and columns, and only differ in the argument used for the WHERE clause—but because their text is
    /// different it would be impossible to group them as-is:
    /// 
    /// SELECT * 
    /// FROM SomeTable 
    /// WHERE SomeColumn = 1 
    /// ---
    /// SELECT * 
    /// FROM SomeTable 
    /// WHERE SomeColumn = 2
    /// 
    /// To help solve this problem, and reduce these queries to a common form that can be grouped, Itzik Ben-Gan provided a CLR UDF in
    /// <msl_i>Inside SQL Server 2005: T-SQL Querying</msl_i>, a slightly modified version of which—that also handles NULLs—follows:
    /// </remarks>
    [Microsoft.SqlServer.Server.SqlFunction(IsDeterministic = true)]
    public static SqlString sqlsig(SqlString querystring)
    {
        return (SqlString)Regex.Replace(
            querystring.Value,
            @"([\s, (=<> !](?![^\]]+[\]]))(?: (?: (?: (?: (?#	expression coming 
            )(?:([N]) ? (')(?:[^']| '') * ('))(?#	character
            ) | (?: 0x[\da - fA - F] *)(?#	binary
            ) | (?:[-+] ? (?: (?:[\d] *\.[\d]*|[\d]+)(?#	precise number
            ) (?:[eE]?[\d]*)))(?#	imprecise number
            )|(?:[~]?[-+]? (?:[\d]+))(?#	integer
            )|(?:[nN] [uU] [lL] [lL])(?#	null
            ))(?:[\s]?[\+\-\*\/\%\&\|\^][\s]?)?)+(?#	operator
            )))", 
            @"$1$2$3#$4", RegexOptions.Multiline | RegexOptions.IgnorePatternWhitespace);
    }
}
