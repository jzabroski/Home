# My Thoughts

Dependency Injection is simply the native execution model of .NET, and simply amounts to cutting out ambient authority from programs. This is a VERY good idea.

Aspect-Oriented Programming, in the style of AspectJ, is a bad idea IMHO. Friedrich Steimann [1] is a very good researcher who has a detailed rant about AOP [2] [3], so there is no need to call it a "useless rant" or to blog about it.

Object-Relational Mappers vary in quality, and all I have seen have very poor strategies for dealing with heterogeneous execution of code (converting an expression tree (or object graph) into SQL statement(s)). The SQL generated by most ORMs is naive, primarily because the SQL is not specialized based on the environment it will execute in. Important factors like DBMS Vendor, DBMS Version #, etc. all matter. These issues are not typically addressed, because designing internal subsystems of ORMs correctly requires more polish than open source developers tend to be capable of coordinating. Also, most individual contributors to open source projects do not actually expect to convert their database from one vendor to the next, and so the desire to see efficient query generation regardless of vendor is lacking market forces. There is simply no itch to scratch, or if there is an itch, it is negligible in comparison to the time and effort required to scratch it.

As far as I can tell, the Re-Motion project is one of the first efforts to actually challenge my controversial statements above bout ORMs. But, as I understand it, they are doing it by adding another layer of abstraction, rather than modifying and refactoring the internal subsystem of their favorite ORM. Not that there is anything obviously wrong with that approach, but it does seem subverted on close inspection. For example, as I understand it, most ORMs do not do a good job exposing the query generator as a compiler architecture like LLVM, and so Re-Motion is fundamentally targeting a moving target. A quick dig into Hibernate reveals what a mighty hack grouping is there, and how it instantly breaks down when vendors support more advanced ways to group sets of data and provide roll-ups on those groups. Without access to query generation primitives, Re-Motion is simply rewriting the AST*, when really it should be re-writing and re-ordering query generation passes on a per query, per vendor basis. ORM Query Generators themselves face the same problem, not having detailed access to the black boxes that are Cost-Based Optimizers and Estimated/Actual Execution Plans. This is a combinatorically explosive problem.

* Apologies if I misrepresented Re-Motion. As Stefan Wenig posted above, there is a lot of code in that project and digging through the internals completely is time-consuming, so I made only a cursory review and handwaved the rest.

Cheers!

1. www.kbs.uni-hannover.de/~steimann/
2. F Steimann "Why most domain models are aspect free" in: 5th Aspect-Oriented Modeling Workshop AOM@UML (2004).
3. F Steimann "Aspects are technical, and they are few" European Interactive Workshop on Aspects in Software EIWAS'04 (2004).

# Stefan Wenig's thoughts

Two ways to look at the mixin story:
1. The multiple-inheritance way
    I'd just like to have another base type for implementation inheritance. Mixins are arguably a more elegant solution that avoid some of the problems of MI. But you basically use them to achieve the same design goal. You nailed that point well.
2. Multi-dimensional separation of concerns
    This is a much longer story. MDSOC was an academic movement of the 90s, that later faded for reasons I don't fully understand (my best guess is that they eventually went all-in on AOP, and then they died with it).
We're more interested in option 2. The basic idea here is that you have classes with just their intrinsic properties and functionality. Much like an anemic domain model, if you will. You then add functionality to classes via sets of mixins. (Such a set would be a hyperslice in MDSOC/HyperJ.)

These sets are then combined to form actual applications. What you win is separation of concerns: you no longer have the single dimension of single inheritance along which to structure your applications modules and source code, but any number you choose (units of change, features, different versions)

I highly recommend the paper "N Degrees of Separation: Multi-Dimensional Separation of Concerns" by Tarr et.al.
www.computer.org/portal/web/csdl/doi/10.1109/IC...

It's a paid download, but many free ressources are available online. Just ask Google.

It's a good read for anybody, not too academical for anybody interested in such concepts. A more elaborate version is amzn.to/lUVmaJ

HyperJ was abandoned in favor of AspectJ. But AOP got out of fashion for anything other than cross-cutting concerns (logging, security etc.) for many reasons. Mixins (with the right set of features) could be just the right technology to get MDSOC into the mainstream. The biggest problem right now seems to be that nobody pursues the concept of MDSOC any more. (There is DCI by Trygve Reenskaug, who was one of the major influencers of MDSOC with his concept of role models. They were all about SoC too. DCI also uses roles and talks a lot about mixins, but it's rather vague on these things and I'm still searching for the connection.)

# Stefan Wenig's THoughts 2.0

- re-mix is just this: mixins. it caters to the larger vision, which has MDSOC at its core, but has been designed to provide just this basic language extension, no frills, no distraction, use it for anything you like and any architectural approach. some compile-time tooling (validation, pre-compilation, reports)
- re-linq is just infrastructure for any LINQ-provider, and an almost complete SQL backend. it has no connections to re-mix. it's lean and mean, designed to be included in 3rd party libs.
- re-motion is a large opinionated framework. it extends the concept of mixins to hyperslices, including ORM and fadcading capabilities. we use it as a foundation for our own product development. besides the design advantages of MDSOC (no tangling/scattering), there are two main advantages if you build a product with MDSOC:
    - you can easily assemble different editions in a product lines (for different types of customers, basically)
    - the product can easily be customized using the very same mechanisms that we use for product development.
essentially, using MDSOC, you build not just a product, but a plattform. say goodbye to brittle events, explicit user exits and database triggers. we believe that this is a whole new ballgame for LoB products like CRM or ERP.

All three are OSS, but only re-linq and re-mix are in a state where we can recommend general usage already. with re-motion, we have some documentation work to do (well, it does have reference documentation and a few hands-on labs, but we need to convey the vision too or it won't make sense.)

# Stefan Wenig's Thoughts 3.0

After a brief look on Steimann's papers, I think this just underlines my belief that the MDSOC community just gave in to the then-popular AOP movement, and eventually was torn down with it. Steimann seems to focus on cross-cutting concerns and eventually comes to the conclusion that there's very few of them, not enough to justify all the AOP hype. I agree, and I think MSFT did the right thing calling this policy injection and avoiding the AOP name tag.

But AOP was popular, and technically, it could also be used to implement MDSOC. I think it sucks at that. But more important was that by association, MDSOC eventually was dismissed toghether with cross-cutting concerns, although it set out to solve a very different problem.
Steimann himself recommends mixins and interfaces as a more viable alternative. He doesn't directly address MDSOC, and where his perception of AOP apporoaches it, he becomes vague.

I still think it's time to take MDSOC out of AOP's grave and realize that it could still be a great solution to problems that plague many of us. More so than code-generation based MDA which Steimann seems to like (how dead is that? models cannot express novel ideas, only what the modeling language foresees.)
