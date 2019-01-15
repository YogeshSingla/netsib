## Understanding the tr file(wired network):

Example tr row:
- 1.69632 3 0 cbr 512 ------- 0 3.0 5.0 34 34

Annotated tr row:
-[1] 1.69632[2] 3[3] 0[4] cbr[5] 512[6] -------[7] 0[8] 3.0[9] 5.0[10] 34[11] 34[12]

[1] Five enque operations (indicated by \`\`+'' in the first column), four deque operations (indicated by \`\`-''), four receive events (indicated by\`\`r''), and one drop event.

[2] The simulated time (in seconds).

[3]\[4] The next two fields indicate between which two nodes tracing is happening. 

[5] The next field is a descriptive name for the the type of packet seen. 

[6] The next field is the packet's size, as encoded in its IP header.

[7] The next field contains the flags, which not used in this example. The flags are defined in the flags[] array in trace.cc. Four of the flags are used for ECN: \`\`E'' for Congestion Experienced (CE) and \`\`N'' for ECN-Capable-Transport (ECT) indications in the IP header, and \`\`C'' for ECN-Echo and \`\`A'' for Congestion Window Reduced (CWR) in the TCP header. For the other flags, \`\`P'' is for priority, and \`\`F'' is for TCP Fast Start.

[8] The next field gives the IP flow identifier field as defined for IP version 6.26.1. 

[9]\[10] The subsequent two fields indicate the packet's source and destination node addresses, respectively. 

[11] The following field indicates the sequence number.

[12] The last field is a unique packet identifier. Each new packet created in the simulation is assigned a new, unique identifier. 