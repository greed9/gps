import json
from pprint import pprint

#
# Configuration of visible satellites
# Also builds all child Sat rows
#
class Sky:
    def __init__( self, sky_json):
        self.sky = sky_json

    def insertSats( self, sky_id):
        for i in range( len( self.sky["satellites"])):
            sat = Sat( self.sky["satellites"][i] )
            sat.asInsert( sky_id )

    def emitCSV( self, sky_id):
        self.asCSV( sky_id )
        for i in range( len( self.sky["satellites"])):
            sat = Sat( self.sky["satellites"][i] )
            sat.asCSV( sky_id )

    def asCSV ( self,  sky_id ):
        print( "sky", end=',' )
        print( str(sky_id), end=',' )
        print(  str(self.sky["xdop"]), end=',' )
        print(  str(self.sky["ydop"]), end=',')
        print(  str(self.sky["vdop"]), end=',' )
        print(  str(self.sky["tdop"]), end=',')
        print(  str(self.sky["hdop"]), end=',' )
        print(  str(self.sky["gdop"]), end=',' )
        print(  str(self.sky["pdop"]) )

    def asInsert( self, sky_id ):
        print( "insert into sky" )
        print( "(" )
        print( "\tsky_id," )   # int not null
        print( "\txdop," )
        print( "\tydop," )
        print( "\tvdop," )
        print( "\ttdop," )
        print( "\thdop," )
        print( "\tgdop," )
        print( "\tpdop" )
        print( ")" )
        print( "values" )
        print( "(" )
        print( "\t" + "'" + str(sky_id) + "'," )
        print( "\t" + "'" + str(self.sky["xdop"]) + "'," )
        print( "\t" + "'" + str(self.sky["ydop"]) + "'," )
        print( "\t" + "'" + str(self.sky["vdop"]) + "'," )
        print( "\t" + "'" + str(self.sky["tdop"]) + "'," )
        print( "\t" + "'" + str(self.sky["hdop"]) + "'," )
        print( "\t" + "'" + str(self.sky["gdop"]) + "'," )
        print( "\t" + "'" + str(self.sky["pdop"]) + "'" )
        print( ");" )

 #
 # A single gps fix sentence
 #
class Fix:
    def __init__ ( self, tpv_json) :
        self.tpv = tpv_json

    def asCSV( self, sky_id):
        print( "fix", end=',')
        print( str(sky_id), end="," )
        print( self.tpv["time"], end="," )
        print( str(self.tpv["ept"]), end="," )
        print( str(self.tpv["lat"]), end="," )
        print( str(self.tpv["lon"]), end=",")
        print( str(self.tpv["alt"]), end=",")
        print( str(self.tpv["epx"]), end="," )
        print( str(self.tpv["epy"]), end="," )
        print( str(self.tpv["epv"]), end=",")
        print( str(self.tpv["track"]), end=",")
        print( str(self.tpv["speed"]), end=",")
        print( str(self.tpv["climb"]), end=",")
        print( str(self.tpv["eps"] ) )

    def asInsert ( self, sky_id ):
        print( "insert into fix" )
        print( "(" )
        print( "\tsky_id," )
        print( "\ttime," )
        print( "\tept," )
        print( "\tlat," )
        print( "\tlon," )
        print( "\talt," )
        print( "\tepx," )
        print( "\tepy," )
        print( "\tepv," )
        print( "\ttrack," )
        print( "\tspeed," )
        print( "\tclimb," )
        print( "\teps" )
        print( ")" )
        print( "values" )
        print( "(" )
        #print( "\t" + self.tpv["fix_id"] + "," )
        print( "\t" + str(sky_id) + "," )
        print( "\t" + "'" + self.tpv["time"] + "'," )
        print( "\t" + str(self.tpv["ept"]) + "," )
        print( "\t" + str(self.tpv["lat"]) + "," )
        print( "\t" + str(self.tpv["lon"]) + "," )
        print( "\t" + str(self.tpv["alt"]) + "," )
        print( "\t" + str(self.tpv["epx"]) + "," )
        print( "\t" + str(self.tpv["epy"]) + "," )
        print( "\t" + str(self.tpv["epv"]) + "," )
        print( "\t" + str(self.tpv["track"]) + "," )
        print( "\t" + str(self.tpv["speed"]) + "," )
        print( "\t" + str(self.tpv["climb"]) + "," )
        print( "\t" + str(self.tpv["eps"] ) )
        print( ");" )

#
# Info on an individual sat (from SKY record)
#
class Sat:
    def __init__(self, sky_json):
        self.sat = sky_json

    def asCSV( self, sky_id):
        if self.sat["used"] == True:
            used = 1
        else:
            used = 0

        print( "sat", end=',')
        print( str(sky_id), end=',' )
        print( str(self.sat["PRN"]), end=',' )
        print( str(self.sat["el"]), end=',' )
        print( str(self.sat["az"]), end=',' )
        print( str(self.sat["ss"]), end=',' )
        print( str(used) )

    def asInsert(self, sky_id):
        if self.sat["used"] == True:
            used = 1
        else:
            used = 0

        #print( "used=" + self.sat["used"])

        print( "insert into satellites" )
        print( "(" )
        print( "\tsky_id,")
        print( "\tprn," )
        print( "\tel," )
        print( "\taz," )
        print( "\tss," )
        print( "\tused" )
        print( ")" )
        print( "values" )
        print( "(" )
        print( "\t" + "'" + str(sky_id) + "'," )
        print( "\t" + "'" + str(self.sat["PRN"]) + "'," )
        print( "\t" + "'" + str(self.sat["el"]) + "'," )
        print( "\t" + "'" + str(self.sat["az"]) + "'," )
        print( "\t" + "'" + str(self.sat["ss"]) + "'," )
        print( "\t" + "'" + str(used) + "'" )
        print( ");" )

def main ( ):
    state = 0
    sky_id = 0
    with open('gps1.json') as data_file:
        for line in data_file:
            rec = json.loads(line)
            if state == 1:
                if rec["class"] == 'TPV':
                    tpv_insert = Fix ( rec )
                    tpv_insert.asCSV( sky_id )

            if rec["class"] == 'SKY':
                state = 1
                sky_id = sky_id + 1
                sky_insert = Sky ( rec )
                sky_insert.emitCSV ( sky_id )
                #sky_insert.asCSV( sky_id )

            #pprint(rec)
            #print( "len=" + str(len(rec["satellites"] )))
            #print( rec["satellites"][10]["PRN"])

if __name__ == "__main__":
	main ( )
