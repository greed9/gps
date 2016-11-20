// *****************************************************
// show positions calculated from gps over time
// *****************************************************
String lines[] ;              // Holds lines from file read with loadStrings ( )
String fields[] ;             // Split each line into these, using spaces as a delimiter
int lineNo = 0 ;
float minLat = 28.688676667 ;
float maxLat = 28.689081667 ;
float minLon = -81.515453333 ;
float maxLon = -81.515078333 ;
float centroidLat = 28.68889551140758 ;
float centroidLon = -81.51523422841227 ;
float centroidY = 0 ;
float centroidX = 0 ;
DataSeries currWindow ;

// One time stuff here
void setup ( )
{
  size( 400, 400 ) ;
  background( 0 ) ;
  
  // In constrast to RBG, HSV allows us to adjust the "hotness" of colors to correspond
  // to altitudes. This allows 100 possible shades of color
  colorMode ( HSB, 100, 100, 100 ) ;
  
  // Read in all the data
  lines = loadStrings ( "/tmp/distances.csv" ) ;
  
  // Scale the centroid
  centroidY = map( centroidLat, minLat, maxLat, 0, height ) ;
  centroidX = map ( centroidLon, maxLon, minLon, 0, width ) ;

  // Use a window of 100 points for now
  currWindow = new DataSeries ( 100 ) ;
}

// Loop through the data
void draw ( )
{
  // Parse fields
  fields = splitTokens( lines[lineNo], "," ) ;
  float lat = float ( fields[1] ) ;
  float lon = float ( fields[2] ) ;
  
  // Scale lat and lon -- could be backwards, flipped, etc?
  float y = map( lat, minLat, maxLat, 0, height ) ;
  float x = map ( lon, maxLon, minLon, 0, width ) ;
  
  // Capture the newest data point
  DataPoint dp = new DataPoint ( x, y ) ;
  
  // Plot the points in the current window
  plotCurrentWindow ( dp ) ;
  
  // Go until we run out of input lines
  if ( lineNo < lines.length )
  {
    lineNo ++ ;
  }
}

// Add dp to queue, iterate backwards through the DataSeries,
// Plotting each line from the centroid to the data point
void plotCurrentWindow ( DataPoint dp )
{
  // append newest data point
  currWindow.add ( dp ) ;
  
  // Clear the old image
  background ( 0 ) ;
  
  // Set up to fade older lines
  float bright = 100 ;
  DataPoint tmp = currWindow.last ( ) ;
  
  // Current line is fat
  strokeWeight ( 4 ) ;
  
  // Rest of data, newer to older
  while ( tmp != null )
  {
    stroke( 50, 100, bright ) ;
    line( centroidX, centroidY, tmp.x, tmp.y ) ;
    tmp = currWindow.prev ( ) ;
    
    // Fade the older lines progressively
    bright -= 1 ;
    strokeWeight ( 1 ) ;
  }
}

// Single data point
class DataPoint
{
  public float x = 0 ;
  public float y = 0 ; 

  DataPoint ( float pRawValueX, float pRawValueY ) 
  {
    x = pRawValueX ;
    y = pRawValueY ;
  }
} 
;

// Collection of Data Points
class DataSeries
{
  ArrayList points = null ;
  int maxElements = 0 ;
  int currentDataPoint = 0 ;

  int getNElements ( )
  {
    return points.size ( ) ;
  }

  DataSeries ( int pMaxElements )
  {
    points = new ArrayList<DataPoint> ( ) ;
    maxElements = pMaxElements ;
  }

  // Return the first data point in the ArrayList
  DataPoint first ( )
  {
    currentDataPoint = 0 ;
    return this.next ( ) ;
  }
  
  // Return the last data point in the series
  DataPoint last( )
  {
    currentDataPoint = points.size( ) - 1  ;
    return this.prev ( ) ;
  }

  // iterate, back to front
  DataPoint prev ( )
  {
    if ( currentDataPoint > 0 )
    {
      DataPoint tmp =  ( DataPoint ) points.get ( currentDataPoint ) ;
      currentDataPoint -- ;
      return tmp ;
    } else
    {
      return null ;
    }
  }
  
  // Return the next data point in the ArrayList
  // or null if at end of list
  // Iterate front to back
  DataPoint next ( )
  {
    if ( currentDataPoint < points.size ( ) - 1 )
    {
      DataPoint tmp =  ( DataPoint ) points.get ( currentDataPoint ) ;
      currentDataPoint ++ ;
      return tmp ;
    } else
    {
      return null ;
    }
  }

  // Add (append) a datapoint to the back of the queue
  // Delete element at head (oldest)
  void add ( DataPoint pDp )
  {

    if ( points.size ( ) < maxElements )
    {
      points.add ( pDp ) ;
    } else
    {
      DataPoint tmp = ( DataPoint ) points.get(points.size() - 1) ;
      points.remove ( 0 ) ;
      points.add ( pDp ) ;
    }
  }
} ;