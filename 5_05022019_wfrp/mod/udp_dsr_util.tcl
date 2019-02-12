#AODV static nodes
if {$argc != 1} {
       error "\nCommand: ns wireless1.tcl <no.of.mobile-nodes>\n\n "
}
# ======================================================================
# Define options
# ======================================================================
set val(chan)         Channel/WirelessChannel  ;# channel type
set val(prop)         Propagation/TwoRayGround ;# radio-propagation model
set val(ant)          Antenna/OmniAntenna      ;# Antenna type
set val(ll)           LL                       ;# Link layer type
set val(ifq)          Queue/DropTail/PriQueue  ;# Interface queue type
set val(ifqlen)       50                       ;# max packet in ifq
set val(netif)        Phy/WirelessPhy          ;# network interface type
set val(mac)          Mac/802_11               ;# MAC type
set val(rp)           DSR                      ;# ad-hoc routing protocol 
set val(nn)           [lindex $argv 0]         ;# number of mobilenodes

set ns    [new Simulator]

$ns use-newtrace
#color for udp connection
$ns color 0 red
$ns color 1 blue

set tracefd     [open [lindex $argv 0]nodes_udp_dsr.tr w]
$ns trace-all $tracefd

set namtracefd [open [lindex $argv 0]nodes_udp_dsr.nam w]
$ns namtrace-all-wireless $namtracefd 100 100

set topo	[new Topography]

$topo load_flatgrid 100 100

create-god $val(nn)

# Configure nodes
$ns node-config -adhocRouting $val(rp) \
                -llType $val(ll) \
                -macType $val(mac) \
                -ifqType $val(ifq) \
                -ifqLen $val(ifqlen) \
                -antType $val(ant) \
                -propType $val(prop) \
                -phyType $val(netif) \
                -topoInstance $topo \
                -channelType $val(chan) \
                -agentTrace ON \
                -routerTrace ON \
                -macTrace OFF \
                -movementTrace OFF

#set x 0.0
#set y 0.0
#set z 0.0 

for {set i 0} {$i < $val(nn) } {incr i} {
	set n($i) [$ns node]
    	$n($i) random-motion 0       ;# disable random motion
	set x [expr rand()*100]
	set y [expr rand()*100]	
	set z 0.0
	$n($i) set X_ $x
	$n($i) set Y_ $y
	$n($i) set Z_ $z
	# Label and coloring
	#$ns at 0.0 "$n($i) color black"
	#$ns at 0.0 "$n($1) label Node$i"
	#Size of the node
	$ns initial_node_pos $n($i) 20
	#to create static mobile node at position $x, $y, 0.0 with speed 0.0 m/s 
	$ns at 0.0 "$n($i) setdest $x $y 0.0" 
}

set src 0
set dest 8

#UDP connection with destination as $n(8)
set null0 [new Agent/Null]
#as we have single destination and multiple source nodes
$ns attach-agent $n($dest) $null0 
for {set i 0} {$i < $val(nn) } {incr i} {
	if { $i != $dest } {
		set udp($i) [new Agent/UDP]
		$ns attach-agent $n($i) $udp($i)
		$ns connect $udp($i) $null0
		$udp($i) set fid_ 1
		set cbr($i) [new Application/Traffic/CBR]
		$cbr($i) attach-agent $udp($i)
		$cbr($i) set packetSize_ 512
		$cbr($i) set rate_ 220Kb
		$ns at 2.0 "$cbr($i) start"
		$ns at 20.0 "$cbr($i) stop"
	}
}

#
# Tell nodes when the simulation ends
#
for {set i 0} {$i < $val(nn) } {incr i} {
    $ns at 30.0 "$n($i) reset";
}
$ns at 30.0001 "stop"
$ns at 30.0002 "puts \"NS EXITING...\" ; $ns halt"
proc stop {} {
    global ns tracefd
    close $tracefd
}

puts "Starting Simulation..."
$ns run
