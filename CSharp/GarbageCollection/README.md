Taken from: https://redstone325.wordpress.com/2008/05/13/notes-on-the-clr-garbage-collector-%E8%BD%AC%E8%BD%BD/

A few days ago, some of us in my group were discussing about the GC mechanism used in the CLR. It was an interesting discussion, and like most discussions, inconclusive. So I decided to put (almost) everything interesting to know about the GC on paper. Some of the people who read this, particularly Vinod – he is sick of my long mails not converting into articles – suggested that I share this with a broader audience and put it on the blog.
While writing, I was actually vacillating – more than enough has been written about GC, so why write another piece? But then, I think no single article captures everything, and since there are so many anyway, why not another one?? 🙂 As far as I know, there is nothing new here – everything has already been said by the likes of Patrick Dussud, Brian Harry, Chris Brumme, Maoni Stephens, Rico Mariani, Jeff Richter – this is just a compilation, and not a very comprehensive one at that, esp. on the Best Practices, so I have included a Further Reading section. For whatever it is worth, here it is!!
1. The Problem Domain – Memory Management
    1. Applications composed of components / libraries written by different developers at different points in time
    2. These components have no idea of resources are allocated / released by each other – they are only aware of how they manage resources themselves
    3. The substrate needs to provide a common memory management infrastructure which would let these components work with each other
    4. The mechanism used should
        * Be optimal on memory utilization
        * Provide strong object locality to take get cache efficiency and take advantage of CPU Registers & Caches
        * Ensure code correctness
        * Minimize the burden on the developer
        * Support scenarios like Finalization, Weak References and Pinning

2. Memory Management – What are the Choices?

    1. Reference Counting
        1. Each component keeps a count of number of clients using it and destroys itself when the last client Releases it
            * Example: COM, Number of large-scale C++ projects
            * Depends on components and clients keeping a correct count, mistakes can lead to a memory leak (accumulation of unreferenced objects) or premature releasing
            * Difficult to resolve circular references
    2. Garbage Collection – Mark and Sweep
        * Example: C Runtime Heap
        * Initially, allocate objects on the heap sequentially
        * At some stage, mark the objects that are dead and can be removed
        * Free the dead object slots at some stage
            1. In C/C++ the programmer has to do it since the runtime can be misled about object size by type-casting, void pointers, etc.
            2. Environments like CLR where type safety is guaranteed are always aware of object size and can free memory on their own
        * Maintain a list of free slots (Free List)
        * On next allocation request traverse the list and give the smallest possible slot that can fulfill the memory allocation request
        * Advantage: Minimal house-keeping overhead (just one freelist)
        * Disadvantage: Every allocation request requires a walk thru the freelist, makes allocations slow
        * Disadvantage: Heap fragmentation – there may not be a single contiguous block to accommodate a request for a large block
    3. Garbage Collection – Copy and Collect
        * Keep two heaps
        * Allocate only from one heap
        * When collection is triggered on the heap, copy all alive objects to the second heap
        * Switch the roles of heaps
        * Advantage: Conceptual Simplicity
        * Disadvantage: Copy operation needs to be done for all objects
        * Disadvantage: Blocks a lot of memory unneccessarily
    4. Garbage Collection – Mark and Compact
        * Example: CLR, some JVM implementations
        * Same as Mark and Sweep except that as free space from dead objects is claimed, the alive objects are compacted together to leave a single contiguous block of free memory
        * Disadvantage: Compacting memory can be expensive for large objects
        * Advantage: Allocation requires just a pointer to keep track of the top of the heap, so it is lightning fast
        * Advantage: No heap fragmentation

