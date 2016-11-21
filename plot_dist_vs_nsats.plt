set title 'Distance versus number of satellites'
set xlabel 'distance from centroid'
set ylabel 'number of satellites'
set term png
set output 'dist_vs_nsats.png'
set datafile separator ","
plot '/tmp/distances.csv' using 5:7
