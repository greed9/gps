// *****************************************************
// show positions calculated from gps over time
// This version recomputes the centroids as it runs
// *****************************************************
var lines= [] ;              // Holds lines from file read with loadStrings ( )
var fields = [] ;             // Split each line into these, using spaces as a delimiter
var lineNo = 0 ;
/*
var minLat = 28.688676667 ;
var maxLat = 28.689081667 ;
var minLon = -81.515453333 ;
var maxLon = -81.515078333 ;
*/
//var minLat = 28.524881667 ;
var minLat = 28.523 ;
//var maxLat = 28.531685 ;
var maxLat = 28.532 ;
var minLon = -81.464466667;
var maxLon = -81.463121667 ;
//var centroidLat = 28.68889551140758 ;
//var tmpCentroidLat = centroidLat ;
var realCentroidLat4 = 28.525015660561806 ;
var realCentroidLon4 = -81.4639580134449 ;
var realCentroidLat3 = 28.52454463974104 ;
var realCentroidLon3 = -81.46436876073162 ;
var tmpCentroidLon = realCentroidLon3 ;
var tmpCentroidLat = realCentroidLat3 ;
var centroidY = 0 ;
var centroidX = 0 ;
var strokeColor = 50 ;
var gaugeColor = 344 ;
var currWindow ;
var W = 0 ;
var osc ;
var envelope ;

// Load the data synchronously
function preload ( ) {
    // Read in all the data
    lines = loadStrings ( "./distances2.csv" ) ;
}

// One time stuff here
function setup ( ){
  createCanvas( 500, 500 ) ;
  background( 0 ) ;

  currWindow = new DataSeries( 100 ) ;

  // sound example adapted from p5js.org sound-note-envelope example
  osc = new p5.Oscillator('sine');
  envelope = new p5.Env ( ) ;
  envelope.setADSR( 0.001, 0.5, 0.1, 0.1 ) ;
  envelope.setRange( 1, 0) ;
  osc.start ( ) ;
  osc.freq( 300 ) ;

  // In constrast to RBG, HSV allows us to adjust the "hotness" of colors to correspond
  // to altitudes. This allows 100 possible shades of color
  colorMode ( HSB, 100, 100, 100 ) ;

  // Scale the centroid
  centroidY = map( realCentroidLat4, maxLat, minLat, 0, height ) ;
  centroidX = map ( realCentroidLon4, minLon, maxLon, 0, width ) ;
  fill ( 50, 100, 100 ) ;
  rect(centroidX, centroidY, 5, 5 ) ;

  centroidY = map( realCentroidLat3, maxLat, minLat, 0, height ) ;
  centroidX = map ( realCentroidLon3, minLon, maxLon, 0, width ) ;
  fill ( 75, 100, 100 ) ;
  ellipse(centroidX, centroidY, 10, 10 ) ;

  // Use a window of 100 points for now
  currWindow = new DataSeries ( 500 ) ;

  // reference points
  var westLong = map ( minLon, minLon, maxLon, 5, width - 5) ;
  var eastLong = map ( maxLon, minLon, maxLon, 5, width - 20) ;
  var northLat = map( minLat, minLat, maxLat, 20, height ) ;
  var southLat = map( maxLat, minLat, maxLat, 5, height - 20 ) ;
  fill( 10, 100, 100 ) ;
  textSize ( 32 ) ;
  text ( "W", westLong, 200 ) ;
  text( "E", eastLong, 200 ) ;
  text ( "N", width / 2, northLat, 40 ) ;
  text ( "S", width / 2, southLat, 20 ) ;

  //rect ( eastLong, 200, 10, 10 ) ;
}

