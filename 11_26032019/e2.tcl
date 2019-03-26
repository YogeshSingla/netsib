set val(chan)           Channel/WirelessChannel    ;# channel type
set val(prop)           Propagation/TwoRayGround   ;# radio-
set val(netif)          Phy/WirelessPhy            ;# network

set val(mac)            Mac/802_11                 ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue

set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         100                         ;# max packet in ifq

set val(rp)             DSR                      ;# routing protocol
set val(x)              501
set val(y)              501
set val(stop)           100

set val(nn)             38                     ;# number of
set sr                  36
set bs                  37

set ns              [new Simulator]

if { $val(rp) == "DSR" } {
        #For DSR
        set val(ifq)          CMUPriQueue              ;# Interface queue type
} else {
        #For other protocols like AODV, DSDV
        set val(ifq)          Queue/DropTail/PriQueue  ;# Interface queue type
}


proc myRand {min max} {
    expr {int(rand() * ($max + 1 - $min)) + $min}
}

#Creating trace file and nam file.
set tracefd       [open out.tr w]
set namtrace      [open out.nam w]  
$ns use-newtrace
$ns trace-all $tracefd
$ns namtrace-all-wireless $namtrace $val(x) $val(y)

# set up topography object
set topo [new Topography]

$topo load_flatgrid $val(x) $val(y)

set god_ [create-god $val(nn)]

for {set i 0} {$i <= $val(nn)} {incr i} {
  set chan_($i) [new $val(chan)]
}

# configure the nodes
$ns node-config -adhocRouting $val(rp) \
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
           -movementTrace ON
                  
# Creating node objects..          
for {set i 0} {$i < $val(nn)} { incr i } {
            set node_($i) [$ns node]    
}
for {set i 0} {$i < $val(nn)  } {incr i } {
      $node_($i) color black
      $ns at 0.0 "$node_($i) color black"
}

# Provide initial location of mobilenodes
$node_($sr) set X_ 2.0
$node_($sr) set Y_ 2.0
$node_($sr) set Z_ 0.0
$node_($bs) set X_ 20.0
$node_($bs) set Y_ 20.0
$node_($bs) set Z_ 0.0


namespace import ::tcl::mathfunc::* ;# for using sin, cos functions
set namsize 50 ; # node size in nam file
set cx 100     ;# cx, cy the center of circle
set cy 50
set r [expr $cx]          ;# radius of circle
set PI 3.14159265358979323846                      ;# iterator used in for loop


set k 0
for {set i 50} {$i < 301 && $k < $val(nn)-1} {incr i 50} {
  for {set j 50} {$j < 301 && $k < $val(nn)-1} {incr j 50} {
    set angle [ expr (45.0) * ($PI / 180) ]
    set pointx [ expr $cx + ($j * cos ($angle)) - ($i * sin ($angle))]
    set pointy [ expr $cy + ($i * cos ($angle)) + ($j * sin ($angle))]
    $node_($k) set X_ $pointx
    $node_($k) set Y_ $pointy
    $node_($k) set Z_ 0.0
    incr k
  }
}

# Define node initial position in nam
for {set i 0} {$i < $val(nn)} { incr i } {
  # 30 defines the node size for nam
  $ns initial_node_pos $node_($i) 15
}

# $ns at 49.0 "$node_($bs) setdest 125.0 75.0 50.0"
# $ns at 0.2 "$node_($sr) setdest 10.0 10.0 25.0"
# $ns at 25.2 "$node_($sr) setdest 10.0 490.0 25.0"
# $ns at 50.2 "$node_($sr) setdest 490.0 490.0 25.0"
# $ns at 75.2 "$node_($sr) setdest 490.0 10.0 25.0" 

#set basestation
$node_($bs) set X_ 150
$node_($bs) set Y_ 250
$node_($bs) set Z_ 0.0


$ns at 0.2 "$node_($sr) setdest 2.0 2.0 25.0" 
$ns at 25.0 "$node_($sr) setdest 250.0 250.0 50.0"
$ns at 50.0 "$node_($sr) setdest 2.0 500.0 50.0"
$ns at 75.0 "$node_($sr) setdest 500.0 500.0 50.0"
$ns at 80.0 "$node_($sr) setdest 500.0 2.0 50.0"


set udp [new Agent/UDP]
$ns attach-agent $node_($sr) $udp
set null [new Agent/Null]
$ns attach-agent $node_($bs) $null
$ns connect $udp $null
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set packetSize_ 512
#$cbr set rate_ 200kb
$cbr set interval_ 0.1
$ns at 0.0 "$cbr start"
$ns at 100.0 "$cbr stop"


# Telling nodes when the simulation ends
for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "$node_($i) reset";
}

# ending nam and the simulation
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "stop"
$ns at 100.01 "puts \"end simulation\" ; $ns halt"
proc stop {} {
    global ns tracefd namtrace
    $ns flush-trace
    close $tracefd
    close $namtrace
        #exec nam -r 5m out.nam &
    exit 0
}
$ns run
