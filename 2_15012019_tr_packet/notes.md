##Lab : Day-2
### Overview
* tr packet format
* use of awk in analysing tr packet. each packet registers around 8 records in tr file. awk file can be used to analyse large files.

### AWK basics
#### Format
3 blocks:  
```
BEGIN {}
{}
END {}
```
#### Execution
	awk -f <filename.awk> <filename.tr>

### Files
exp1 : first network simulation of a 6 node network to analyse tcp and udp packet flow using awk
exp2 : similar to exp1 with different network parameters
exp2_2 : multicast routing in network

### Multicast
A distribution tree kind of structure is created in the simulation when dealing with multicast routing.  NS supports three types of multicast routing: Centralized Multicast Routing(CM), Dense Mode (DM), Shared Tree Mode (ST) and Bi directional Shared Tree Support (BST).

### Execution Steps
```
ns <filename>.tcl
nam <filename>.tr
awk -f <filename>.awk <filename>.tr
```

