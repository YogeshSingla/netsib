# Question
Compare the performace of AODV, DSR and DSDV in terms of PDR, Throughput and End-to-end delay (100m x 100m).
Plot graphs for comparison.
x-axis: no of nodes
y-axis: metrics
raffic type: cbr
packet size - 512B
nodes movement - static

## solution
### New tr file :
```
r -t 0.000000000 -Hs 7 -Hd -2 -Ni 7 -Nx 49.53 -Ny 22.53 -Nz 0.00 -Ne -1.000000 -Nl RTR -Nw --- -Ma 0 -Md 0 -Ms 0 -Mt 0 -Is 7.0 -Id 1.5 -It cbr -Il 512 -If 2 -Ii 5 -Iv 32 -Pn cbr -Pi 0 -Pf 0 -Po 0 
```

```
r[1] -t[2] 0.000000000[3] 
-Hs[4] 7[5] -Hd[6] -2[7] 
-Ni[8] 7[9] -Nx[10] 49.53[11] -Ny[12] 22.53[13] -Nz[14] 0.00[15] -Ne[16] -1.000000[17] -Nl[18] RTR[19] -Nw[20] ---[21] 
-Ma[22] 0[23] -Md[24] 0[25] -Ms[26] 0[27] -Mt[28] 0[29] 
-Is[30] 7.0[31] -Id[32] 1.5[33] -It[34] cbr[35] -Il[36] 512[37] -If[38] 2[39] -Ii[40] 5[41] -Iv[42] 32[43] 
-Pn[44] cbr[45] -Pi[46] 0[47] -Pf[48] 0[49] -Po[51] 0[51] 
```
[1] : event type send(s), receive(r), drop(d), forward(f)
[2] : general tag for time or global settings
[3] : 
[4] :
[8] - [21] : Node property tags 
[22]-[29] : MAC level tags
[30]-[43] : IP level tags
[44]-[51] : Packet info at Application level

### Results
Nodes 	:		10		20		30		40		50		60		70		80		90		100
PDR 	:		0.8622	0.3320	0.2196	0.1496	0.1470	0.1209	0.1004	0.0802	0.0625	0.0236
