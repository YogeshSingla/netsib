
set val(chan)           Channel/WirelessChannel    ;# channel type
set val(prop)           Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)          Phy/WirelessPhy            ;# network interface type
set val(mac)            Mac/802_11                 ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq
set val(nn)             50                         ;# number of mobilenodes
set val(rp)             AODV                       ;# routing protocol
set val(energymodel)   EnergyModel		    ;# Energy Model
set val(initialenergy) 100			    ;# value

# Initialize Global Variables
set ns_		[new Simulator]
$ns_ use-newtrace
set tracefd     [open out.tr w]
$ns_ trace-all $tracefd
set namfile [open out.nam w]
$ns_ namtrace-all-wireless $namfile 100 100
set topo       [new Topography]

$topo load_flatgrid 100 100

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
	-movementTrace OFF\
    -energyModel $val(energymodel) \
    -initialEnergy $val(initialenergy) \
    -rxPower 35.28e-3 \
    -txPower 31.32e-3 \
    -idlePower 712e-6 \
    -sleepPower 144e-9 			
			 
for {set i 0} {$i < $val(nn) } {incr i} {
		set node_($i) [$ns_ node]	
		$node_($i) random-motion 1		;# disable random motion
}

#place the ten nodes
for {set i 2} {$i < $val(nn) } { incr i } {
    set xx [expr rand()*100]
    set yy [expr rand()*100]
    $node_($i) set X_ $xx
    $node_($i) set Y_ $yy
    $node_($i) set Z_ 0.0

    $ns_ at 0.0 "$node_($i) setdest $xx $yy 0.0"
}
$node_(0) set X_ 0.0
$node_(0) set Y_ 0.0
$node_(0) set Z_ 0.0
$ns_ at 0.0 "$node_(0) setdest $xx $yy 0.0"
$node_(1) set X_ 90.0
$node_(1) set Y_ 90.0
$node_(1) set Z_ 0.0
$ns_ at 0.0 "$node_(1) setdest $xx $yy 0.0"

# Setup traffic flow between nodes
# TCP connections between node_(0) and node_(9)
# set tcp [new Agent/TCP]
# $tcp set class_ 2
# set sink [new Agent/TCPSink]
# $ns_ attach-agent $node_(0) $tcp
# $ns_ attach-agent $node_(2) $tcp
# $ns_ attach-agent $node_(3) $tcp
# $ns_ attach-agent $node_(1) $sink
# $ns_ connect $tcp $sink
# set ftp [new Application/FTP]
# $ftp attach-agent $tcp

# $ns_ at 1.0 "$ftp start" 
# $ns_ at 101.0 "$ftp stop" 

#setup a UDP connection
set null [new Agent/Null]
$ns_ attach-agent $node_(0) $null
for {set i 1} {$i < $val(nn) } { incr i } {
	set udp_($i) [new Agent/UDP]
	$ns_ attach-agent $node_($i) $udp_($i)
	#$ns_ attach-agent $node_(2) $udp
	#set null_($i) [new Agent/Null]
	#$ns_ attach-agent $node_(1) $null_($i)
	#$ns_ connect $udp_($i) $null_($i)
	$ns_ connect $udp_($i) $null
	$udp_($i) set fid_ 2
	#setup a CBR over UDP connection
	set cbr_($i) [new Application/Traffic/CBR]
	$cbr_($i) attach-agent $udp_($i)
	$cbr_($i) set type_ CBR
	$cbr_($i) set packet_size_ 512
	$cbr_($i) set rate_ 0.10Mb
	$cbr_($i) set random_ false

	$ns_ at 0.0 "$cbr_($i) start" 
	$ns_ at 100.0 "$cbr_($i) stop" 
}



for {set i 0} {$i < $val(nn) } {incr i} {
    $ns_ at 150.0 "$node_($i) reset";
}
$ns_ at 150.0 "stop"
$ns_ at 150.01 "puts \"NS EXITING...\" ; $ns_ halt"

proc stop {} {
    global ns_ tracefd
    $ns_ flush-trace
    close $tracefd
    #exec nam out.nam
}

puts "Starting Simulation..."
$ns_ run
puts "Number of nodes: $val(nn)"

