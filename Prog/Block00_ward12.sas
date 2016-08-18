/************************************************************************
  Program:  Block00_Ward12.sas
  Library:  General
  Project:  DC Data Warehouse
  Author:   P. Tatian
  Created:  07/04/12
  Version:  SAS 9.2
  Environment:  Windows
  
  Description:  Create Census 2000 block to Ward (2012) 
  correspondence file.

  Adds correspondence format $bk0wdaf. to local General library.

  Modifications:
************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( OCTO )

*options obs=50;

data General.Block00_Ward12 
  (label="Census 2000 blocks (GeoBlk2000) to Wards (Ward2012) correspondence file");

  set OCTO.Block00_ward12;
  
  ** Census block ID **;
  
  %Octo_GeoBlk2000( check=y )

  ** Census tract, block group ID (needed for creating weight files) **;

  length GeoBg2000 $ 12 Geo2000 $ 11;
  
  GeoBg2000 = GeoBlk2000;
  Geo2000 = GeoBlk2000;
  
  label 
    GeoBg2000 = "Full census block group ID (2000): sscccttttttb"
    GEO2000 = "Full census tract ID (2000): ssccctttttt";

  ** Ward2012 var **;

  %Octo_Ward2012( check=y )
  
  label 
    Ward = "OCTO Ward ID"
    NAME = "OCTO Ward name"
    CJRTRACTBL = "OCTO tract/block ID"
    x = "Block centroid X coord. (MD State Plane NAD 83 meters)"
    y = "Block centroid Y coord. (MD State Plane NAD 83 meters)"
  ;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2000 GeoBg2000 Geo2000 Ward2012 Ward NAME CJRTRACTBL x y;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=General.Block00_Ward12,
  by=GeoBlk2000,
  id=Ward2012
)

proc sort data=General.Block00_Ward12 nodupkey;
  by GeoBlk2000;

%File_info( data=General.Block00_Ward12, stats=, freqvars=Ward2012  )

/*
** Delete old formats **;

proc catalog catalog=General.Formats;
  delete bk0wdaf bk0wdbf / entrytype=formatc;
quit;
*/

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk0wdaf,
  Data=General.Block00_Ward12,
  Value=GeoBlk2000,
  Label=Ward2012,
  OtherLabel="",
  Desc="Block 2000 to Ward 2012 correspondence",
  Print=N,
  Contents=Y
  )

