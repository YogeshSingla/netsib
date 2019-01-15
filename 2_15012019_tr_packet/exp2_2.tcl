#exp2_2
#question
# Write simulation programs for univast routing and multicast routing using 5 nodes

#create ns object
set ns [new Simulator]
#set ns object to multicast routing
$ns multicast

#all events will be traced in a trace file
set tr [open exp2_2.tr w]
$ns trace-all $tr

#nam file will be used in visualisation
set namtr [open exp2_2.nam w]
$ns namtrace-all $namtr

#allcoate multicast address to group
set group [Node allocaddr]

#create 6 nodes of the network
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]

#droptail is a type of queue
#here we set up conenctions between the nodes as per the network specification
# format: $ns duplex-link node1 node2 bandwidth delay queue-type.
$ns duplex-link $n0 $n1 2Mb 10ms DropTail
$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n0 $n3 300kb 100ms DropTail
$ns duplex-link $n0 $n4 300kb 100ms DropTail

# describe nam network display
#$ns duplex-link-op $n2 $n3 orient right
#$ns duplex-link-op $n2 $n0 orient left-up
#$ns duplex-link-op $n2 $n1 orient left-down
#$ns duplex-link-op $n3 $n4 orient right-up
#$ns duplex-link-op $n3 $n5 orient right-down

# configure multicast protocol;
#DM set CacheMissMode dvmrp
set mproto DM                                
# all nodes will contain multicast protocol agents;
set mrthandle [$ns mrtproto $mproto]         


# set udp connection
set udp0 [new Agent/UDP]
# setting class to color code later
$udp0 set class_ 1
$ns attach-agent $n0 $udp0
#set null0 [new Agent/Null]
#$ns attach-agent $n5 $null0
#$ns connect $udp0 $null0
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
$udp0 set dst_addr_ $group
$udp0 set dst_port_ 0
#$cbr0 set random_ false

#$cbr0 set packetSize_ 512 #unit - bytes
#$cbr0 set rate_ 200Kb #rate at which the CBR application is generating the packets


#color traffic
$ns color 1 Red
#$ns color 2 Blue

# simluation timings
set rcvr [new Agent/LossMonitor]      
# joining and leaving the group;
$ns at 0.0 "$n1 join-group $rcvr $group"
$ns at 0.0 "$n2 join-group $rcvr $group"
$ns at 0.0 "$n3 join-group $rcvr $group"
$ns at 0.0 "$n4 join-group $rcvr $group"
$ns at 0.5 "$n1 leave-group $rcvr $group"
$ns at 0.7 "$n2 leave-group $rcvr $group"
$ns at 1.5 "$n3 leave-group $rcvr $group"
$ns at 1.6 "$n1 join-group $rcvr $group"
$ns at 1.7 "$n4 leave-group $rcvr $group"



#$ns at 0.1 "$n3 join-group $rcvr $group"
#$ns at 1.3 "$n2 join-group $rcvr $group"
#$ns at 1.6 "$n3 join-group $rcvr $group"
#$ns at 1.9 "$n3 leave-group $rcvr $group"
#$ns at 0.3 "$n4 join-group $rcvr $group"
#$ns at 0.5 "$n4 leave-group $rcvr $group"

$ns at 0.1 "$cbr0 start"
$ns at 3.4 "$cbr0 stop"
$ns at 4.0 "finish"
proc finish {} {
        global ns
        $ns flush-trace
        exec nam exp2_2.nam &
        exit 0
}
$ns run
