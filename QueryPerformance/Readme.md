Accelerating Queries on Very Large Datasets - Computational ...

crd-legacy.lbl.gov/~kewu/ps/LBNL-1677E-draft.pdf

> Among the known indexing methods, bitmap indexes are
particularly well suited for answering such queries on large scientific data. Therefore, more details are
given on the state of the art of bitmap indexing techniques. This chapter also briefly touches on some
emerging data analysis systems that don’t yet make use of indexes. We present some evidence that these
systems could also benefit from the use of indexes.

> immediate distinguishing property of
scientific datasets is that there is almost never any simultaneous read and write access to the same set of
data records. Most scientific datasets are Read-Only or Append-Only. Therefore, there is a potential to sig-
nificantly relax the ACID 1 properties observed by a typical DBMS system. This may give rise to different
types of data access methods and different ways of organizing them as well.


Parallel Augmented Maps

https://arxiv.org/abs/1612.05665


> 
> As examples of the use of the interface and the performance of PAM, we apply the library to four applications: simple range sums, interval trees, 2D range trees, and ranked word index searching. The interface greatly simplifies the implementation of these data structures over direct implementations. Sequentially the code achieves performance that matches or exceeds existing libraries designed specially for a single application, and in parallel our implementation gets speedups ranging from 40 to 90 on 72 cores with 2-way hyperthreading.

Lightning Fast and Space Efficient Inequality Joins

> Given the
inherent quadratic complexity of inequality joins, IEJoin
follows the RAM locality is King principle coined by Jim
Gray. The use of memory-contiguous data structures with
small footprint results in orders of magnitude performance
improvement over the prior art
> The basic idea of our pro-
posal is to create a sorted array for each inequality compari-
son and compute their intersection, which would output the
join results. The prohibitive cost of the intersection oper-
ation is alleviated through the use of a permutation array
to encode positions of tuples in one sorted array w.r.t. the
other sorted array (assuming that there are only two condi-
tions). A bit-array is then used to emit the join results.
