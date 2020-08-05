# VPN
- Windows built-in VPN doesn't support Two Factor Authentication
- Need to set-up Radius server inbetween your VPN and Kerberos Server (Active Directory). The Radius Server can then talk to your 2FA server.

# Computer Science

1. [Rethinking Computer Architectures and Software Systems for Phase-Change Memory](http://www.cs.newpaltz.edu/~lik/publications/Chengwen-Wu-ACM-JETC-2016.pdf)
    > CHENGWEN WU and GUANGYAN ZHANG, Tsinghua Universitym, KEQIN LI, State University of New York
2. [Space-Memory-Memory Architecture for Clos-Network Packet Switches](https://www.cse.ust.hk/~hamdi/Publications_pdf/Space-Memory-Memory%20Architecture%20for%20Clos-Network%20Packet%20Switches.pdf)
    > Xin Li, Zhen Zhou and Mounir Hamdi
3. [Minimal Rewiring: Efficient Live Expansion for Clos Data Center Networks](https://www.usenix.org/system/files/nsdi19spring_zhao_prepub.pdf)
    > Shizhen Zhao, Rui Wang, Junlan Zhou, Joon Ong, Jeffrey C. Mogul, Amin Vahdat
    > 
    > Google, Inc.


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
