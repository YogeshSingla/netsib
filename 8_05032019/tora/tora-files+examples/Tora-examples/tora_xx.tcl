### http://forums.techarena.in/networking-security/1127469.htm


set opt(imep) "ON" ;# Enable/Disable IMEP
# set opt(ragent) Agent/rtProto/TORA
set opt(ragent) Agent/TORA
set opt(pos) NONE ;# Box or NONE
if { $opt(pos) == "Box" } {
puts "*** TORA using Box configuration..."
}
#
Agent instproc init args {
$self next $args
}
Agent/rtProto instproc init args {
puts "DOWN HERE 2"
$self next $args
}
# Agent/rtProto/TORA instproc init args {
Agent/TORA instproc init args {
puts "DOWN HERE"
$self next $args
}
Agent/TORA set sport_ 0
# Agent/rtProto/TORA set sport_ 0
Agent/TORA set dport_ 0
# Agent/rtProto/TORA set dport_ 0
#
proc create-routing-agent { node id } {
}
global ns_ ragent_ tracefd opt
#
# Create the Routing Agent and attach it to port 255.
#
set ragent_($id) [new $opt(ragent) $id]
set ragent $ragent_($id)
$node attach $ragent [Node set rtagent_port_]
$ragent if-queue [$node set ifq_(0)] ;# ifq between LL and MAC
# now that the Beacon/Hello messages have been
# moved to the IMEP layer, this is not necessary.
$ns_ at 0.$id "$ragent_($id) start" ;# start BEACON/HELLO Messages
#
# XXX: The routing protocol and the IMEP agents needs handles
# to each other.
#
$ragent imep-agent [$node set imep_(0)]
[$node set imep_(0)] rtagent $ragent
#
# Drop Target (always on regardless of other tracing)
#
set drpT [cmu-trace Drop "RTR" $node]
$ragent drop-target $drpT
#
# Log Target
#
set T [new Trace/Generic]
$T target [$ns_ set nullAgent_]
$T attach $tracefd
$T set src_ $id
$ragent log-target $T
#
# XXX: let the IMEP agent use the same log target.
#
[$node set imep_(0)] log-target $T
proc create-mobile-node { id } {
global ns_ chan prop topo tracefd opt node_
global chan prop tracefd topo opt
set node_($id) [new Node/MobileNode]
set node $node_($id)
$node random-motion 0 ;# disable random motion
$node topography $topo
#
# This Trace Target is used to log changes in direction
# and velocity for the mobile node.
#
set T [new Trace/Generic]
$T target [$ns_ set nullAgent_]
$T attach $tracefd
$T set src_ $id
$node log-target $T

$node add-interface $chan $prop $opt(ll) $opt(mac) \
$opt(ifq) $opt(ifqlen) $opt(netif) $opt(ant)
#
# Create a Routing Agent for the Node
#
create-routing-agent $node $id
if { $opt(pos) == "Box" } {
#
# Box Configuration
#
set spacing 200
set maxrow 7
set col [expr ($id - 1) % $maxrow]
set row [expr ($id - 1) / $maxrow]
$node set X_ [expr $col * $spacing]
$node set Y_ [expr $row * $spacing]
$node set Z_ 0.0
$node set speed_ 0.0

$ns_ at 0.0 "$node_($id) start"
}
}
