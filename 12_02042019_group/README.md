# Final Group Evaluation 
## Question
Propose a new cluster head selection method for PEGASIS routing protocol. Compare it with existing PEGASIS protocol in terms of number of nodes alive, energy consumption, packet delivery ratio and end to end delay. (Take number of nodes as 10,20,30,40...100)

## Theory

PEGASIS: Power-Efficient GAthering in Sensor Information Systems


## Execution 
### Challenges
**Ns-2.34/ is the last version with a 'mac/' setup that allows the "MIT leach" to be used.**

### Installing pegasis
1. Download patch from :https://www.linuxquestions.org/questions/linux-wireless-networking-41/how-to-install-mannasim-in-ns2-34-in-ubuntu14-04-a-4175520564/#post5246816

2. Follow the steps 5 and 6 from https://sipnoobs.wordpress.com/2015/01/05/guidance-to-run-pegasis-and-leach-on-ns-2-2-34/

3. Use correct gcc complier for steps 7 and 8. For me it was:
```
kirito@kirito-HP-Notebook:~/my_ns/gp$ export CC=gcc-4.8 CXX=g++-4.8
```

4. Follow step 9-13 adding your path instead of 'wsn'

## Ref
http://network-simulator-ns-2.7690.n7.nabble.com/Source-code-of-PEGASIS-for-NS2-34-td29323.html
matlab imp: http://www.njavaid.com/downloads.aspx
https://sipnoobs.wordpress.com/2015/01/05/guidance-to-run-pegasis-and-leach-on-ns-2-2-34/
