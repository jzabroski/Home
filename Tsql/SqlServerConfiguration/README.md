# What physical extent should you format for the hard drive?

https://www.sqlservercentral.com/Forums/1804884/64KB-disk-formatted-vs-4KB-disk-formatted

Random reads should be faster on 64kb extent

> "Having a small (default) Allocation Unit Size means there are many more times the number of blocks at the file system level that need to be managed by the operating system. For file systems that hold thousands or millions of small files, this is fine because there is a lot of space savings by having a smaller Allocation Unit in this scenario. But for a SQL Server database that consists of very few, very large files, having a much larger Allocation Unit is much more efficient from a file system, operating system management, and performance perspective."
> 
> "Virtualizing SQL Server with VMware: Doing IT Right" by Michael Corey, Jeff Szastak and Michael Webster


[Brent Ozar: How Big Are Your Log Writes? Spying on the SQL Server Transaction Log](https://www.brentozar.com/archive/2012/05/how-big-your-log-writes-spying-on-sql-server-transaction-log/)
> A widely published SQL Server configuration best practice is to format your log file drives with a 64KB allocation unit size. There are exceptions to this for certain storage subsystems— you should always check the documentation from your storage provider, and you can also run tests with tools like SQLIO to determine how you can get the best performance with your storage implementation. (Different SAN configurations and settings like RAID stripe size make a difference when it comes to performance with a given allocation unit configuration.)
