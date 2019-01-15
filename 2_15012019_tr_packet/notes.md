##Lab : Day-2
### Overview
* tr packet format
* use of awk in analysing tr packet. each packet registers around 8 records in tr file. awk file can be used to analyse large files.

### AWK basics
#### Format
3 blocks:  
```
BEGIN {}
{}
END {}
```
#### Execution
	awk -f <filename.awk> <filename.tr>

### Files
exp1 : first network simulation of a 5 node network to analyse tcp and udp packet flow using awk