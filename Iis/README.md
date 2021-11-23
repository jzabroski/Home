[https://techcommunity.microsoft.com/t5/iis-support-blog/windows-authentication-http-request-flow-in-iis/ba-p/324645](Windows Authentication HTTP Request Flow in IIS) by Priyanka Pillai

1. [https://journeyofthegeek.com/2016/11/03/deep-dive-into-resource-based-constrained-delegation/](Deep Dive Into Resource-Based Constrained Delegation – Part 1)
2. [https://journeyofthegeek.com/2016/11/03/deep-dive-into-resource-based-constrained-delegation-part-2/](Deep Dive Into Resource-Based Constrained Delegation – Part 2)

# DelegConfig
In the 2000s, Brian Murphy-Booth of Microsoft had released the DelegConfig tool for testing Kerberos double hop scenarios.  That tool is still available at https://www.iis.net/downloads/community/2009/06/delegconfig-v2-beta-delegation-kerberos-configuration-tool

However, Microsoft Support Escalation Engineer Matt Hamrick notes:

> Windows Authentication is currently based on a single connection from a single client. Thus, if a client opens many connections with a WinAuth-protected server, then each connection gets authenticated. Since HTTP/2 supports multiplexing - multiple concurrent HTTP requests per connection - the current WinAuth implementation is incompatible with it. Last I heard, making WinAuth HTTP/2 compatible was not high on the list.
