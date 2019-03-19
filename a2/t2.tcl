set val(chan)           Channel/WirelessChannel    ;# channel type
set val(prop)           Propagation/TwoRayGround   ;# radio-
set val(netif)          Phy/WirelessPhy            ;# network

set val(mac)            Mac/802_11                 ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue

set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         100                         ;# max packet in ifq

set val(rp)             DSR                     ;# routing protocol
set val(x)              502
set val(y)              502
set val(stop)           100

set val(nn)             51                     ;# number of
set sr                  0        ;
set bs                  50  ;

set ns              [new Simulator]


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


# set k 0
# for {set i 50} {$i < 501 && $k < $val(nn)-1} {incr i 50} {
#   for {set j 50} {$j < 501 && $k < $val(nn)-1} {incr j 50} {
#     $node_($k) set X_ $j
#     $node_($k) set Y_ $i
#     $node_($k) set Z_ 0.0
#     incr k
#   }
# }


namespace import ::tcl::mathfunc::* ;# for using sin, cos functions
set namsize 50 ; # node size in nam file
set cx 250     ;# cx, cy the center of circle
set cy 250
set r [expr $cx]          ;# radius of circle
set PI 3.14159265358979323846
set ncars $val(nn)             ;# total number of cars
set lane 3                    ;# number lanes on the highway
set CarsPerLane [expr $ncars / $lane];# number of cars per lane
set CarsInFor [expr $ncars / $lane];# equal to CarsInLane. used in for loop
set i 0                       ;# iterator used in for loop

# set node initial position, in this loop we distribute all node evenly at all lanes
for {set counter 0} {$counter < $lane} {incr counter} {
    while { $i < $CarsInFor  } {
            set node_($i) [$ns node]
            set angle [ expr ((360.0 / $CarsPerLane) * $i) * ($PI / 180) ]
            set pointx [ expr $cx + ($r * cos ($angle))]
            set pointy [ expr $cy + ($r * sin ($angle))]
            $node_($i) set X_ $pointx
            $node_($i) set Y_ $pointy
            $node_($i) set Z_ 0.0
            $ns at 0.0 "$node_($i) setdest $pointx $pointy 0.0"
            set tcl_precision 3
            #puts "Lane $counter N $i X = $pointx, Y = $pointy, Angle = $angle" ; # for logging only
            incr i
            }   
     set r [expr $r - $namsize]
     set CarsInFor [expr $CarsInFor + $CarsPerLane]
}

#$ns at 0.0 "$node_(0) setdest 250.0 250.0 0.0"
#$ns at 0.0 "$node_(0) setdest 2.0 2.0 0.0"


# # Define node initial position in nam
# for {set i 0} {$i < $val(nn)} { incr i } {
#   # 30 defines the node size for nam
#   $ns initial_node_pos $node_($i) 15
# }

$ns at 10.2 "$node_(0) setdest 250.0 250.0 25.0" 
$ns at 49.0 "$node_(0) setdest 500.0 2.0 50.0"
$ns at 79.0 "$node_(0) setdest 50.0 400.0 50.0"

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
