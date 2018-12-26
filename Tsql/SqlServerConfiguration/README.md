# What physical extent should you format for the hard drive?

https://www.sqlservercentral.com/Forums/1804884/64KB-disk-formatted-vs-4KB-disk-formatted

Random reads should be faster on 64kb extent

> "Having a small (default) Allocation Unit Size means there are many more times the number of blocks at the file system level that need to be managed by the operating system. For file systems that hold thousands or millions of small files, this is fine because there is a lot of space savings by having a smaller Allocation Unit in this scenario. But for a SQL Server database that consists of very few, very large files, having a much larger Allocation Unit is much more efficient from a file system, operating system management, and performance perspective."
> 
> "Virtualizing SQL Server with VMware: Doing IT Right" by Michael Corey, Jeff Szastak and Michael Webster
