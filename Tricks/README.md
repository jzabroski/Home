# Disable swapping
> Most operating systems try to use as much memory as possible for file system caches and eagerly swap out unused application memory. This can result in parts of the JVM heap or even its executable pages being swapped out to disk.
> 
> Swapping is very bad for performance, for node stability, and should be avoided at all costs. It can cause garbage collections to last for minutes instead of milliseconds and can cause nodes to respond slowly or even to disconnect from the cluster. In a resilient distributed system, it’s more effective to let the operating system kill the node.
> 
> Source: https://www.elastic.co/guide/en/elasticsearch/reference/current/setup-configuration-memory.html


# VictoriaMetrics
Built on top of Clickhouse
https://medium.com/devopslinks/victoriametrics-creating-the-best-remote-storage-for-prometheus-5d92d66787ac
