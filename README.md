## Write a tcl script for AODV, DSDV and DSR protocol by using the following parameters given below. Compare the protocol performance in terms of PDR, throughput and end to end delay ( For graph plotting take nodes - (10, 20, 30, 40)

The pattern contain nodes placed in the form of a matrix with an area covering 500 m  * 250 m. 50 nodes are placed at every 50m distance in both X and Y directions. 

Node 50 ( source node) - (2,2)
Node 0 - (50,50)
Base station - (250,150)

Give some mobility to node 50 -
$ns at 0.2 "$node_(50) setdest 300.0 250.0 25.0" 
$ns at 49.0 "$node_(50) setdest 500.0 2.0 50.0"
