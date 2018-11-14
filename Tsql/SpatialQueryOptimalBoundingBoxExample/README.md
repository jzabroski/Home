# How do I calulate an optimal bounding box for a SQL Server spatial index?

## Symptoms
An optimized bounding box can greatly improve the performance of SQL Server based spatial indexes in cases where the data has a fairly uniform distrubution.   Here are some methods for calculating the bounding box for a given feature class.

## Diagnosis

Here is an example for calculating the optimal bounding box for a feature class called BUILDING that contains 25000 records:

Solution

```sql
SELECT COUNT(*) FROM Building
-- Records: 250000

-- Using method 1:

SELECT
  ROUND(MIN(Geometry_SPA.STEnvelope().STPointN(1).STX), 0),
  ROUND(MIN(Geometry_SPA.STEnvelope().STPointN(1).STY), 0),
  ROUND(MAX(Geometry_SPA.STEnvelope().STPointN(3).STX), 0),
  ROUND(MAX(Geometry_SPA.STEnvelope().STPointN(3).STY), 0)
FROM Building;

-- Run time: 40s
--
-- This one is a little faster:

WITH
  ENVELOPE as  ( SELECT Geometry_SPA.STEnvelope() as envelope from Building ),
  CORNERS  as  ( SELECT envelope.STPointN(1) as point from ENVELOPE  UNION ALL select envelope.STPointN(3) from ENVELOPE  )
SELECT
        MIN(point.STX) as MinX,
        MIN(point.STY) as MinY,
        MAX(point.STX) as MaxX,
        MAX(point.STY) as MaxY
   FROM  CORNERS;

-- Run time: 28s
--

If you are using SQL 2012, you can use the following method which is quite fast:

SELECT
       geometry::EnvelopeAggregate(Geometry_SPA).STPointN(1).STX AS MinX,
       geometry::EnvelopeAggregate(Geometry_SPA).STPointN(1).STY AS MinY,
       geometry::EnvelopeAggregate(Geometry_SPA).STPointN(3).STX AS MaxX,
       geometry::EnvelopeAggregate(Geometry_SPA).STPointN(3).STY AS MaxX
FROM Building;

-- Run time: 10s
```
