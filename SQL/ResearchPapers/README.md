[Pushing Projection Revisited](https://www.cs.rice.edu/~vardi/papers/edbt04.pdf) Benjamin J. McMahan⋆⋆, Guoqiang Pan⋆ ⋆ ⋆, Patrick Porter†, and Moshe Y. Vardi‡. Rice University.

> Abstract. The join operation, which combines tuples from multiple relations, is
> the most fundamental and, typically, the most expensive operation in database
> queries. The standard approach to join-query optimization is cost based, which
> requires developing a cost model, assigning an estimated cost to each queryprocessing plan,
> and searching in the space of all plans for a plan of minimal
> cost. Two other approaches can be found in the database-theory literature. The
> first approach, initially proposed by Chandra and Merlin, focused on minimizing
> the number of joins rather then on selecting an optimal join order. Unfortunately,
> this approach requires a homomorphism test, which itself is NP-complete, and
> has not been pursued in practical query processing. The second, more recent, approach focuses on structural properties of the query in order to find a project-join
> order that will minimize the size of intermediate results during query evaluation.
> For example, it is known that for Boolean project-join queries a project-join order
> can be found such that the arity of intermediate results is the treewidth of the join
> graph plus one.
> 
> In this paper we pursue the structural-optimization approach, motivated by its
> success in the context of constraint satisfaction. We chose a setup in which the
> cost-based approach is rather ineffective; we generate project-join queries with
> a large number of relations over databases with small relations. We show that
> a standard SQL planner (we use PostgreSQL) spends an exponential amount of
> time on generating plans for such queries, with rather dismal results in terms
> of performance. We then show how structural techniques, including projection
> pushing and join reordering, can yield exponential improvements in query execution time. 
> Finally, we combine early projection and join reordering in an implementation of the 
> bucket-elimination method from constraint satisfaction to obtain
> another exponential improvement.