3. What Happens in the CLR
    1. Marking, Sweeping and Compacting
        1. Large and Small Objects
            There are actually two GC heaps: one for large objects and another for small objects. Large objects are kept in a separate heap called the Large Object Heap (LOH) which is Mark and Swept since copying large objects causes extra overhead
            * The definition of large object used to be >= 20000 bytes in v1.0
            * It changed to >= 85,000 bytes in 1.1
            * It may change in future, so don’t make hard assumptions on the size
            Smaller objects are kept in multiple heaps which are compacted from time to time.
        2. Marking a heap (all GC heaps)
            * GC assumes that all heap is garbage.
            * It then starts building a graph of all live objects starting from the application’ roots.
            * Roots are references to live objects. They exist in:
               1. The call stack of a thread
               2. Static and global objects
               3. Freachable queue (see Finalization)
               4. Places like the CPU registers
            * The JIT compiler tracks the roots and gives a list to the GC
            * All objects that are reachable are considered alive, everything else is dead and can be collected
        3. Sweeping a heap (all GC Heaps)
            * Merge adjacent freed blocks of memory into one.
            * Maintain a FreeList of all space that is free.
            * Allocation would now need to walk the FreeList
        4. Compacting a heap (only the small object heaps)
            * Slide objects so that all alive objects get compacted into one contiguous block
            * Update references to each object so that they now point to new memory locations
            * Move the heap pointer (pointer to the next object location) to the top of the heap
            * Allocation would now happen at the heap pointer
            * Each allocation moves the pointer further up
            * LOH is only swept and never compacted
            * Small Object heaps are frequently swept and less frequently compacted
        
    2. Generational GC
        1. Memory Usage Observations
            Generational GC or ephemeral GC is an optimization based on the following observations:
            * Newer objects tend to live for a short duration
            * Older objects tend to live for longer durations
            * Newer objects have strong relationships with each other and frequently accessed around the same time
        2. The Three Generations
            The GC keeps small objects in three generations:
            * Gen 0: Newly created objects which have not seen a collection yet
            * Gen 1: Objects which have survived one collection
            * Gen 2: Objects that have survived two collections
            * Gen 0 and Gen 1 are also called ephemeral generations, and they always live together in a single segment called the ephemeral segment (see Segments later)
            * GC tries to fit Gen 0 in the L2 Cache of the CPU
        3. Collections by Generations
            * Every time Gen 0 heap crosses a threshold (called a “budget” – see allocation and collection below), a GC is triggered
            * Gen 0 is collected very frequently.
            * Frequency of Gen 0 collections > Gen 1 Collections > Gen 2 collections (Gen 1: Gen 2 being 10 : 1 is healthy)
            * Collection for Gen N collects all Gens < N, so
                1. A Gen 1 collection also causes a Gen 0 collection.
                2. A Gen 2 collection also causes a Gen 1 and Gen 0 collection. It also causes a LOH Collection. This is called a full collection
            * If memory pressure is high, GC is more aggressive in collection and Gen 1 and Gen 2 collections may happen more frequently.

        4. Generational GC Benefits
            * No need to compact a single gigantic heap – multiple smaller heaps of different sizes are compacted at different frequencies – this is faster
            * Objects which have a similar lifespan stay closer together. This improves object locality. Object locality helps improve perf with modern CPUs where proc speed >> memory speed
            * The time required in the Mark phase can be significantly reduced by ignoring the inner references of older generation objects
            * However, an older object may have been written to and may have hold a reference to a newer object
            * To track this, the GC maintains an internal structure called the “card table”
                1. Card Table consists of entries: 1 bit for 128 bytes of memory. This means one DWORD corresponds to 4k, which incidentally is the size of a page
                2. So you can think about the card table as an array of DWORDs with every entry referring to a page and further split into every bit tracking a 128 byte range
                3. Every time an object gets modified, the JIT emits code to write to the object as well as the card table
                    1. This is possible because of what is called the “Write barrier” – the JIT preventing a write directly
                    2. Another approach is to use the GetWriteWatch Win32 API that tells you what has changed
                4. To map an object to the address range, another internal look up dictionary like structure is used.
    3. Segments
        GC reserves memory in segments. A segment is a unit of reservation.
        1. Generations and Segments
            * To begin with, GC creates two segments – one for Gen 0 and Gen 1, and the other for LOH
            * Gen 0 and Gen 1 share a single segment throughout the lifecycle of the program. This is called the ephemeral segment.
            * Gen 2 may have zero or more segments of its own
            * LOH has one or more segments of its own
        2. Segment Size
            * As of CLR v2, each segment typically = 16 MB (but not fixed, dynamically tuned)
            * Each Heap Segment has a Reserved Size and a Committed Size. Committed <= Reserved
            * Initially reserve, commit on allocation on demand
        3. Heap Expansion and Contraction
            A heap expands or contracts by adding / deleting heap segments. A segment is allocated whenever there is a need for more memory. This can happen if
                1. Existing LOH segments cannot satisfy an object allocation request. A new LOH segment is created.
                2. Objects getting promoted from Gen 1 during a Mark Phase cannot be accommodated any more in the existing Gen 2 segments. A new Gen 2 segment is created.
            1. Segment Allocation
                * To allocate a new segment, GC calls VirtualAlloc.
                * If there is no free contiguous block in the heap large enough for a segment
                    1. Segment Allocation fails
                    2. The allocation request also fails
                    3. GC returns NULL to the Execution Engine (EE)
                    4. EE throws an OOM exception
            2. Segment Deletion
                A segment which is not in use, is deleted in a full collection and memory is returned to the OS
                * This can be prevented with a feature introduced with CLR 2.0 called VM Hoarding which can be turned on via hosting APIs
                * In fact with hosting, the CLR host can do pretty much anything. As an example, SQL Server may not want to report the memory to CLR in a transparent way to control its behavior, or fail allocations, or reserve / commit memory in advance, etc. There is a lot to memory control for a CLR host, but a full discussion of hosting is outside the scope of this article.
        4. Relationship between Heaps, Segments and Generations
            1. To a program, the CLR exposes a single contiguous heap
                * For MP machines, when Server GC is turned on, there is a full heap and a dedicated GC thread per CPU, but to the app, there is still only one heap across all CPUs (see GC Flavors later)
            2. Segments are units in which the GC internally reserves and commits virtual memory, so a heap consists of multiple segments
            3. Generations are object lifetime groupings and are used by the GC to trigger collections for small objects, so logically, they orthogonal to segments. Physically:
