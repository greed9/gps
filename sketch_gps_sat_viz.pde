// *****************************************************
// show positions calculated from gps over time
// *****************************************************
import java.time.* ;

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
float strokeColor = 50 ;
float gaugeColor = 344 ;
DataSeries currWindow ;

PFont font ;
// One time stuff here
void setup ( )
{
  size( 1600, 400 ) ;
  background( 0 ) ;
  font = loadFont ( "Courier10PitchBT-Bold-24.vlw" ) ;
  textFont ( font ) ;
   
  // In constrast to RBG, HSV allows us to adjust the "hotness" of colors to correspond
  // to altitudes. This allows 100 possible shades of color
  colorMode ( HSB, 100, 100, 100 ) ;
  
  // Read in all the data
  lines = loadStrings ( "/tmp/sat_view.csv" ) ;
  
  // Scale the centroid
  centroidY = map( centroidLat, minLat, maxLat, 0, height ) ;
  centroidX = map ( centroidLon, maxLon, minLon, 0, width ) ;

  // Use a window of 10 points for now
  currWindow = new DataSeries ( 500 ) ;
}

// Loop through the data
void draw ( )
{
  // Parse fields
  fields = splitTokens( lines[lineNo], "," ) ;
  String dtStr = fields[0].replace( "\"", "" ) ;
  String prn = fields[1] ;
  
  LocalDateTime ldt = LocalDateTime.parse(dtStr.replace( " " , "T" ) ) ;
  float az = float ( fields[2] ) ;
  float el = float ( fields[3] ) ;
  float ss = float ( fields[4] ) ; // signal strength for this sat
  
  // az, el and scale signal strength as brightness
  float x = map( az, 0, 360, 0, width ) ;
  float y = map ( el, 0, 90, height, 0 ) ;
  float bright = map ( ss, 0,40, 0, 100 ) ;
  
  // Capture the newest data point
  DataPoint dp = new DataPoint ( x, y, bright, prn, ldt ) ;
  
  // Plot the points in the current window
  plotCurrentWindow ( dp ) ;
  
  // Go until we run out of input lines
  if ( lineNo < lines.length - 100 )
  {
    lineNo += 59;
  }
  else
  {
    background ( 0 ) ;
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
  float size = 0 ;
  boolean oddEven = true ;
  DataPoint tmp = currWindow.last ( ) ;
  
  // Current line is fat
  //strokeWeight ( 10 ) ;
  if ( tmp != null )
  {
    //ellipse( tmp.x, tmp.y, 4, 4 ) ;
  }
  
  // Rest of data, newer to older
  while ( tmp != null )
  {
    bright = tmp.n ;
    size = bright / 10 ;
    fill ( 50, 100, bright ) ;
    //ellipse ( tmp.x, tmp.y, 10, 10 ) ;
    stroke( 100 ) ;
    //point ( tmp.x, tmp.y ) ;
    noStroke ( ) ;
    if ( oddEven ) 
    {
      text( ( String ) tmp.prn, tmp.x + 20 , tmp.y - 20) ;
      
      oddEven = !oddEven ;
    }
    fill ( 10, 100, bright ) ;
    ellipse( tmp.x, tmp.y, size , size ) ;
    stroke( 100 ) ;
    tmp = currWindow.prev ( ) ;
    
    // Fade the older lines progressively
    bright -= 0.1;
    //strokeWeight ( 1 ) ;

  }
}

// Single data point
class DataPoint
{
  public float x = 0 ;
  public float y = 0 ; 
  public float n = 0 ;
  public String prn = "" ;
  LocalDateTime ldt ;

  DataPoint ( float pX, float pY, float pSS, String pPrn, LocalDateTime pLdt  ) 
  {
    x = pX ;
    y = pY ;
    n = pSS ;
    prn = pPrn ;
    ldt = pLdt ;
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