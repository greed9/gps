set title 'Distance versus error'
set xlabel 'distance from centroid'
set ylabel 'error'
set term png
set output 'dist_vs_error.png'
set datafile separator ","
plot '/tmp/distances.csv' using 5:6
