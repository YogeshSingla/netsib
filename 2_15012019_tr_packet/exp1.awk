BEGIN{
	cbr_send = 0;
	cbr_recv = 0;
	ftp_send = 0;
	ftp_recv = 0;

	#test7 = 0;
	#test8 = 0;
}
{
	if($1=="+" && $3 == 3 && $4==0 && $5 == "cbr"){cbr_send++;}
	if($1=="r" && $3 == 1 && $4==5 && $5 == "cbr"){cbr_recv++;}
	if($1=="+" && $3 == 2 && $4==0 && $5 == "tcp"){ftp_send++;}
	if($1=="r" && $3 == 1 && $4==4 && $5 == "tcp"){ftp_recv++;}

	#test7 = $7;
	#test8 = $8;

}
END{
	print "No of CBR packets Send\t\t" cbr_send; 
	print "No of CBR packets Receive\t" cbr_recv; 
	print "No of FTP packets Send\t\t" ftp_send; 
	print "No of FTP packets Receive\t" ftp_recv; 

	#print test7;
	#print test8;
}