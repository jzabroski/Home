1. [Does Amazon Redshift support partitioning?](https://www.quora.com/Does-Amazon-Redshift-support-partitioning)
   > Distribution keys serve a similar purpose if you’re looking for query performance.
   > 
   > If you’re used to using partitioning for data loading (load to a new table then “switch” that into the main table),
   > Redshift supports `ALTER APPEND` which works the same way. [ALTER TABLE APPEND](http://docs.aws.amazon.com/redshift/latest/dg/r_ALTER_TABLE_APPEND.html)
2. [Quickly Filter Data in Amazon Redshift Using Interleaved Sorting](https://aws.amazon.com/blogs/aws/quickly-filter-data-in-amazon-redshift-using-interleaved-sorting/)
3. [https://aws.amazon.com/blogs/big-data/optimizing-for-star-schemas-and-interleaved-sorting-on-amazon-redshift/](http://blogs.aws.amazon.com/bigdata/post/Tx1WZP38ERPGK5K/Optimizing-for-Star-Schemas-and-Interleaved-Sorting-on-Amazon-Redshift)
