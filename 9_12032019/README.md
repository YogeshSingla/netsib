## Lab 9
### Question 1
Write a Tcl script that forms a network consisting of 6 nodes, numbered from 1 to 6, forming a ring topology. The links have a 512Kbps bandwidth with 5ms delay. Set the routing protocol to DV (Distance vector). Send UDP packets from node 1 to all nodes with the rate of 100 packets/sec (using default packet size). Start transmission at 0.01. Bring down the link between node 2 and node 3 at 0.4. Finish the transmission at 1.000. Find PDR, throughput and delay.

### Question 2
					   4 
                       | 
                       | 
         0-------------1----------2 
                       | 
                       | 
                       3

Create the above topology. Take all links as 1Mbps, 5ms delay.
Choose Centralized Multicast Routing(CM), Dense Mode (DM), Shared Tree Mode (ST) and Bidirectional Shared Tree Support (BST) as the multicast routing protocols for the experiment. Node 0 is a UDP source for group 0 and node 2 is the source for group 1. The sources will start transmission at time 0.05. Nodes 3 and 4 will join the multicast group0 at times 0.10 and 0.12, respectively. Node 3 will leave the multicast group at 0.5, and then join group1 at 0.6. The execution will terminate at 0.8. Compare all the 4 multicast protocols using PDR, throughput, delay.

#### DM
CBR packets sent: 235
CBR packets received: 235
CBR packets delivery ratio :	 100.000000
End to end delay of packets received:	 0.00669274
Throughput:			 159394

#### CM
CBR packets sent: 110
CBR packets received: 110
CBR packets delivery ratio :	 100.000000
End to end delay of packets received:	 0.00668
Throughput:			 107014
