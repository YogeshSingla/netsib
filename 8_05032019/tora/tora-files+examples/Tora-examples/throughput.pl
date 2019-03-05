# http://stuweb.ee.mtu.edu/~ljialian/CRCN%20user%20code%203/CRCN%20user%20code%203/throughput.pl
#
# type: perl throughput.pl <trace file> <granularity>   >    output file
# for the trace file of NS2.29

$infile=$ARGV[0];
#$tonode=$ARGV[1];
#$granularity=$ARGV[2];
$granularity=$ARGV[1];

#we compute how many bytes were transmitted during time interval specified
#by granularity parameter in seconds
$sum=0;
$clock=0;

      open (DATA,"<$infile")
        || die "Can't open $infile $!";
  
    while (<DATA>) {
             @x = split(' ');

#column 1 is time 
if ($x[1]-$clock <= $granularity)
{
  #checking if the event corresponds to a reception 
  if ($x[0] eq 'r') 
  { 
    #checking if the packet has been successfully transmitted
    if ($x[3] eq 'AGT') 
    {
     #print STDOUT "$x[3]\n";
     #checking if the destination corresponds to arg 1
     #if ($x[2] != '_0_') 
     #{ 
       #print STDOUT "$x[2]\n";
       #checking if the packet type is TCP
       if ($x[6] eq 'tcp') 
      {
       $sum=$sum+$x[7];
      }
     #} #X[2]
    }#x[3]
  } #x[0]
} #x[1]
else
{   $throughput=$sum/$granularity;
    print STDOUT "$x[1] $throughput\n";
    $clock=$clock+$granularity;
    #$sum=0;

    while( $x[1] - $clock > $granularity )
          {
              $clock += $granularity; # shrink difference bet. timest. & counter
              print "$x[1] 0\n"; # print 0-line if no dataflow was recorded
          }

          $sum = $x[7]; # last paket size stored for usage in next round
}   

} #while
   $throughput=$sum/$granularity;
    print STDOUT "$x[1] $throughput\n";
    $clock=$clock+$granularity;
    $sum=$x[7];

    close DATA;
exit(0);
 
 
