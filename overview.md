ns2 good start for beginners. ns3 does not come with tcl and only supports cpp. Hence, we would be using ns2.
ns2 buld with cpp(for the structural core of ns2) and tcl (scripting language)

we will be using tcl for this course only. :P


## Installation of ns2.35
Download the zipped file of around 50Mb from here.
https://sourceforge.net/projects/nsnam/

Use the link of blogpost to follow the detailed steps for installation.
http://installwithme.blogspot.com/2014/05/how-to-install-ns-2.35-in-ubuntu-13.10-or-14.04.html

## Installation of ns2.34 on Ubuntu 18.04
1. Install 
```

sudo apt install gcc-4.8 g++-4.8
```
2. Follow all the steps at: http://surajpatilworld.blogspot.com/2015/02/step-by-step-installation-of-ns-234-on.html
Note the typo of ns2.35 in step 5. This step has to be done for ns2.34 as well.
Line number for step 6 is 6304 as given at https://www.nsnam.com/2011/08/ns234-installation-in-ubuntu-1104.html
Most likely you will be using newer version of gcc and g++. 
Before running the ./install command export the older gcc and g++.```export CC=gcc-4.8 CXX=g++-4.8```.

3. ns and nam are working after this steps in Ubuntu 18.04 on a 64 bit machine.

## ns2 logical stack
cpp : Properties and structure
tcl : scripts built to use the ns2 cpp files
nam : network animator for user view (UI)
tr  : performance measurements in the trace file

Details of trace file can be found here:https://www.isi.edu/nsnam/ns/doc/node289.html

## record
* No lines of code
* Only procedure
* Write theory related to question
* Observations : which protocols performed better
* Present logic
* Explain terms
* Don't repeat theory terms between experiements. Avoid redundancies.


## References
1. The basics of ns are here: http://nile.wpi.edu/NS/simple_ns.html. This is useful to understand the tcl file.
2. Intermediate ns: https://www-sop.inria.fr/members/Eitan.Altman/ns.htm
3. http://nile.wpi.edu/NS/
4. Install ns2 in Ubuntu 18.04 https://www.nsnam.com/2018/06/installation-of-ns2-in-ubuntu-1804.html
***
lrktni$wlgrbgftrlrktni$wl
