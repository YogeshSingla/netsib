#Initialization
BEGIN {
	udp_send = 0;
	udp_recv = 0;
	num_nodes = 0;
	pdr = 0;
}

#Pattern Matching
{
	node_id = $9;
if($1=="M") {num_nodes++;}
#Calculating packet delivery ratio
if($1=="s" && $19=="AGT" && $35=="cbr") {udp_send++;}
if($1=="r" &&  $19=="AGT" && $35=="cbr") {udp_recv++;}
}

#Output
END {
	#num_nodes++;
	pdr = (udp_recv/udp_send)*100;
	print num_nodes, pdr
	print "recv:\t" udp_recv
	print "send:\t" udp_send
}
