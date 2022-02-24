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

# Features for ETL Connectors

## Key Questions
First, the key questions you should ask about any ETL connector are:

1. What happens when a column is added in the source?
2. What happens when the TYPE of a column is changed in the source?
3. What happens when a row is deleted in the source?

## Buy vs. Build
Second, nearly everyone should use SOME commercial ETL tool rather than build it themselves. It’s not that hard to write some scripts that sync your data; the hard part is keeping up with schema changes, and the REALLY hard part is dealing with turnover on your data team. For whatever reason, data engineering teams experience a lot of turnover. In my experience, there are only two scenarios where it CAN make sense to write your own ETL:

* Your source schema is extremely stable so you rarely have to update your scripts.
* ETL is part of your core business and you have a dedicated team that will maintain and monitor your ETL.

Lastly, some vendors (e.g., Fivetran) does not support transformation, because those vendors believe this to be an anti-feature: in the long run, it’s a lot easier to maintain looker derived-tables. But not everyone agrees, and this is an important difference between the no-transformation vendors (FiveTran, Stitch) and our pro-transformation friends (Alooma, ETLeap, Boomi, …).