* Gen 0 and Gen 1 always live in the same segment called the ephemeral segment
* Gen 2 lives in zero or more segments
* LOH lives in one or more segments
3.4 Allocation and Collection
At a macro level, during allocation, depending on the object size:
* Small object (< 85000 bytes) – object gets created on ephemeral segment in Gen 0, – just move the Heap pointer forward
* Large object (>= 85000 bytes) – object gets created on LOH (no co-relation with Generations), so scan the FreeList for a large enough slot, or allocate a new LOH segment
3.4.1 Allocation Context
* As mentioned earlier, memory is not allocated upfront, memory is only reserved at a segment level
* For optimization, the Allocator doles out memory in 8 kb chunks – each chunk is called an Allocation Context
* An allocation context belongs to a thread
* Allocation of each chunk requires a lock for a UP machine (GC uses lightweight spin locks) and is lock free on MP machines (see GC flavors later)
3.4.2 Zeroing the Memory
When a chunk is given, GC zeroes the memory. This is done for two reasons:
1) Security – you do not stumble upon left over garbage
2) It helps with Fail Fast. Code referencing a null pointer fails faster than code referencing some random data
3.4.3 Allocating Memory to an Object
When it comes to assigning memory to an object
* If it is within the current allocation context, the GC just needs to move the pointer
* If it is outside the allocation context, the GC needs to allocate another allocation context
3.4.4 Generation Budget
For each generation, the GC keeps a “budget” – a threshold value which when crossed triggers a collection in that generation
* When the GC needs to come up with an allocation context and realizes it has crossed the generation budget, a collection is triggered for that generation.
* For Gen 0, the budget is much smaller than the ephemeral segment
* The budget is dynamically adjusted by the GC over the lifetime of an app
3.5 Finalization

