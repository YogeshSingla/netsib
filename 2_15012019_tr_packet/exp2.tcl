#exp2
#question
# Write  a program for a simple network according to the follownig figures.
# n0 node connected to n4 by TCP and n1 node ocnnected to n5 by UDP.
# FIGURE
# 
#                                             n4
#  n0\                                        /   
#     \2mbps/10ms                     500kbps/  
#	   \                                40ms/
#      n2------(300kbps/100ms)------------n3
#      / ------(300kbps/100ms)------------\
#     /2mbps/10ms                    500kbps\
#    /                                   30ms\
#  n1                                        n5
#
# END OF FIGURE
#

#create ns object
set ns [new Simulator]

#all events will be traced in a trace file
set tr [open exp2.tr w]
$ns trace-all $tr

#nam file will be used in visualisation
set namtr [open exp2.nam w]
$ns namtrace-all $namtr

#create 6 nodes of the network
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

#droptail is a type of queue
#here we set up conenctions between the nodes as per the network specification
# format: $ns duplex-link node1 node2 bandwidth delay queue-type.
$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
#$ns duplex-link $n2 $n3 300kb 100ms DropTail
$ns simplex-link $n2 $n3 300kb 100ms DropTail
$ns simplex-link $n3 $n2 300kb 100ms DropTail
$ns duplex-link $n3 $n4 500kb 40ms DropTail
$ns duplex-link $n3 $n5 500kb 30ms DropTail

# describe nam network display
#$ns duplex-link-op $n2 $n3 orient right
#$ns duplex-link-op $n2 $n0 orient left-up
#$ns duplex-link-op $n2 $n1 orient left-down
#$ns duplex-link-op $n3 $n4 orient right-up
#$ns duplex-link-op $n3 $n5 orient right-down


# set udp connection
set udp0 [new Agent/UDP]
# setting class to color code later
$udp0 set class_ 1
$ns attach-agent $n1 $udp0
set null0 [new Agent/Null]
$ns attach-agent $n5 $null0
$ns connect $udp0 $null0
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
$cbr0 set packetSize_ 512 #unit - bytes
$cbr0 set rate_ 200Kb #rate at which the CBR application is generating the packets

# set tcp connection
set tcp0 [new Agent/TCP]
$tcp0 set class_ 2
$ns attach-agent $n0 $tcp0
$tcp0 set packetSize_ 512
$tcp0 set rate_ 200Kb
set sink0 [new Agent/TCPSink]
$ns attach-agent $n4 $sink0
$ns connect $tcp0 $sink0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

#color traffic
$ns color 1 Red
$ns color 2 Blue

# simluation timings
$ns at 0.1 "$cbr0 start"
$ns at 5.0 "$cbr0 stop"
$ns at 0.2 "$ftp0 start"
$ns at 5.0 "$ftp0 stop"
$ns at 10.0 "$ns halt"

$ns run
