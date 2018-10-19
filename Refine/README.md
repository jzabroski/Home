OpenRefine is a data cleaning project that is written in Java, and uses MIT's simile-butterly web framework as the front-end.

I would like to write a parallel data cleaning project that is written in C#, and does not use MIT license.

This page will serve as a design document for my decisions.

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
