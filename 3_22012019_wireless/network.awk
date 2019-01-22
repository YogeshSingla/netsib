BEGIN{
	cbr_send = 0;
	cbr_recv = 0;
	ftp_send = 0;
	ftp_recv = 0;
	ftp_total_bytes_recv = 0;
	ftp_packet_recieve_time = 0;
	ftp_packet_send_time = 0;
}
{
	#if($1=="+" && $3 == 1 && $4==2 && $5 == "cbr"){cbr_send++;}
	#if($1=="r" && $3 == 3 && $4==5 && $5 == "cbr"){cbr_recv++;}
	if($1=="s" && $3 == "_0_" && $7 == "tcp"){ftp_send++;}
	if($1=="r" && $3 == "_9_" && $7 == "tcp"){
		ftp_recv++;
		ftp_total_bytes_recv = ftp_total_bytes_recv + $8;
	}
	if($1=="s" && $3 == "_0_"  && $6 == 1060){
		ftp_packet_send_time = $2;
	}
	if($1=="r" && $3 == "_9_"  && $6 == 1060){
		ftp_packet_recieve_time = $2;
	}
	

	#test7 = $7;
	#test8 = $8;

}
END{
	#print "No of CBR packets Send\t\t" cbr_send; 
	#print "No of CBR packets Receive\t" cbr_recv;

	print "No of FTP packets Send\t\t" ftp_send; 
	print "No of FTP packets Receive\t" ftp_recv;
	print "Packet Delivery Ratio\t" ftp_recv/ftp_send; 
	print "Throughput (bps)\t" (ftp_total_bytes_recv*8)/100;
	print "end-to-end delay for 10th packet \t" (ftp_packet_recieve_time - ftp_packet_send_time) ;
	#print test7;
	#print test8;
}