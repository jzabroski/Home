Watching today's Beeswax Snowflake talk: it's a condensed version of talk at Snowflake Summit

0:00 - 2:00
- Senior Software Engineer at Beeswax
- Looked at many database solutions to replace legacy Redshift platform with operations and performance issues, ultimately chose Snowflake
- Criteria:
    1. Horizontally scalable
    2. Help optimizing costs


02:00 - 5:30
- Beeswax: request to bid platform for ad exchanges
 - Millions of bid requests per second from ad exchanges Auction for right to buy an ad 
- ETL billions of daily events per day and train machine learning models to optimize the bidding 
- Deliver data to customers in reports, files and by API

 5:30 - 6:20
 - everything built with assumption of horizontal scaling and turning machines on or off based on demand, scaling up or down based on bidding, did a lot of work to make this scaling very efficient because there's many bidders. As business grows, add customers, they spend money, more data flows through platform, more bidding, and on and on 
- in 2018,database tripled in size. They were on mid size Redshift cluster

 6:20 - 9:20

Use cases:
1. ETL Pipelines for Bids, Wins, and Clicks to Redshift
 2. Web requests: serving all reading back off of Redshift 
3. Mix of reads and writes

Problem: Locked into Redshift pricing model, where you up front license a fixed size cluster for a length of time. Can pay to resize, but resize is just a guess again for another long term commitment 

Solution attempt 1: A lot of data engineers were spending time trying to optimize queries to wring performance out of the cluster

Solution attempt 2: Resize Redshift cluster. It was painful, because it was this "old model" of how you resize. You need to take a snapshot of your cluster, provision a new cluster that's larger, copy the snapshot over, take all data pipelines (dozens) and repoint them to the new cluster. A lot of state, time boundaries. Very hard to lift and shift correctly. Things are running on different time frames in different time windows. Starting up cleanly a real challenge. Most of engineering was going into keeping the lights on

 - Business was looking at reality of up sizing Redshift again, committing to it long term at a significant extra cost

9:20
- A fancy architecture I can't put into words.

Key drivers
- True horizontal storage scaling. Storage scales automatically
- Snowflake decouples compute from storage. You pay for storage as you accumulate it, and compute as you need it

Rewritten to take advantage of Snowflake warehouse computation units
- some jobs were cpu intense, others light, need ran hourly VS weekly

- give warehouses based on data volume 

Problem in Redshift : can't handle concurrent readers with writers

Reports would steal CPU from Etl pipeline write

Had to write pieces to orchestrate data processing around Snowflake
- DAGs as Pipelines
- Wrote a lot of unit tests
- Moved from using AWS Data Pipelines to AirFlow. He said a lot of people are using AirFlow for data pipeline 
- Integration with AirFlow is simple. Kick off a batch run. 
- Added custom monitors, metrics and alerts around pipelines 


In conclusion,
1. solved fixed size model
2. Solved concurrent readers and writers 