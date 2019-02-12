## Lab 5

### Solutions P1
Understand the working flow of the AODV protocol implemented in ns2 and try to answer the following questions :
1. How to enable HELLO packets in AODV ? Name the file in which you can do it.

All files are located in `/home/kirito/Documents/ns-allinone-2.35/ns-2.35/aodv/`
By default HELLO packets are disabled in the aodv protocol. To enable broad-
casting of Hello packets, comment the following two lines present in aodv.cc
```
#ifndef AODV LINK LAYER DETECTION
#endif LINK LAYER DETECTION;
``` 
and recompile ns2 by using the following
commands on the terminal:
```
make clean
make
sudo make install
```

2. What are the timers used in AODV protocol? What is the use of timer?

In ns2, timers are used to delay actions or can also be used for the repetition of
a particular action like broadcasting of Hello packets after fixed time interval.
Following are the timers that are used in AODV protocol implementation:
• Broadcast Timer: This timer is responsible for purging the ID’s of Nodes
and schedule after every BCAST ID SAVE.
• Hello Timer: It is responsible for sending of Hello Packets with a delay
value equal to interval, where
double interval = MinHelloInterval + ((MaxHelloInterval - MinHelloInt-
erval) * Random::uniform());
• Neighbor Timer: Purges all timed-out neighbor entries and schedule after
every HELLO INTERVAL .
• RouteCache Timer: This timer is responsible for purging the route from
the routing table and schedule after every FREQUENCY.
• Local Repair Timer: This timer is responsible for repairing the routes.

3. Name the function in ns2 which gets executed in Network layer of AODV when receiving a packet by any node? Name the file in which this function is present?

void recv(Packet \*p, Handler \*): At the network layer, the Packet is first
received at the recv() function, sended by the MAC layer in up direction.
The recv() function will check the packet type. If the packet type is AODV
type, it will decrease the TTL and call the recvAODV() function.
If the node itself generating the packet then add the IP header to handle
broadcasting, otherwise check the routing loop, if routing loop is present
then drop the packet, otherwise forward the packet.
This function is in aodv.cc

4. Name the function used in ns2 for AODV to update the route? Mention the filename where the function is present?

void rt_update(aodv rt entry \*rt, u int32 t seqnum,u int16 t metric, nsaddr t
nexthop,double expire time): This function is responsible for updating the
route.
This is also in aodv.cc

5. Which function is invoked whenever the link layer reports a route failure? Name the filename also.

void rt_ll_failed(Packet \*p): Basically this function is invoked whenever
the link layer reports a route failure. This function drops the packet if
link layer is not detected. Otherwise, if link layer is detected, drop the
non-data packets and broadcast packets. If this function founds that the
broken link is closer to the destination than source then It will try to
attempt a local repair, else brings down the route.
This is also in aodv.cc

6. What is local repair in a protocol? Name the local repair function for AODV in ns2? Name the .cc file.

This function is for local repair. It is in aodv.cc
```
void local rt repair(aodv rt entry \*rt, Packet \*p): This function first buffer
the packet and mark the route as under repair and send a RREQ packet
by calling the sendRequest() function.
```

7. Which function is responsible for handling link failure? Name the .cc file.

void handle_link_failure(nsaddr t id)
It is in aodv.cc

8. Which function is responsible for purging the routing table entries from the routing table? Name the .cc file.

void rt_purge(void)
It is also in aodv.cc

*** 
ref: 	https://www.researchgate.net/publication/45930883_A_Tutorial_on_the_Implementation_of_Ad-hoc_On_Demand_Distance_Vector_AODV_Protocol_in_Network_Simulator_NS-2

### Solution P2
#### Download and Configure wfrp in ns2 
There are multiple ways to go about doing this:
1. Use these links to configure files step by step.
http://all-time-ns-2.blogspot.com/2010/10/adding-new-routing-protocol-in-ns-2.html  
https://www.nsnam.com/2013/07/wsn-flooding-routing-protocol-wfrp-in.html

2. Use this patch to do all things 'automatically'.  
https://groups.google.com/forum/#!msg/ns-users/JmCEgUbiLro/J7vos5eqAgAJ

### Solution P3
```
exp1.tcl
performance_analysis.awk
```
PDR:	 100
End to end delay of packets received:	 0.0169278 s
Throughput:			 281.139 bits/second

*** 
Imp links:
* https://groups.google.com/forum/#!topic/ns-users/JmCEgUbiLro
* https://github.com/webapps1/ns-allinone-2-34-imp-protocol
* https://bphanikrishna.wordpress.com/ns2-lab-related/
* http://fikirankubuntu.blogspot.com/2010/03/adding-new-routing-protocol-in-ns2.html
