#Initialization
BEGIN {
	start_t = -1; #for calculating throughput
	end_t = 0;
	packet_size = 0; #in bytes
	packet_recv = 0; #for calculating average end to end delay
}

#Pattern Matching
{
	node_id = $9;
	time = $3;
if($1=="M") {num_nodes++;}
#Calculating packet delivery ratio
if($1=="r" &&  $19=="AGT" && $35=="cbr") {
	packet_size += $37;
}
#Calculating throughput
if($1=="s" && $19=="AGT" && $35== "cbr") {
	if(start_t==-1) {start_t = time;}
}
if($1=="r" && $19=="AGT" && $35== "cbr") {
	end_t = time;
}
}

#Output
END {
	print "Transmission start time:\t", start_t
	print "Transmission end time:\t\t", end_t	
	print "Total transmission time in seconds: ",(end_t-start_t)
	print "Throughput:\t\t\t",((packet_size*8)/(end_t-start_t))
}