// Loop through the data
function draw ( ){
  // Parse fields
  fields = splitTokens( lines[lineNo], "," ) ;
  var lat = float ( fields[1] ) ;
  var lon = float ( fields[2] ) ;
  var pdop = float ( fields[6] ) ; // pdop for this fix
  //console.log( lon) ;

  // Compute running centroid
  W ++ ;
  tmpCentroidLat = tmpCentroidLat + ((lat - tmpCentroidLat)/W) ;
  tmpCentroidLon = tmpCentroidLon + ((lon - tmpCentroidLon)/W) ;

  // Scale the centroid
  tmpCentroidY = map( realCentroidLat4, maxLat, minLat, 0, height ) ;
  tmpCentroidX = map ( realCentroidLon4, minLon, maxLon, 0, width ) ;

  // Scale lat and lon -- could be backwards, flipped, etc?
  var y = map( lat, maxLat, minLat, 0, height ) ;
  var x = map ( lon, minLon, maxLon, 0, width ) ;
  var p = map ( pdop, 0, 10, 0, 100 ) ;

  // Capture the newest data point
  var dp = new DataPoint ( x, y, p) ;

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
function plotCurrentWindow ( dp ){
  // append newest data point
  currWindow.add ( dp ) ;

  // Clear the old image
  //background ( 0 ) ;

  // Set up to fade older lines
  var bright = 100 ;
  var tmp = currWindow.last ( ) ;

  if( W % 10 == 0 )
  {
    var dist = sqrt( pow ( tmpCentroidX - dp.x, 2) + pow ( tmpCentroidY - dp.y, 2) ) ;
    osc.freq( dist * 10 ) ;
    envelope.play( osc, 0, 0.05 ) ;
  }

  // Current line is fat
  strokeWeight ( 4 ) ;

  // Rest of data, newer to older
  while ( tmp != null )
  {
    //var dist = sqrt( pow ( tmpCentroidX - tmp.x, 2) + pow ( tmpCentroidY - tmp.y, 2) ) ;
    //osc.amp(.5);
    //osc.start();
    //osc.freq( dist * 10 ) ;
    //osc.freq(400);
    strokeColor = tmp.n ;
    //strokeColor = 100 ;
    stroke( strokeColor, 100, bright ) ;
    line( tmpCentroidX, tmpCentroidY, tmp.x, tmp.y ) ;
    //console.log ( tmp.x ) ;
    //var barY = height - 50 ;
    //var barX = width / 2 ;
    //stroke( gaugeColor, 100, 100 ) ;
    //strokeWeight( 4 ) ;
    //line( barX - (tmp.n / 2), barY, barX + ( tmp.n / 2), barY ) ;
    strokeWeight ( 1 ) ;
    stroke( strokeColor, 100, bright ) ;
    //rect( barX, barY, 5, tmp.n * 10 ) ;
    //println ( tmp.n ) ;
    tmp = currWindow.prev ( ) ;

    // Fade the older lines progressively
    bright -= 1 ;
    strokeWeight ( 1 ) ;

  }
}

// Single data point converted from Java/Processing class
function DataPoint ( pRawValueX, pRawValueY, pNsats ) {
  this.x = pRawValueX ;
  this.y = pRawValueY ;
  this.n = pNsats ;
} ;

// Collection of Data Points
function DataSeries ( pMaxElements ) {

  this.currentDataPoint = 0 ;
  this.maxElements = pMaxElements ;
  this.points = [] ;

  this.getNElements = function( ) {
    return points.length ;
  }

  // Return the first data point in the ArrayList
  this.first = function( ) {
    this.currentDataPoint = 0 ;
    return this.next ( ) ;
  }

  // Return the last data point in the series
  this.last = function ( ) {
    this.currentDataPoint = this.points.length - 1  ;
    return this.prev ( ) ;
  }

  // iterate, back to front
  this.prev = function ( ) {
    if ( this.currentDataPoint > 0 )  {
      var tmp = this.points[this.currentDataPoint] ;
      this.currentDataPoint -- ;
      return tmp ;
    } else {
      return null ;
    }
  }

  // Return the next data point in the ArrayList
  // or null if at end of list
  // Iterate front to back
  this.next = function ( ) {
    if ( this.currentDataPoint < this.points.length - 1 ) {
      var tmp =  this.points.get[this.currentDataPoint] ;
      this.currentDataPoint ++ ;
      return tmp ;
    } else {
      return null ;
    }
  }

  // Add (append) a datapoint to the back of the queue
  // Delete element at head (oldest)
  this.add = function ( pDp ) {

    if ( this.points.length >= this.maxElements ) {
     this.points.shift ( ) ;
    }
    this.points.push( pDp ) ;
  }
} ;
