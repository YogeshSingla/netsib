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
Phy/WirelessPhy set CSThresh_ 1.92278e-9 ;
Phy/WirelessPhy set RXThresh_ 1.92278e-9 ;
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
$ns_ namtrace-all-wireless $namfile 501 501 
set topo       [new Topography]

$topo load_flatgrid 501 501 

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
    # -energyModel "EnergyModel" \
    #     -initialEnergy 3.4 \
    #     -txPower 31.32e-3 \
    #     -rxPower 35.28e-3 \
    #     -idlePower 712e-6 \
    #     -sleepPower 144e-9 \
	-agentTrace ON \
	-routerTrace ON \
	-macTrace OFF \
	-movementTrace OFF			
			 
for {set i 0} {$i < $val(nn)} {incr i} {
		set node_($i) [$ns_ node]	
		$node_($i) random-motion 1		;# disable random motion
}

set distance_between_nodes 50
set epi -0.00000000001
for {set i 0} {$i < $val(nn) - 1} { incr i } {
    set yy [expr ($i/10)*$distance_between_nodes + $epi + 50]
    set xx [expr ($i%10)*$distance_between_nodes + $epi + 50]

    $node_($i) set X_ $xx
    $node_($i) set Y_ $yy
    $node_($i) set Z_ 0.0

    $ns_ at 0.0 "$node_($i) setdest $xx $yy 0.0"
}

$node_(50) set X_ 2.0
$node_(50) set Y_ 2.0
$node_(50) set Z_ 0.0
$ns_ at 0.0 "$node_(50) setdest $xx $yy 0.0"

$ns_ at 0.2 "$node_(50) setdest 300.0 250.0 25.0" 
$ns_ at 49.0 "$node_(50) setdest 500.0 2.0 50.0"

#setup a UDP connection
#set null [new Agent/Null]
set udp_(50) [new Agent/UDP]
$ns_ attach-agent $node_(50) $udp_(50)
set cbr_(50) [new Application/Traffic/CBR]
$cbr_(50) attach-agent $udp_(50)
$cbr_(50) set type_ CBR
$cbr_(50) set packet_size_ 512
$cbr_(50) set rate_ 0.5Mb
$cbr_(50) set random_ false
for {set i 45} {$i == 45 } { incr i } {
	set null_($i) [new Agent/Null]
	#set udp_($i) [new Agent/UDP]
	$ns_ attach-agent $node_($i) $null_($i)
	#$ns_ attach-agent $node_(2) $udp
	#set null_($i) [new Agent/Null]
	#$ns_ attach-agent $node_(1) $null_($i)
	#$ns_ connect $udp_($i) $null_($i)
	$ns_ connect $udp_(50) $null_($i)
	$null_($i) set fid_ 2
	#setup a CBR over UDP connection
	# set cbr_($i) [new Application/Traffic/CBR]
	# $cbr_($i) attach-agent $udp_($i)
	# $cbr_($i) set type_ CBR
	# $cbr_($i) set packet_size_ 512
	# $cbr_($i) set rate_ 200Kb
	# $cbr_($i) set random_ false

	$ns_ at 0.0 "$cbr_(50) start" 
	$ns_ at 100.0 "$cbr_(50) stop" 
}



for {set i 0} {$i < $val(nn) } {incr i} {
    $ns_ at 100.1 "$node_($i) reset";
}
$ns_ at 100.0 "stop"
$ns_ at 100.0 "puts \"NS EXITING...\" ; $ns_ halt"

proc stop {} {
    global ns_ tracefd
    $ns_ flush-trace
    close $tracefd
    #exec nam out.nam
}

puts "Starting Simulation..." 
$ns_ run
puts "Number of nodes: $val(nn)"

