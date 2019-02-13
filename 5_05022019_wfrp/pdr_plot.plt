#plt file for plotting pdr of different protocols like aodv, dsdv, dsr on gnuplot. Here \ works as hold on symbol in matlab to plot two #graphs in one figure simultaneously on gnuplot terminal all plots should be on same line for simultaneous plots or separated by \ on new #line as shown. 
#To execute the script type load <file_name> (here pdr_plot.plt) in " " in gnuplot terminal
#set graph properties
set title "Packet Delivery Ratio"
set xlabel "Number of mobile nodes"
set ylabel "Packet Delivery Ratio in % (out of 100)"
#set xrange [0:100]
#set yrange [0:100]
set autoscale

#set linestyles for plotting linegraphs of pdr
#set linestyle 1 to red
set style line 1 \
    linecolor rgb 'red' \
    linetype 1 linewidth 2 \
    pointtype 7 pointsize 1.5

#set linestyle 2 to green
set style line 2 \
    linecolor rgb 'green' \
    linetype 1 linewidth 2 \
    pointtype 7 pointsize 1.5

#set linestyle 3 to blue
set style line 3 \
    linecolor rgb 'blue' \
    linetype 1 linewidth 2 \
    pointtype 7 pointsize 1.5

plot "aodv_pdr.txt" using 1:2 title 'aodv_pdr' with linespoints linestyle 1, \
"dsdv_pdr.txt" using 1:2 title 'dsdv_pdr' with linespoints linestyle 2, \
"dsr_pdr.txt" using 1:2 title 'dsr_pdr' with linespoints linestyle 3
