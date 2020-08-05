# VPN
- Windows built-in VPN doesn't support Two Factor Authentication
- Need to set-up Radius server inbetween your VPN and Kerberos Server (Active Directory). The Radius Server can then talk to your 2FA server.

# Computer Science

[How to Improve Packet Buffering Performance with Broadcom Smart-Buffer Technology](https://gonorthforge.com/how-to-improve-packet-buffering-performance-with-broadcom-smart-buffer-technology/)

1. Covers how MapReduce has driven a lot of burstiness in cloud data centers.
2. Covers how a good buffering algorithm, like Broadcom's SmartBuffer, helps

Goals for a good buffering switch:

1. Excellent burst absorption
2. Fair shared buffer pool access
3. Port throughput isolation
4. Traffic independent performance

[Switch Architecture](https://www.grotto-networking.com/BBSwitchArch.html#packet-switching-via-a-shared-memory-fabric)

1. Covers many different topics in network switch theory, including CLOS Crossbar Networks
