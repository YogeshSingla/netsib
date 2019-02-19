if {$argc != 1} {
       error "\nCommand: ns exp1.tcl <no.of.nodes>\n\n "
}

set val(chan)           Channel/WirelessChannel    ;# channel type
#set val(prop)           Propagation/TwoRayGround   ;# radio-propagation model
Propagation/Shadowing set pathlossExp_ 3.5  ;# path loss exponent
Propagation/Shadowing set std_db_ 4.0       ;# shadowing deviation (dB)
Propagation/Shadowing set dist0_ 0.5        ;# reference distance (m)
Propagation/Shadowing set seed_ 0           ;# seed for RNG
set val(prop)           Propagation/Shadowing   ;# radio-propagation model
Phy/WirelessPhy set CSThresh_ 1.92278e-6 ;#10m
Phy/WirelessPhy set RXThresh_ 1.92278e-6 ;#10m
set val(netif)          Phy/WirelessPhy/802_15_4            ;# network interface type
set val(mac)            Mac/802_15_4              ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq
set val(nn)             [lindex $argv 0]                         ;# number of mobilenodes
set val(rp)             AODV                       ;# routing protocol

# Initialize Global Variables
set ns_		[new Simulator]
$ns_ use-newtrace
set tracefd     [open [lindex $argv 0]_out.tr w]
$ns_ trace-all $tracefd
set namfile [open out.nam w]
$ns_ namtrace-all-wireless $namfile 20 20 
set topo       [new Topography]

$topo load_flatgrid 20 20 

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
    -energyModel "EnergyModel" \
        -initialEnergy 3.4 \
        -txPower 31.32e-3 \
        -rxPower 35.28e-3 \
        -idlePower 712e-6 \
        -sleepPower 144e-9 \
	-agentTrace ON \
	-routerTrace ON \
	-macTrace OFF \
	-movementTrace OFF			
			 
for {set i 0} {$i < $val(nn)} {incr i} {
		set node_($i) [$ns_ node]	
		$node_($i) random-motion 1		;# disable random motion
}

set distance_between_nodes 3
set epi 0.00000000001
for {set i 1} {$i < $val(nn) } { incr i } {
    set yy [expr ($i/7)*$distance_between_nodes + $epi]
    set xx [expr ($i%7)*$distance_between_nodes + $epi]

    $node_($i) set X_ $xx
    $node_($i) set Y_ $yy
    $node_($i) set Z_ 0.0

    $ns_ at 0.0 "$node_($i) setdest $xx $yy 0.0"
}

$node_(0) set X_ 0.0
$node_(0) set Y_ 0.0
$node_(0) set Z_ 0.0
$ns_ at 0.0 "$node_(0) setdest $xx $yy 0.0"

#setup a UDP connection
set null [new Agent/Null]
$ns_ attach-agent $node_(0) $null
for {set i 2} {$i < $val(nn) } { incr i } {
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
	$cbr_($i) set packet_size_ 100
	$cbr_($i) set rate_ 20Kb
	$cbr_($i) set random_ false

	$ns_ at 11.0 "$cbr_($i) start" 
	$ns_ at 71.0 "$cbr_($i) stop" 
}



for {set i 0} {$i < $val(nn) } {incr i} {
    $ns_ at 71.0 "$node_($i) reset";
}
$ns_ at 71.0 "stop"
$ns_ at 71.0 "puts \"NS EXITING...\" ; $ns_ halt"

proc stop {} {
    global ns_ tracefd
    $ns_ flush-trace
    close $tracefd
    #exec nam out.nam
}

puts "Starting Simulation..." 
$ns_ run
puts "Number of nodes: $val(nn)"

