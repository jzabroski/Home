# Troubleshooting

If you get the following error message:
> The URL X for Web project Y is configured to use IIS as the web server but the URL is currently configured on the IIS Express web server. To open this project, you must edit the 'C:\Users\User\Documents\IISExpress\config\applicationhost.config' file to change the port of the site currently using the URL in IIS Express.

then you should look into updating your csproj to <UseIIS>false</UseIIS>

This is **really old advice** so I hope for your sake you don't need this knowledge.

http://rickgaribay.net/archive/2012/11/08/the-url-x-for-web-project-y-is-configured-to.aspx

# Delegation

[https://techcommunity.microsoft.com/t5/iis-support-blog/windows-authentication-http-request-flow-in-iis/ba-p/324645](Windows Authentication HTTP Request Flow in IIS) by Priyanka Pillai

1. [https://journeyofthegeek.com/2016/11/03/deep-dive-into-resource-based-constrained-delegation/](Deep Dive Into Resource-Based Constrained Delegation – Part 1)
2. [https://journeyofthegeek.com/2016/11/03/deep-dive-into-resource-based-constrained-delegation-part-2/](Deep Dive Into Resource-Based Constrained Delegation – Part 2)

## DelegConfig
In the 2000s, Brian Murphy-Booth of Microsoft had released the DelegConfig tool for testing Kerberos double hop scenarios.  That tool is still available at https://www.iis.net/downloads/community/2009/06/delegconfig-v2-beta-delegation-kerberos-configuration-tool

However, Microsoft Support Escalation Engineer Matt Hamrick notes:

> Windows Authentication is currently based on a single connection from a single client. Thus, if a client opens many connections with a WinAuth-protected server, then each connection gets authenticated. Since HTTP/2 supports multiplexing - multiple concurrent HTTP requests per connection - the current WinAuth implementation is incompatible with it. Last I heard, making WinAuth HTTP/2 compatible was not high on the list.
