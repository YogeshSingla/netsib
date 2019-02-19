#Initialization
BEGIN {
	udp_send = 0;
	udp_recv = 0;
	#num_nodes = 0;
	pdr = 0;

	num_nodes = 0;

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
if($1=="M") {num_nodes++;}
#Calculating packet delivery ratio
if($1=="s" && $19=="AGT" && $35=="cbr") {udp_send++;}
if($1=="r" &&  $19=="AGT" && $35=="cbr") {udp_recv++;}

time = $3;
packet_id = $41;

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

#energy consumption
node_energy = $17;

if($19=="AGT" && $35== "cbr") {
	if(start_t==-1) {
	energy_consumed[node_id] = 0;
	start_energy[node_id] = node_energy;
	}
	energy_consumed[node_id] = energy_consumed[node_id] + ( start_energy[node_id] - node_energy);
	start_energy[node_id] = node_energy;

	final_energy[node_id] = node_energy;
}



}

#Output
END {
	#num_nodes++;
	pdr = (udp_recv/udp_send)*100;
	print "Num node:\t", num_nodes;
	print "PDR:\t", pdr;
	print "recv:\t" udp_recv;
	print "send:\t" udp_send;
	
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

	print "Transmission start time:\t", start_t
	print "Transmission end time:\t\t", end_t	
	print "Total transmission time in seconds: ",(end_t-start_t)
	print "Throughput:\t\t\t",((packet_size*8)/(end_t-start_t))

	total_energy = 0;
	initial_energy = 3.4;

	for(i in energy_consumed) {
	
		total_energy = total_energy + energy_consumed[i];

		total_energy_c = total_energy_c + (initial_energy - final_energy[i]);
	}

	print "\nPerformance:\n"
	print "PDR:\t", pdr;
	print "End to end delay of packets received:\t",avg_end_to_end_delay
	print "Throughput:\t\t\t",((packet_size*8)/(end_t-start_t))
	print "Energy consumed:\t" ,total_energy_c
	print "\n"
}
#Initialization
BEGIN {
	udp_send = 0;
	udp_recv = 0;
	#num_nodes = 0;
	pdr = 0;

	num_nodes = 0;

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
if($1=="M") {num_nodes++;}
#Calculating packet delivery ratio
if($1=="s" && $19=="AGT" && $35=="cbr") {udp_send++;}
if($1=="r" &&  $19=="AGT" && $35=="cbr") {udp_recv++;}

time = $3;
packet_id = $41;

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

#energy consumption
node_energy = $17;

if($19=="AGT" && $35== "cbr") {
	if(start_t==-1) {
	energy_consumed[node_id] = 0;
	start_energy[node_id] = node_energy;
	}
	energy_consumed[node_id] = energy_consumed[node_id] + ( start_energy[node_id] - node_energy);
	start_energy[node_id] = node_energy;

	final_energy[node_id] = node_energy;
}



}

#Output
END {
	#num_nodes++;
	pdr = (udp_recv/udp_send)*100;
	print "Num node:\t", num_nodes;
	print "PDR:\t", pdr;
	print "recv:\t" udp_recv;
	print "send:\t" udp_send;
	
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

	print "Transmission start time:\t", start_t
	print "Transmission end time:\t\t", end_t	
	print "Total transmission time in seconds: ",(end_t-start_t)
	print "Throughput:\t\t\t",((packet_size*8)/(end_t-start_t))

	total_energy = 0;
	initial_energy = 3.4;

	for(i in energy_consumed) {
	
		total_energy = total_energy + energy_consumed[i];

		total_energy_c = total_energy_c + (initial_energy - final_energy[i]);
	}

	print "\nPerformance:\n"
	print "PDR:\t", pdr;
	print "End to end delay of packets received:\t",avg_end_to_end_delay
	print "Throughput:\t\t\t",((packet_size*8)/(end_t-start_t))
	print "Energy consumed:\t" ,total_energy_c
	print "\n"
}
