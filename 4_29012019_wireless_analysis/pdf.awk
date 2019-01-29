BEGIN {
        sendLine = 0;
        recvLine = 0;
        fowardLine = 0;

        seqno = -1;    
        count = 1;

        test = 0;
}

{
    if($46 == "-Pi"){
    	#packet sent
    	if($1 == "s" && seqno < $47) {
          seqno = $47;
          start_time[$47] = $3;
          test = $47;
    	}
    	#packet recieved
    	if($1 == "r" && seqno < $47) {
          seqno = $47;
          end_time[$47] = $3;

    	}
    	#packet dropped
    	if($1 == "d" && seqno < $47) {
          seqno = $47;
          end_time[$47] = -1;
    	} 
    }   
}

 
$0 ~/^s.* AGT/ {
        sendLine ++ ;
}
 
$0 ~/^r.* AGT/ {
        recvLine ++ ;
}
 
$0 ~/^f.* RTR/ {
        fowardLine ++ ;
}
 
END {
        printf "cbr s:%d r:%d, r/s Ratio:%.4f, f:%d \n", sendLine, recvLine, (recvLine/sendLine),fowardLine;

        for(i=0; i<=seqno; i++) {
          if(end_time[i] > 0) {
              delay[i] = end_time[i] - start_time[i];
              print delay[i];
              count++;
    	}
          else{
                  delay[i] = -1;
            }
    }
    for(i=0; i<=seqno; i++) {
          if(delay[i] > 0) {
              n_to_n_delay = n_to_n_delay + delay[i];
        }         
    }
	print "count %d", count;
   	n_to_n_delay = n_to_n_delay/count;
    print "Average End-to-End Delay    = " n_to_n_delay * 1000 " ms";
    print "\n",test;
}
 