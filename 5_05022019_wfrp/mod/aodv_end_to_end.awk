#Initialization
BEGIN {
	start_t = -1; #for calculating throughput
	end_t = 0;
	packet_size = 0; #in bytes
	packet_recv = 0; #for calculating average end to end delay
	total_end_to_end_delay = 0;
	avg_end_to_end_delay = 0;
	start = 0;
	end = 0;
	packet_duration = 0;
}

#Pattern Matching
{
	node_id = $9;
	time = $3;
	packet_id = $41;
if($1=="M") {num_nodes++;}
#Calculating packet delivery ratio
if($1=="r" &&  $19=="AGT" && $35=="cbr") {
	packet_size += $37;
}
#Calculating throughput
if($1=="s" && $19=="AGT" && $35== "cbr") {
	start_time[packet_id] = time;
	if(start_t==-1) {start_t = time;}
}
if($1=="r" && $19=="AGT" && $35== "cbr") {
	end_time[packet_id] = time;
	end_t = time;
} else {
	end_time[packet_id] = -1;
}
}

#Output
END {
	for(i in end_time) {
		start = start_time[i];
		end = end_time[i];
		packet_duration = end-start;
		if(packet_duration>0) { 
			total_end_to_end_delay += packet_duration; 
			packet_recv++; 
		}
	}
	avg_end_to_end_delay = total_end_to_end_delay/packet_recv;
	#print "Total number of packets received:\t",packet_recv
	print "End to end delay of packets received:\t",avg_end_to_end_delay
}
