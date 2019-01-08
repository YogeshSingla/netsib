set ns [new Simulator]

#all events will be traced in that file
set tr [open exp2.tr w]
$ns trace-all $tr

#nam file will be used in visualisation
set namtr [open exp2.nam w]
$ns namtrace-all $namtr

#create 5 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

#droptail is a type of queue
$ns duplex-link $n0 $n1 10Mb 5ms DropTail
$ns duplex-link $n2 $n0 10Mb 5ms DropTail
$ns duplex-link $n3 $n0 10Mb 5ms DropTail
$ns duplex-link $n4 $n1 10Mb 5ms DropTail
$ns duplex-link $n5 $n1 10Mb 5ms DropTail

$ns duplex-link-op $n0 $n1 orient right
$ns duplex-link-op $n0 $n2 orient left-up
$ns duplex-link-op $n0 $n3 orient left-down
$ns duplex-link-op $n1 $n4 orient right-up
$ns duplex-link-op $n1 $n5 orient right-down

set udp0 [new Agent/UDP]
$ns attach-agent $n3 $udp0

set null0 [new Agent/Null]
$ns attach-agent $n5 $null0

$ns connect $udp0 $null0

#constant bitrate
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
$cbr0 set packetSize_ 512
$cbr0 set rate_ 200Kb

$ns at 1.0 "$cbr0 start"

$ns at 5.0 "$cbr0 stop"


$ns at 50.0 "$ns halt"
$ns run