3.5.1 The Finalization Problem
Objects that need to explicitly release resources as a part of their cleanup (typically unmanaged resources like database connections, file handles, etc.), cannot rely on GC alone to do a cleanup.
* It is desired that the calling code may do the cleanup imperatively
* It is also desired that during collection, the object gets a chance to clean itself up if the calling code has not done so imperatively earlier
3.5.2 Finalization in CLR
3.5.2.1 Imperative Finalization
The calling code can call some specific method (typically called “Close” or “Dispose”) and cleanup the object imperatively. Types are supposed to implement the IDispose interface for this (see IDispose later)
3.5.2.2 Finalization by the Runtime
To indicate to the GC that there is a cleanup required, the object can implement a method called Finalize
* The method called Finalize is exposed as a destructor in C#.
* A destructor in C# is not really a destructor, it just expands to a method called Finalize which in turn calls the base class’ Finalize method
3.5.2.3 Finalization Mechanism
The system keeps a track of objects with a Finalize method in a structure called the Finalization queue. During the mark phase, after the graph of reachable objects has been built, the Finalization queue is checked, and if there is an object in the Finalization queue that is not on the graph:
1) GC puts it on a separate queue called the F-Reachable queue, and adds the object to the graph of reachable objects
* Since the object is now reachable, it does not get collected
* Since this object survives a collection it gets promoted to a higher generation.
* The same happens to all the objects referenced by this object
2) At some stage, GC invokes a special runtime thread to call Finalize on each object in the Freachable queue
* No guarantees on when Finalize would be called
* No specific order in which objects are finalized
* Exception in a Finalize method is interpreted by the GC as a proper method exit and not an exception
3) Finalized objects are removed from the Freachable queue and become unreachable and would be collected in the next collection
* So a Finalizable object and each object that it references, take two collections in a higher generation than otherwise
* If an object has been imperatively cleaned up, this overhead should be avoided
* Therefore a method called GC.SuppressFinalize is provided which should be called by an object if it has been cleaned up imperatively to avoid being put on the FReachable queue. This also prevents a Finalizable object from being promoted to the next gen (unless already in Gen 2)
3.5.3 Resurrection
* Since a Finalizable object after dying becomes alive again when put on the Freachable list, the phenomenon is called Resurrection. This is shortlived since the GC collects it shortly there after
* However, Resurrection can be more permanent if in the Finalize method, the object puts a pointer to itself in a global / static variable. Now the object is reachable even after being removed from the Freachable queue, so are the other Finalized objects to which this object may have held references.
* The resurrected object now needs to be put back on the Finalization list so that when it eventually gets collected, it gets Finalized. For this, the object should call GC.ReRegisterForFinalize()
3.5.4 Implementing a Finalizable Object

3.5.4.1 Imperative Cleanup
The mechanism an object uses to enable imperative cleanup is called the “Dispose Pattern”. The Dispose pattern is realized by implementing the IDisposable interface, which looks as follows:
public interface IDisposable
{
void Dispose();
void Dispose(bool disposing);
}
* Typically the object would keep track of whether Dispose has been called or not by using a private flag
* The Dispose() method maybe called imperatively. Typically Dispose() calls Dispose(bool) with a value of true and then calls GC.SuppressFinalize(this)
* Depending on what value is passed to the Dispose(bool), there are two possibilities:
1) Dispose(true) is called by the user code directly / indirectly. Both managed and unmanaged resources can be cleaned up here
2) Dispose(false) is called by the runtime from inside the Finalizer. Here, since the managed resources of the object may have already been cleaned up by the GC, no managed cleanup is done, and only unmanaged resources are cleaned up.
3.5.4.2 Runtime Cleanup
To enable the runtime to cleanup the code, the Finalize method needs to be implemented. This is typically combined with implementing the Dispose pattern. Here’s sample code for writing a Finalizable Type (taken from the MSDN documentation)
