# Industry Overview
First of all, ETL solutions can roughly be categorized as:

* connectors
* job workflow management

Most of what has been discussed above, refers to connectors. In the job flow category there are a lot more free open-source solutions - 
these are the solutions that focus on scheduling, dynamic interdependencies between data flows, and complex streaming requirements. 
Some paid-solutions offer both: job flows and connectors. And, of course, behind most connectors, 
there is some implementation of a job workflow management - it is just not exposed to the end user.

Second, the devil is in the details. It’s typically not enough to just have the data appear in your data warehouse initially.
You want to test a number of scenarios. So learn about the solution’s ability to handle:

* updates
* streaming data
* schema changes
* datatype changes
* lost records (just because you don’t see it, does not mean it does not happen)
* etc

# Understanding the Landsacpe
The criteria that we identified and that might be useful to others were:

* Time to “Ready Data”
* Data Source Diversity
* Transparency / Monitoring Capability
* Support for Redshift features or other Data Warehouses (BigQuery, Vertica)
* Affordability
* Simplicity

Finally, in some cases, you might be interested in HIPAA compliance and other stuff like that. 
Here you will likely be limiting your cloud vendors to only those who host a separate instance for you.
