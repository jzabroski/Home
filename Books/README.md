### How to Build a Billion Dollar App
by George Berkowski

Chapter 9: Metrics to Live and Die By

AARRR:
- Acquisition
- Activation
- Retention
- Referral
- Revenue

### Agile Data Warehouse Design: Collaborative Dimensional Modeling, from Whiteboard to Star Schema
by Lawrence Carr and Jim Stagnitto


> The history of data infrastructure is littered with designs 
that were based on short-term thinking to solve the 
problem of the moment. The lesson of this approach 
during both the mainframe reporting and data 
warehouse eras was that systems intended to be data 
platforms have a long life, and that weak architectures 
end up as data junkyards where data goes to die.
> Mark Madsen, Third Nature Inc., SnapLogic.com white paper: "Will the Data Lake Drown the Data Warehouse?"

> The reverse is not true. Newer data integration 
tools can easily represent tables in JSON, whereas 
nested structures in JSON are difficult to represent 
in tables. Flexible representation of data enables 
late binding for data structures and data types. 
This is a key advantage of JSON when compared 
to the early binding and static typing used by older 
data integration tools. One simple field change upstream can break a dataflow in the older tools, where the 
more flexible new environment may be able to continue uninterrupted. 
> 
> JSON is not the best format for storing data, however. This means tools are needed to translate data from 
JSON to more efficient storage formats in Hadoop, and from those formats back to JSON for applications. 
> 
> Much of the web and non-transactional data is sent today as JSON messages. The more flexible Hadoop 
and streaming technologies are a better match for transporting and processing this data than conventional 
data integration tools.

