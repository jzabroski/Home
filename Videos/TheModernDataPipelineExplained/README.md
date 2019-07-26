https://youtu.be/hBsfOJuBHoY

# Current Business Viewpoint 
Data is the core asset. 

# Historical Approaches

1. Database to Database: Batch ETL
2. Application to Application: Enterprise Service Bus

Line between service bus and ETL blurs. 

# Market Forces

1. Cloud
2. Real-time data

## Cloud warehouse 10x cheaper than Vertica

## Canonical Analytics Query

```sql
SELECT d.c1, d.c2, count(1) 
FROM Fact
JOIN Dimension d
  On f.C1 = d.c1
GROUP BY
  D.C1, D.C2
WHERE DAY(F.TIMESTAMP) BETWEEN @StartDate and @EndDate
And s.id in ( /* subselect for users */) 
```

Data lake
Schema on read - Alooma thinks this is a mistake

Alooma
1. Schema on write
2. Make everything a stream 
3. View stream like a transaction log
4. If data do not have Schema, Schema will be inferred


