1. [THE HOUGH TRANSFORM ESTIMATOR](https://arxiv.org/pdf/math/0503668.pdf)
2. [A Scalable and Explicit Event Delivery Mechanism for UNIX](https://www.usenix.org/legacy/event/usenix01/cfp/banga/banga.pdf). USENIX 1999.
    > The key problem with the select() interface is that it requires the application to inform the kernel, on each call, of the entire set of “interesting” file descriptors: i.e., those for which the application wants to check readiness. For each event, this causes effort and data motion proportional to the number of interesting file descriptors. Since the number of file descriptors is normally proportional to the event rate, the total cost of select() activity scales roughly with the square of the event rate.
3. [Eliminating Receive Livelock in an Interrupt-Driven Kernel](https://web.stanford.edu/class/cs240/readings/p217-mogul.pdf)
4. [30 Seconds is Not Enough! A Study of Operating System Timer Usage](https://ab.id.au/papers/timers-eurosys08.pdf)
