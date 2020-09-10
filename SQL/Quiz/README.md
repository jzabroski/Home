# Cumulative Sum

## Problem

Data in table `t`
| I'd | num |
| --- | ---- |
| 1 | 25 |
| 2 | 37 |
| 3 | 20 |
| 4 | 9 |
| 5 | 24 |

How do I get a cumulative sum column?

| id | num | cumsum |
| -- | ---- | ---- |
| 1 | 25 | 25 |
| 2 | 37 | 62 |
| 3 | 20 | 82 |
| 4 | 9 | 91 |
| 5 | 24 | 115 |

## Answer

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
2. It's suboptimal, even for basic SQL dialects that don't support window functions, because you can instead use either:
    1. a no-OP aggregate, e.g. `MIN(t1.num)`
    2. Perform a running aggregation in a derived table expression using `LATERAL` or `APPLY` syntax 