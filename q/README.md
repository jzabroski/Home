1. [Introduction to K by Arthur Whitney](http://vector.org.uk/art10010830)

**Problem:** Incorporate new data into my database of splayed tables without downtime.

**Solution:** https://www.aquaq.co.uk/q/avoiding-end-of-day-halts-with-torq/

**Detailed Problem:**
My new idea is to have an in-memory database with the same schema to hold "todays"
data and do my queries on the unions of pairs of tables one from the today database
and one from the on-disk database. 

Overnight I would write a new on-disk database which incorporates the data from the 
today database (up to midnight). In the mean time I continue to serve queries using the 
today database and the old on-disk database.

When the new on-disk database is ready, the records from before midnight in the 
in memory database are deleted, and the new on-disk database replaces the old.

The problem I a worried about is that taking the union of my in-memory and on-disk
tables would produce an intermediate result at least as large as the on-disk table
which is entirely in memory.

Part of the problem is that some of the today records will need to replace equally keyed
records in the on-disk database, so the union is really an upsert, and the on-disk database
needs to have a key.

More generally, when you are using on-disk table to produce intermediate results,
how can you avoid having those intermediate results entirely in memory ?

Kdb query scaling https://code.kx.com/q/wp/kdb_query_scaling.pdf
