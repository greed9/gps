set size square
set angles degrees
set polar
set grid polar 30
set xtics 30
unset border
unset param
set xrange[-90:90]
set yrange[-90:90]
set rrange[0:360]
set trange[0:90]

set title "GPS satellite tracks"
set xlabel "Azimuth"
set ylabel "Elevation"
set terminal png size 600,600
set output "gpsazel.png"
plot "/tmp/distances.csv" using 2:3 
