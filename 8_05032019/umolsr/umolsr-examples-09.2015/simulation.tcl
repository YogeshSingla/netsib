

# ======================================================================
# Define options
# ======================================================================
set val(chan)           Channel/WirelessChannel;   # channel type
set val(prop)           Propagation/TwoRayGround;  # radio-propagation model
set val(netif)          Phy/WirelessPhy;           # network interface type
set val(mac)            Mac/802_11;                # MAC type
set val(ll)             LL;                        # link layer type
set val(ant)            Antenna/OmniAntenna;       # antenna model
set val(ifq)            CMUPriQueue;
set val(ifqlen)         50;                        # max packet in ifq
set val(fic_tr)	        results;                   # nom du fichier trace

set val(nb_nodes)       [ lindex $argv 0 ];
set val(nb_cnx)    	    [ lindex $argv 1 ];
set val(pkts)           [ lindex $argv 2 ];
set val(duration)       [ lindex $argv 3 ];
set val(mobility)       [ lindex $argv 4 ];
set val(node_speed)     [ lindex $argv 5 ];
set val(packet_size)    [ lindex $argv 6 ];
set val(grid_size)      [ lindex $argv 7 ];
set val(proto)          [ lindex $argv 8 ];

Phy/WirelessPhy set bandwidth 11e6	
#Phy/WirelessPhy set RXThresh_ 3.65262e-10; # 250 m
#Phy/WirelessPhy set RXThresh_ 2.81838e-09#150m
#Phy/WirelessPhy set RXThresh_ 1.42681e-08; # 100 m
#Phy/WirelessPhy set RXThresh_ 7.69113e-08; # 50 m

Mac/802_11 set SlotTime_          0.000050;         # 50us
Mac/802_11 set SIFS_              0.000028;         # 28us
Mac/802_11 set PreambleLength_    0;                # no preamble
Mac/802_11 set PLCPHeaderLength_  128;              # 128 bits
Mac/802_11 set PLCPDataRate_      1.0e6;            # 1Mbps
Mac/802_11 set dataRate_          11.0e6;           # 11Mbps
Mac/802_11 set basicRate_         1.0e6;            # 1Mbps

# ======================================================================
# Main Program
# ======================================================================

#
# Initialize Global Variables
#

set ns_	[new Simulator]
$ns_ use-newtrace

set tracefd [open $val(fic_tr)_$val(proto)_$val(nb_nodes)_$val(nb_cnx)_$val(pkts)_$val(duration)_$val(mobility)_$val(node_speed)_$val(packet_size)_$val(grid_size).tr w]
#set namfd [open $val(fic_tr)_$val(proto)_$val(nb_nodes)_$val(nb_cnx)_$val(pkts)_$val(duration)_$val(mobility)_$val(node_speed)_$val(packet_size)_$val(grid_size).nam w]

$ns_ trace-all $tracefd
#$ns_ namtrace-all-wireless $namfd $val(grid_size) $val(grid_size)


# set up topography object
set topo [new Topography]
$topo load_flatgrid $val(grid_size) $val(grid_size)

#
# Create God
#
set god_ [create-god $val(nb_nodes)]

set chan_0 [new $val(chan)]

# configure node
$ns_ node-config -adhocRouting $val(proto) \
    -llType $val(ll) \
	-macType $val(mac) \
	-ifqType $val(ifq) \
	-ifqLen $val(ifqlen) \
	-antType $val(ant) \
	-propType $val(prop) \
	-phyType $val(netif) \
	-channel $chan_0 \
	-topoInstance $topo \
	-agentTrace ON \
	-routerTrace ON \
	-movementTrace OFF \
	-macTrace ON

for {set i 0} {$i < $val(nb_nodes) } {incr i} {
    set node_($i) [$ns_ node]
	$node_($i) random-motion 0;    # disable random motion
}

#
# Define node movement model
#
puts "Loading the mobility model..."
source mobility_$val(mobility)_$val(nb_nodes)_$val(duration)_$val(grid_size)_$val(node_speed).tcl

#
# Define traffic model
#
puts "Loading the traffic model..."
source traffic_$val(nb_nodes)_$val(nb_cnx)_$val(pkts)_$val(packet_size)_$val(duration).tcl

#
# Tell nodes when the simulation ends
#
for {set i 0} {$i < $val(nb_nodes) } {incr i} {
    $ns_ at $val(duration).0 "$node_($i) reset";
}

$ns_ at  $val(duration).0001 finish

$ns_ at  $val(duration).0002 "puts \"NS EXITING...\" ; $ns_ halt"

proc finish {} {
    global ns_ tracefd namfd
    $ns_ flush-trace
    close $tracefd
#    close $namfd
}

puts "Starting Simulation..."
$ns_ run


