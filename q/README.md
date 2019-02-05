# Learning Resources
[Cookbook/GettingStarted - Kx Wiki](http://code.kx.com/wiki/Cookbook/GettingStarted)
[Tutorials - Kx Wiki](http://code.kx.com/wiki/Tutorials)
[On Disk Queries - Kx Wiki](http://code.kx.com/wiki/On_Disk_Queries)
[Cookbook/Websocket - Kx Wiki](http://code.kx.com/wiki/Cookbook/Websocket)

## Beginners
[Thalesians Kdb](http://www.thalesians.com/finance/index.php/Knowledge_Base/Databases/Kdb)
[Reference - Kx Wiki](https://code.kx.com/wiki/Reference)
[Tutorials - Kx Wiki](http://code.kx.com/wiki/Tutorials)

## Intermediate
[QforMortals2/contents - Kx Wiki](http://code.kx.com/wiki/JB:QforMortals2/contents)

## Advanced
[First Derivatives plc  (Q for Gods lecture series)](http://www.firstderivatives.com/lecture_series.asp)
[Learning Q KDB+](https://eternallearningq.wordpress.com/q-kdb-tutorials/)

## YouTube
[enlist[q]'s YouTube Channel](https://www.youtube.com/channel/UCshbx8qp3QEXRYTfyMlkV6g)

## Lecture Series
[Learn q in Y Minutes](https://learnxinyminutes.com/docs/kdb+/)

## Garbage Collection tutorial
https://www.aquaq.co.uk/q/garbage-collection-kdb/

# Other

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

# make a time sequence of time intervals between two times
```q
15:00:00+00:00:30*til 10
```
Or more generically:
```q
q)f:{[st;en;i] st+i*til 1+`long$(en-st)%i}

q)f[15t;16t;00:00:30.000]

15:00:00.000 15:00:30.000 15:01:00.000 15:01:30.000 15:02:00.000 15:02:30.000..

q)f[.z.d;.z.d+10;1]

2016.02.04 2016.02.05 2016.02.06 2016.02.07 2016.02.08 2016.02.09 2016.02.10 ..
```
