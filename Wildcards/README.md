[Multics 07/30/86  Star Convention (general information)](https://web.mit.edu/multics-history/source/Multics/doc/info_segments/star_convention.gi.info)

[Exploring the Design of an Intentional Naming Scheme with an AUtomatic Constraint Analyzer](https://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.1006.4368&rep=rep1&type=pdf) by Sarfraz Kurshid

[A Comparison of Textual Modeling Languages: OCL, Alloy, FOML](http://ceur-ws.org/Vol-1756/paper05.pdf)

[Some Shortcomings of OCL, the Ob ject Constraint Language of UML](https://groups.csail.mit.edu/sdg/pubs/1999/omg.pdf) by Mandana Vaziri and Daniel Jackson, 1999.

[Enforcing Design Constraints with Object Logic](https://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.43.4113&rep=rep1&type=pdf) by Daniel Jackson

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
