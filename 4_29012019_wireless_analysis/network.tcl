
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
set val(max_x)			100							;# grid size x
set val(max_y)			100							;# grid size y

# Initialize Global Variables
set ns_		[new Simulator]
$ns_ use-newtrace
set tracefd     [open out.tr w]
$ns_ trace-all $tracefd
set namfile [open out.nam w]
$ns_ namtrace-all-wireless $namfile max_x max_y
set topo       [new Topography]

$topo load_flatgrid max_x max_y

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
		#$node_($i) random-motion 0		;# disable random motion
}

#place the ten nodes
for {set i 2} {$i < $val(nn) } { incr i } {
    set xx [expr rand()*$val(max_x)]
    set yy [expr rand()*$val(max_y)]
    $node_($i) set X_ $xx
    $node_($i) set Y_ $yy
    $node_($i) set Z_ 0.0

    $ns_ at 0.0 "$node_($i) setdest $xx $yy 0.0"
}

$node_(0) set X_ 0.0
$node_(0) set Y_ 0.0
$node_(0) set Z_ 0.0
#$ns_ at 0.0 "$node_(0) setdest $xx $yy 0.0"
$node_(1) set X_ 90.0
$node_(1) set Y_ 90.0
$node_(1) set Z_ 0.0
#$ns_ at 0.0 "$node_(1) setdest $xx $yy 0.0"

#setup a UDP connection
set udp [new Agent/UDP]
$ns_ attach-agent $node_(0) $udp
set null [new Agent/Null]
$ns_ attach-agent $node_(1) $null
$ns_ connect $udp $null
$udp set fid_ 2
#setup a CBR over UDP connection
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR
$cbr set packet_size_ 512
$cbr set rate_ 1.00Mb
$cbr set random_ false

$ns_ at 1.0 "$cbr start" 
$ns_ at 101.0 "$cbr stop" 

# nodes are static so not setdest required
#$ns_ at 50.0 "$node_(1) setdest 25.0 20.0 1.0"
#$ns_ at 10.0 "$node_(0) setdest 20.0 18.0 1.0"
#$ns_ at 90.0 "$node_(1) setdest 90.0 80.0 1.0" 
# Tell nodes when the simulation ends
# for {set i 0} {$i < $val(nn) } {incr i} {
#     $ns_ at 150.0 "$node_($i) reset";
# }
$ns_ at 110.0 "stop"
$ns_ at 110.01 "puts \"NS EXITING...\" ; $ns_ halt"

proc stop {} {
    global ns_ tracefd
    $ns_ flush-trace
    close $tracefd
    exec nam out.nam
}

puts "Starting Simulation..."
$ns_ run

