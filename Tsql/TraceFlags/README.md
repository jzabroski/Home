# Trace Flags for Query Optimizer Behavior
[Enable plan-affecting SQL Server query optimizer behavior that can be controlled by different trace flags on a specific-query level](https://support.microsoft.com/en-us/help/2801413/enable-plan-affecting-sql-server-query-optimizer-behavior-that-can-be)

1. 2301 - Enable Modeling Extensions - see Tuning Options for High Performance Workloads below
2. 4137 - Enable trace flag 4137 to add the new logic for the cardinality estimation of AND predicates

# Tuning Options for High Performance Workloads
[Tuning options for SQL Server when running in high performance workloads](https://support.microsoft.com/en-us/help/920093/tuning-options-for-sql-server-when-running-in-high-performance-workloa])
1. Trace flag 2301: Enable advanced decision support optimizations
    > Trace flag 2301 enables advanced optimizations that are specific to decision support queries. This option applies to decision support processing of large data sets. 
    and
    > https://blogs.msdn.microsoft.com/ianjo/2006/04/24/query-processor-modelling-extensions-in-sql-server-2005-sp1/
