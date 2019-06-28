`AppDomain` has no strong isolation properties, as of .NET 2. An unhandled exception will bring down the entire application. Any library flaw can bring down an entire application. This demonstrates two major flaws with the way `AppDomain` objects work:

1. Failure in one `AppDomain` can cascade to another `AppDomain`
2. Lack of exception handling at `AppDomain` boundaries, which includes inability to handle exceptions raised from asynchronous calls (`OutOfMemoryException`, `StackOverflowException`)

To get around this design limitation, most people wrap `AppDomain` loading and unloading into reliable communication `Channel` objects, which approximate the features of Erlang.

Singularity, an OS written in C#, goes even further and removes `AppDomain` concept altogether, since an `AppDomain` is an overly general concept required to satisfy requirements of many environments. Instead, Singularity uses a typed language to enforce memory safety and runs every "software isolated process" (SIP) in the kernel's ring 0 memory, bypassing the hardware's memory protection and also thereby avoiding the memory overhead associated with memory rings as a protection mechanism. SIPs are basically AppDomain objects done right, and are very similar to Channels in the Inferno OS created by Rob Pike et al in the 1980s at Bell Labs.
