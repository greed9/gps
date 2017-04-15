# Split input file into seperate csv files
# for loading into mysql, based on 1st column
/sat/ {
  sub ( /sat,/, "", $0)
  filename = "sat.csv"
  printf( "%d,%s\n", loc, $0) >filename
}

/fix/ {
  sub ( /fix,/, "", $0)
  filename = "fix.csv"
  printf( "%d,%s\n", loc, $0) >filename
}

# These need a location as well as an id
/sky/ {
  sub ( /sky,/, "", $0)
  filename = "sky.csv"
  printf( "%d,%s\n", loc, $0) >filename
}
