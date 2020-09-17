# Cumulative Sum

## Problem

Data in table `t`
| id | num |
| -- | --- |
|  1 |  25 |
|  2 |  37 |
|  3 |  20 |
|  4 |   9 |
|  5 |  24 |

How do I get a cumulative sum column?

| id | num | cumsum |
| -- | --- | ------ |
|  1 |  25 |     25 |
|  2 |  37 |     62 |
|  3 |  20 |     82 |
|  4 |   9 |     91 |
|  5 |  24 |    115 |

## Answers

### Naive

There are several different ways to achieve this. The naive way:

```sql
SELECT T1.ID, T1.NUM, SUM(t2.NUM) AS CUMSUM
FROM t as  T1
INNER JOIN t AS T2 ON t1.Id >= t2.Id
GROUP BY T1.ID, T1.NUM
ORDER BY T1.ID
```

This approach is naive because:
1. It doesn't make any sense to group by num, as it's not part of the key
2. It's suboptimal, because an `INNER JOIN` will compare all records in a table to all other records to see whether a condition matches.
3. Even for basic SQL dialects that don't support window functions, you can instead use either:
    1. a no-OP aggregate, e.g. `MIN(t1.num)`
    2. Perform a running aggregation in a derived table expression using `LATERAL` or `APPLY` syntax 
4. A window function should be the intuitive answer, given that the notion of cumulative sum is basically performing a sum over a window 

### Better - no-OP aggregate

```sql
SELECT
  T1.ID,
  MIN(T1.NUM) AS NUM,
  SUM(t2.NUM) AS CUMSUM
FROM t as  T1
INNER JOIN t AS T2 ON t1.Id >= t2.Id
GROUP BY T1.ID
ORDER BY T1.ID
```

or, alternatively, use grouping sets: 
```sql
SELECT T1.ID, MIN(T1.NUM), SUM(t2.NUM) AS CUMSUM
FROM t as  T1
INNER JOIN t AS T2 ON t1.Id >= t2.Id
GROUP BY GROUPING SETS (T1.ID)
```

### Even Better - `CROSS APPLY`
```sql
SELECT
  T1.id,
  T1.num,
  T2.CumSum
FROM
  t AS T1
  CROSS APPLY (
    SELECT
      SUM(T2.num) AS CumSum
    FROM t AS T2
    WHERE T1.id >= T2.id
  ) T2
```

# Bizarre - Use [common table expression ORDERED update](https://weblogs.sqlteam.com/mladenp/2009/07/28/sql-server-2005-fast-running-totals/):

This is a fairly clever trick, in that it behaves much like a window function.

```sql
DECLARE @RT INT = 0
;WITH RunningTotal AS (
  SELECT TOP 100 PERCENT
    id ,
    num ,
	cumsum
  FROM t
  ORDER by id
)
UPDATE RunningTotal
SET @RT = cumsum = @RT + num
OUTPUT inserted.*
```

### Best - Window Function

The article by Leis et al (http://www.vldb.org/pvldb/vol8/p1058-leis.pdf) presents a nice perspective on window function complexity in different situations and uses.

In the below example, the computational complexity is `O(N)`:

```sql
SELECT
  id,
  num,
  SUM(num) OVER (ORDER BY id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumsum
FROM t ORDER BY id
```
