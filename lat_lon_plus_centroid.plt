set title 'Fixes'
set xlabel 'Longitude'
set ylabel 'Latitude'
set term png
set output 'fixes.png'
set datafile separator ","
#set label at -81.51523422841227, 28.68889551140758, 0 "X" point pointtype 1 pointsize 10 
#set object circle at graph -81.51523422841227, 28.68889551140758 radius char 10  \
#    fillcolor rgb 'blue' fillstyle solid noborder
set autoscale
set style line 2 lc rgb 'black' pt 7   # circle
plot  '/tmp/distances.csv' using 2:3 with lines, \
    '/tmp/centroid.csv' using 2:1 with points ls 2
