OpenRefine is a data cleaning project that is written in Java, and uses MIT's simile-butterly web framework as the front-end.

I would like to write a parallel data cleaning project that is written in C#, and does not use MIT license.  I will likely use Microsoft's [PROSE SDK](https://microsoft.github.io/prose/), which " includes a pre-defined suite of technologies for various kinds of data wrangling – cleaning and pre-processing raw semi-structure data into a form amenable to analysis \[...] Flash Fill \[...] Data extraction from text files by examples \[...] Data extraction and transformation of JSON by examples. \[...] Predictive file splitting technology".

This page will serve as a design document for my decisions.

For purposes of comparing my tool decisions to that of OpenRefine project (because I think my tool choice will end up superior and resulting in rapid develpment and fewer lines of code and cleaner semantics), here are OpenRefine's major dependencies:

- org.json
  - mainly for [Table Schema Validation errors](https://github.com/OpenRefine/OpenRefine/blob/master/main/resources/schemas/TableSchemaValidator.json)
- javax.servlet
- org.slf4j
- Simile-Butterfly
- Mockito
- TestNg
- eclipse
  - https://github.com/OpenRefine/OpenRefine/tree/master/broker/core/IDEs/eclipse
- Google AppEngine
  - com.google.appengine
- Apache
  - org.apache

# TODO List

1. Write StarUML Interaction diagram, similar to the startProject/openProject/obtainLock/addTransformations/releaseLock/getState/expire life-cycle
2. Assess whether to use Saturn or ASP.NET Core WebApi 

# TODO Entity Modeling

Possible entities:
1. Environment
2. EnvironmentConfiguration
3. EntityStore
4. Timer
5. Expirer
6. Lock - All, Column, Row, Cell - Consider abstracting Column and Row into MajorStore and MinorStore as they are just transpositions of one another.
7. Project
8. PrimaryIndex - primary way when data is loaded how it will be sorted/clustered

# TODO Service Modeling

Possible services:
1. Data characterization: over a sample of the whole data set, characterize data as string(length, encoding), date(year, month, day, time, timezone, offset), min(#), max(#), uniqueness
2. Data validation

# Other Products
1. Tableau Prep - see https://twitter.com/tableau/status/991757992923156481 pivot, join, coordinated pivots
  see also: https://pbs.twimg.com/media/DS5iaj9VAAAIItX.jpg
2. Snowflake - see https://image-store.slidesharecdn.com/b9e60cdc-fc82-4a40-9599-67b9c0c042b7-original.jpeg
