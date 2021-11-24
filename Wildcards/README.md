[Multics 07/30/86  Star Convention (general information)](https://web.mit.edu/multics-history/source/Multics/doc/info_segments/star_convention.gi.info)

[Exploring the Design of an Intentional Naming Scheme with an AUtomatic Constraint Analyzer](https://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.1006.4368&rep=rep1&type=pdf) by Sarfraz Kurshid

[A Comparison of Textual Modeling Languages: OCL, Alloy, FOML](http://ceur-ws.org/Vol-1756/paper05.pdf)

[Some Shortcomings of OCL, the Ob ject Constraint Language of UML](https://groups.csail.mit.edu/sdg/pubs/1999/omg.pdf) by Mandana Vaziri and Daniel Jackson, 1999.

[Enforcing Design Constraints with Object Logic](https://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.43.4113&rep=rep1&type=pdf) by Daniel Jackson

> ## 3.1 Exploring Queries in COM
> In attempting to use Microsoft COM to implement a novel component architecture, Sullivan and his colleagues came across an interesting anomaly [24]. COM allows one component to aggregate other components, with the outer component passing off one or more
> services of inner components as its own, thus avoiding the cost of explicitly delegating service requests from outer to inner. Surprisingly, the rules of COM require in such a situation
> that every service of an inner component be visible through the outer component: in other
words, hiding is compromised. Since this is clearly not the intent of the designers of COM,
> the published rules of COM must be amended. It turns out to be sufficient to weaken the
rules for inner components.
> 
> Sullivan explored this problem by formalizing the published rules of COM in the Z formal specification language [23]. He then proved, by hand, a theorem stating that, whenever
> aggregation is present, hiding is lost. By introducing a distinction between ‘legal’ and ‘illegal’ components, he was able to qualify this theorem so that it applies only when the inner
> components are legal.

24. Kevin Sullivan, M. Marchukov and D. Socha. Analysis of a conflict between interface negotiation
and aggregation in Microsoft’s component object model. IEEE Transactions on Software Engineering, July/August, 1999.

> ## 3.2 Checking an Intentional Naming Scheme
> An intentional naming scheme allows objects to be looked up by their specifications rather
> than their identities or locations. A recent framework supporting this idea [1] allows queries called ‘name specifiers’ in the form of trees of alternating attributes and values. These
> are presented to a name resolver whose database, called a ‘name tree’, is similarly structured, but which also contains ‘name records’ returned as the results of queries.
> 
> We used Alloy to check the correctness of a lookup algorithm that had been previously
> specified in pseudocode and implemented in Java [16]. The Alloy description was about 50
> lines long, with an additional 30 lines of assertions expressing the anticipated properties to
> be checked. The code of the algorithm is roughly 1400 lines of Java, with an additional 900
> lines of testing code. The Alloy analysis revealed that the algorithm returns the wrong
> results in a number of important but tricky cases, and that a key claim made about the algorithm (to do with the role of wildcards) is invalid.
> 
> This case study illustrates the value of partial modelling. Our description included only
> one crucial operation – lookup – and summarized the others as invariants on the name tree.
> To analyze the possible lookup scenarios, it was not necessary to write an abstract program
> that generates different prestates for lookup by executing operations that mutate the name
> tree. Instead, the analysis considered all lookup scenarios (within a bounded scope) that
> began in states satisfying the given invariants.

16. Sarfraz Khurshid and Daniel Jackson. Exploring the Design of an Intentional Naming Scheme with
an Automatic Constraint Analyzer. Submitted for publication. Available at: http://sdg.lcs.mit.edu/~dnj/publications
