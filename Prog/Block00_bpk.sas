/************************************************************************
  Program:  Block00_bpk.sas
  Library:  General
  Project:  DC Data Warehouse
  Author:   J. Dev
  Created:  02/16/17
  Version:  SAS 9.2
  Environment:  Windows
  
  Description:  Create Census 2000 block to Bridge Park area
  correspondence file.

  Adds correspondence format $bk0bpk. to local General library.

  Modifications:
************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( OCTO )

*options obs=50;

data General.Block00_bpk 
  (label="Census 2000 blocks (GeoBlk2000) to Bridge Park area (bridgepk) correspondence file");

  set OCTO.Block00_bpk;
  
  ** Census block ID **;
  
  %Octo_GeoBlk2000( check=y )

  ** Census tract, block group ID (needed for creating weight files) **;

  length GeoBg2000 $ 12 Geo2000 $ 11;
  
  GeoBg2000 = GeoBlk2000;
  Geo2000 = GeoBlk2000;
  
  label 
    GeoBg2000 = "Full census block group ID (2000): sscccttttttb"
    GEO2000 = "Full census tract ID (2000): ssccctttttt";

  ** Bridge Park var **;

  %Bridgepk( check=y )
  
  label 
    bridgepkID = "Bridge Park ID"
    CJRTRACTBL = "OCTO tract/block ID"
    x = "Block centroid X coord. (MD State Plane NAD 83 meters)"
    y = "Block centroid Y coord. (MD State Plane NAD 83 meters)"
  ;
  
  ** Remove silly formats/informats, unneeded variables **;
  
  format _all_ ;
  informat _all_ ;
  
  keep GeoBlk2000 GeoBg2000 Geo2000 bridgepkID bridgepk CJRTRACTBL x y;

run;

** Find duplicates **;
** Each block should be assigned to only one geographic unit **;

%Dup_check(
  data=General.Block00_bpk,
  by=GeoBlk2000,
  id=bridgepk
)

proc sort data=General.Block00_bpk nodupkey;
  by GeoBlk2000;

%File_info( data=General.Block00_bpk, stats=, freqvars=bridgepk  )

/*
** Delete old formats **;

proc catalog catalog=General.Formats;
  delete bk0wdaf bk0wdbf / entrytype=formatc;
quit;
*/

** Create correspondence format **;

%Data_to_format(
  FmtLib=General,
  FmtName=$bk0bpk,
  Data=General.Block00_bpk,
  Value=GeoBlk2000,
  Label=bridgepk,
  OtherLabel="",
  Desc="Block 2000 to Bridge Park area correspondence",
  Print=N,
  Contents=Y
  )

