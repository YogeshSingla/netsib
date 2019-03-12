 #This example is to demonstrate the multicast routing protocol.
set ns [new Simulator -multicast on]
#Turn on Tracing
set tf [open q2.tr w]
$ns trace-all $tf

# Turn on nam Tracing
set fd [open mcast.nam w]
$ns namtrace-all $fd

# Create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]

# Create links with DropTail Queues
$ns duplex-link $n0 $n1 1.0Mb 5ms DropTail
$ns duplex-link $n1 $n2 1.0Mb 5ms DropTail
$ns duplex-link $n1 $n3 1.0Mb 5ms DropTail
$ns duplex-link $n1 $n4 1.0Mb 5ms DropTail


$ns duplex-link-op $n1 $n4 orient up
$ns duplex-link-op $n1 $n2 orient right
$ns duplex-link-op $n1 $n3 orient down
$ns duplex-link-op $n1 $n0 orient left


# Routing protocol: say distance vector
#Protocols: CtrMcast, DM, ST, BST
#Dense Mode protocol is supported in this example
ST set RP_($group) $n0
set mproto ST
set mrthandle [$ns mrtproto $mproto {}]

# Set two groups with group addresses
set group1 [Node allocaddr]
set group2 [Node allocaddr]

# UDP Transport agent for the traffic source for group1
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
$udp0 set dst_addr_ $group1
$udp0 set dst_port_ 0
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp0

# Transport agent for the traffic source for group2
set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1
$udp1 set dst_addr_ $group2
$udp1 set dst_port_ 0
set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $udp1

# Create receiver to accept the packets
set rcvr1 [new Agent/Null]
$ns attach-agent $n3 $rcvr1
$ns at 0.10 "$n3 join-group $rcvr1 $group1"
set rcvr2 [new Agent/Null]
$ns attach-agent $n6 $rcvr2
$ns at 0.12 "$n4 join-group $rcvr2 $group1"


#The nodes are leaving the group at specified times
$ns at 0.5 "$n3 leave-group $rcvr1 $group1"
$ns at 0.6 "$n3 join-group $rcvr1 $group2"

# Schedule events

$ns at 0.5 "$cbr1 start"
$ns at 0.8 "$cbr1 stop"
$ns at 0.5 "$cbr2 start"
$ns at 0.8 "$cbr2 stop"

#post-processing

$ns at 1.0 "finish"
proc finish {} {
  global ns tf
   $ns flush-trace
   close $tf
   exec nam mcast.nam &
   exit 0
}

$ns set-animation-rate 3.0ms
$ns run