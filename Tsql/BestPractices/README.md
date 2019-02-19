# Overview
Three things kill database performance, in roughly this order:
1. Hardware and SQL Server configuration
2. Maintenance
3. Programming

# Death by Hardware
1. Disks
    1. Slow
    2. Not enough
    3. Everything on same disk
    4. Shared with everyone else on a SAN
2. Memory
    1. Not enough
    2. Nothing left for OS

# Death by Default Settings
1. Auto growth
2. Fill factor
3. Parallelism
    1. Cost threshold
    2. Max degree
4. Only 1 tempdb file

# Death by Standard Edition
1. <128 GB RAM
2. Lack of online operations
3. Lack of compression
4. No Memory optimized techniques
    1. In-memory tables for OLTP
    2. Compiled procedures
    3. Columnstore index

# Death by sa account
* Changing the sa password or locking out sa user

# Death by bad indexes
1. Too many
    1. Inserts will be slow
2. Too few
    2. Reads will be slow
3. Unused
    1. Wrong column order
    2. Wrong sort order
4. Wrong clustered index
    1. Never used for seeks, only singleton lookups
5. Index hints, could work...
    1. ...For a while, but then what?

# Death by bad statistics
1. Big tables
    1. No auto update stats
2. Incrementing columns
    1. New values "out of range"
3. Understimation of query cost
    1. Bad execution plans
    2. Not enough memory allocated

# Death by datamodel
1. Datatypes
    1. Too big
    2. Wrong type
    3. Implicit conversion - UNION, and JOIN criteria
2. Big tables
    1. Too many columns
        1. Few records / page = many pages to read
    2. Too many records

# Death by correlated subqueries
http://www.sqlservice.se/sql-server-performance-death-by-correlated-subqueries/
1. Inner query depends on outer query
    1. RBAR - Row By Agonizing Row

# Death By SELECT *
1. Clustered index scan of index seek + key lookup depending on
    1. Number of records calculated from statistics

# Death By Entity Framework / nHibernate
http://www.sqlservice.se/sql-server-performance-death-by-entity-framework-nhibernate/
1. Too big datatypes?
2. Too denormalized?
3. Unreadable and inefficient code 

# Death by optional statements
1. OVER CLAUSE
    1. Range vs ROW
2. UNION (ALL)
    1. Distinct values or not

# Death by non-searchable argument
1. Index scans instead of seeks
    1. A lot more IO

# Death by scalar functions
1. No statistics = bad execution plan
2. "Hidden cost"

# Death by table variables
1. No statistics = bad execution plan
