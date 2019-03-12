BEGIN{
	cbr_send = 0;
	cbr_recv = 0;

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
{
	packet_id = $12;
	time = $2;

	if ($1 == "+" && $3 =="0" && $5 == "cbr"){cbr_send++;}
	if ($1 == "r" && $3 =="4" && $4 =="5" && $5 == "cbr"){cbr_recv++;}
	if ($1 == "r" && $3 =="3" && $4 =="4" && $5 == "cbr"){cbr_recv++;}
    if ($1 == "r" && $4 =="3" && $3 =="2" && $5 == "cbr"){cbr_recv++;}
    if ($1 == "r" && $4 =="2" && $3 =="1" && $5 == "cbr"){cbr_recv++;}
    if ($1 == "r" && $4 =="1" && $3 =="0" && $5 == "cbr"){cbr_recv++;}

	if($1=="+" && $5== "cbr") {
		start_time[packet_id] = time;
		if(start_t==-1) {
			start_t = time;
		}
	}

	if($1=="r" && $5== "cbr") {
		end_time[packet_id] = time;
		end_t = time;
		packet_size += $6;
	} 
	else {
		end_time[packet_id] = -1;
	}

}

END{
printf("\nCBR packets sent: %d",cbr_send);
printf("\nCBR packets received: %d", cbr_recv);
printf("\nCBR packets delivery ratio :\t %f",(cbr_recv/cbr_send)*100);

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
print "\nEnd to end delay of packets received:\t",avg_end_to_end_delay
print "Throughput:\t\t\t",((packet_size)/(end_t-start_t))

printf("\n");
}
