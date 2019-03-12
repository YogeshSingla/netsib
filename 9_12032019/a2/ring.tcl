#Create a simulator object
set ns [new Simulator]
$ns use-newtrace

#Routing Protocol used is Distance Vector
$ns rtproto DV
#Open the nam trace file
set tr [open flow.tr w]
$ns trace-all $tr

set tr [open out.nam w]
$ns namtrace-all $tr


#Create six nodes
set n6 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

#Create links between the nodes
$ns duplex-link $n6 $n1 0.5Mb 5ms DropTail
$ns duplex-link $n1 $n2 0.5Mb 5ms DropTail
$ns duplex-link $n2 $n3 0.5Mb 5ms DropTail
$ns duplex-link $n3 $n4 0.5Mb 5ms DropTail
$ns duplex-link $n4 $n5 0.5Mb 5ms DropTail
$ns duplex-link $n5 $n6 0.5Mb 5ms DropTail

$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link-op $n2 $n3 orient right-down
$ns duplex-link-op $n3 $n4 orient down
$ns duplex-link-op $n4 $n5 orient left-down
$ns duplex-link-op $n5 $n6 orient left-up
$ns duplex-link-op $n6 $n1 orient up


##========================================================
##========================================================
##========================================================
set udp0 [new Agent/UDP]
$ns attach-agent $n1 $udp0
set null [new Agent/Null]
$ns attach-agent $n2 $null
$ns connect $udp0 $null
$udp0 set fid_ 2

#setup a CBR over UDP connection
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
$cbr0 set type_ CBR
$cbr0 set packet_size_ 512
$cbr0 set rate_ 0.05Mb
$cbr0 set random_ false


#setup a UDP connection
set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1
set null [new Agent/Null]
$ns attach-agent $n3 $null
$ns connect $udp1 $null
$udp1 set fid_ 2

#setup a CBR over UDP connection
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$cbr1 set type_ CBR
$cbr1 set packet_size_ 512
$cbr1 set rate_ 0.05Mb
$cbr1 set random_ false

#setup a UDP connection
set udp2 [new Agent/UDP]
$ns attach-agent $n1 $udp2
set null [new Agent/Null]
$ns attach-agent $n4 $null
$ns connect $udp2 $null
$udp2 set fid_ 2

#setup a CBR over UDP connection
set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $udp2
$cbr2 set type_ CBR
$cbr2 set packet_size_ 512
$cbr2 set rate_ 0.05Mb
$cbr2 set random_ false


#setup a UDP connection
set udp3 [new Agent/UDP]
$ns attach-agent $n1 $udp3
set null [new Agent/Null]
$ns attach-agent $n5 $null
$ns connect $udp3 $null
$udp3 set fid_ 2

#setup a CBR over UDP connection
set cbr3 [new Application/Traffic/CBR]
$cbr3 attach-agent $udp3
$cbr3 set type_ CBR
$cbr3 set packet_size_ 512
$cbr3 set rate_ 0.05Mb
$cbr3 set random_ false


#setup a UDP connection
set udp4 [new Agent/UDP]
$ns attach-agent $n1 $udp4
set null [new Agent/Null]
$ns attach-agent $n6 $null
$ns connect $udp4 $null
$udp4 set fid_ 2

#setup a CBR over UDP connection
set cbr4 [new Application/Traffic/CBR]
$cbr4 attach-agent $udp4
$cbr4 set type_ CBR
$cbr4 set packet_size_ 512
$cbr4 set rate_ 0.05Mb
$cbr4 set random_ false
##========================================================
##========================================================
##========================================================

# for {set i 2} {$i < 7} { incr i } {
# set udp_($i) [new Agent/UDP]
# $ns attach-agent $n($i) $udp_($i)
# set null [new Agent/Null]
# $ns attach-agent $n(0) $null
# $ns connect $udp_($i) $null

# set cbr_($i) [new Application/Traffic/CBR]
# $cbr_($i) attach-agent $udp_($i)
# $cbr_($i) set type_ CBR
# $cbr_($i) set packet_size_ 512
# $cbr_($i) set rate_ 0.1mb
# $cbr_($i) set random_ false
# }
#scheduling the events
$ns at 0.01 "$cbr0 start"
$ns at 0.01 "$cbr1 start"
$ns at 0.01 "$cbr2 start"
$ns at 0.01 "$cbr3 start"
$ns at 0.01 "$cbr4 start"

$ns rtmodel-at 0.4 down $n2 $n3

$ns at 1.0 "$cbr0 stop"
$ns at 1.0 "$cbr1 stop"
$ns at 1.0 "$cbr2 stop"
$ns at 1.0 "$cbr3 stop"
$ns at 1.0 "$cbr4 stop"

$ns at 2.0 "$ns halt"


#Run the simulation
$ns run