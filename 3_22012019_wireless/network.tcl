
set val(chan)           Channel/WirelessChannel    ;# channel type
set val(prop)           Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)          Phy/WirelessPhy            ;# network interface type
set val(mac)            Mac/802_11                 ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq
set val(nn)             10                          ;# number of mobilenodes
set val(rp)             DSDV                       ;# routing protocol

# Initialize Global Variables
set ns_		[new Simulator]
$ns_ use-newtrace
set tracefd     [open simple.tr w]
$ns_ trace-all $tracefd
set namfile [open simple.nam w]
$ns_ namtrace-all-wireless $namfile 500 500
set topo       [new Topography]

$topo load_flatgrid 500 500

create-god $val(nn)

$ns_ node-config -adhocRouting $val(rp) \
	-llType $val(ll) \
	-macType $val(mac) \
	-ifqType $val(ifq) \
	-ifqLen $val(ifqlen) \
	-antType $val(ant) \
	-propType $val(prop) \
	-phyType $val(netif) \
	-channelType $val(chan) \
	-topoInstance $topo \
	-agentTrace ON \
	-routerTrace ON \
	-macTrace OFF \
	-movementTrace OFF			
			 
for {set i 0} {$i < $val(nn) } {incr i} {
		set node_($i) [$ns_ node]	
		$node_($i) random-motion 0		;# disable random motion
}

#place the ten nodes
for {set i 1} {$i < $val(nn)-1 } { incr i } {
    set xx [expr rand()*500]
    set yy [expr rand()*500]
    $node_($i) set X_ $xx
    $node_($i) set Y_ $yy
    $node_($i) set Z_ 0.0

    $ns_ at 0.0 "$node_($i) setdest $xx $yy 0.0"
}
$node_(0) set X_ 0.0
$node_(0) set Y_ 0.0
$node_(0) set Z_ 0.0
$ns_ at 0.0 "$node_(0) setdest $xx $yy 0.0"
$node_(9) set X_ 300.0
$node_(9) set Y_ 450.0
$node_(9) set Z_ 0.0
$ns_ at 0.0 "$node_(9) setdest $xx $yy 0.0"

# Setup traffic flow between nodes
# TCP connections between node_(0) and node_(9)
set tcp [new Agent/TCP]
$tcp set class_ 2
set sink [new Agent/TCPSink]
$ns_ attach-agent $node_(0) $tcp
$ns_ attach-agent $node_(9) $sink
$ns_ connect $tcp $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp

$ns_ at 1.0 "$ftp start" 
$ns_ at 101.0 "$ftp stop" 

 $ns_ at 50.0 "$node_(1) setdest 25.0 20.0 15.0"
# $ns_ at 10.0 "$node_(0) setdest 20.0 18.0 1.0"
# # Node_(1) then starts to move away from node_(0)
# $ns_ at 100.0 "$node_(1) setdest 490.0 480.0 15.0" 
# Tell nodes when the simulation ends
for {set i 0} {$i < $val(nn) } {incr i} {
    $ns_ at 150.0 "$node_($i) reset";
}
$ns_ at 150.0 "stop"
$ns_ at 150.01 "puts \"NS EXITING...\" ; $ns_ halt"

proc stop {} {
    global ns_ tracefd
    $ns_ flush-trace
    close $tracefd
    exec nam simple.nam
}

puts "Starting Simulation..."
$ns_ run

